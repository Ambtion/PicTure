//
//  SCPSQLiteManager.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPSQLiteManager.h"


static int SelectTasksListCallback(void *retData, int argc, char **argv, char **azColName)
{
    NSMutableArray *tasksList = (NSMutableArray *) retData;
    SCPTaskList *taskList = [[SCPTaskList alloc] init];
    for (int i = 0; i < argc; i++) {
        NSString *data = [NSString stringWithFormat:@"%s", argv[i]];
        switch (i) {
            case TASKLIST_TASKLISTID:
                taskList.key = [data integerValue];
                break;
            case TASKLIST_ALBUMID:
                //                taskList.albumId = [data integerValue];
                taskList.albumId = data;
                
                break;
            case TASKLIST_ISFINISHED:
                taskList.isFinished = [data boolValue];
                break;
            default:
                break;
        }
    }
    [tasksList addObject:taskList];
    [taskList release];
    return 0;
}

//select task callback
static int SelectTaskListCallback(void *retData, int argc, char **argv, char **azColName)
{
    NSMutableArray *taskList = retData;
    SCPTask *task = [[SCPTask alloc] init];
    for (int i = 0; i < argc; i++) {
        NSString *data = [NSString stringWithFormat:@"%s", argv[i]];
        switch (i) {
            case TASK_TASKID:
                task.key = [data integerValue];
                break;
            case TASK_FILEPATH:
                task.filePath = data;
                break;
            case TASK_DESCRIPTION:
                task.description = data;
                break;
            case TASK_UPLOADSTATE:
                task.uploadState = [data intValue];
                
                break;
            default:
                break;
        }
    }
    [taskList addObject:task];
    [task release];
    return 0;
}



@implementation SCPSQLiteManager

@synthesize dbFilePath;

- (id)init
{
    self = [super init];
    if (self) {
        [self openDatabase];
        [self createTable];
        sqlite3_close(db);
    }
    return self;
}

//NOT FINISH,need edit insert params
- (void)addTaskList:(SCPTaskList *)taskList
{
    [self openDatabase];
    if (db) {
        char *err;
        NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO %@ VALUES(NULL,%@,%d)", TASKLIST_TABLE_NAME, taskList.albumId, taskList.isFinished];
        if (sqlite3_exec(db, [sqlQuery UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"%s", err);
            sqlite3_free(err);
            sqlite3_close(db);
            db = nil;
            return;
        }
        taskList.key = sqlite3_last_insert_rowid(db);
        for (SCPTask *task in taskList.taskList) {
            [self addTask:task tasklistId:taskList.key];
        }
        sqlite3_close(db);
        db = nil;
    }
}

- (NSMutableArray *)selectTasksList
{
    [self openDatabase];
    if (!db) {
        return nil;
    }
    char *err;
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@", TASKLIST_TABLE_NAME];
    NSMutableArray *tasksList = [[[NSMutableArray alloc] init] autorelease];
    if (sqlite3_exec(db, [sqlQuery UTF8String], SelectTasksListCallback, tasksList, &err) != SQLITE_OK) {
        return nil;
    }
    for (int i = 0; i < tasksList.count; i++) {
        SCPTaskList *taskList = [tasksList objectAtIndex:i];
        taskList.taskList = [self selectTaskListWithId:taskList.key];
    }
    sqlite3_close(db);
    db = nil;
    return tasksList;
}

- (void)updataTask:(SCPTask *)task
{
    [self openDatabase];
    if (db) {
        char *err = nil;
        NSString *sqlQuery = [NSString stringWithFormat:@"UPDATE %@ SET uploadState = %d"
                              " WHERE taskId = %d", TASK_TABLE_NAME, task.uploadState, task.key];
        if (sqlite3_exec(db, [sqlQuery UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"%s", err);
            sqlite3_free(err);
            sqlite3_close(db);
            db = nil;
            return;
        }
        sqlite3_close(db);
        db = nil;
    }
}

- (void)updateTaskList:(SCPTaskList *)taskList
{
    [self openDatabase];
    if (!db)
        return;
    char *err = nil;
    NSString *sqlQuery = [NSString stringWithFormat:@"UPDATE %@ SET isFinished = %d", TASKLIST_TABLE_NAME, taskList.isFinished];
    if (sqlite3_exec(db, [sqlQuery UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"%s", err);
        sqlite3_close(db);
        sqlite3_free(err);
        db = nil;
        return;
    }
    for (SCPTask *task in taskList.taskList) {
        err = nil;
        sqlQuery = [NSString stringWithFormat:@"UPDATE %@ SET isFinished = %d WHERE taskId = %d", TASK_TABLE_NAME, task.uploadState, task.key];
        if (sqlite3_exec(db, [sqlQuery UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"%s", err);
            sqlite3_free(err);
            sqlite3_close(db);
            db = nil;
            return;
        }
    }
    sqlite3_close(db);
    db = nil;
    return;
}

- (void)deleteTaskList:(SCPTaskList *)taskList
{
    [self openDatabase];
    if (!db)
        return;
    for (SCPTask *task in taskList.taskList) {
        char *err = nil;
        NSString *sqlQuery = [NSString stringWithFormat:@"DELETE FROM  %@ WHERE taskId = %d", TASK_TABLE_NAME, task.key];
        if (sqlite3_exec(db, [sqlQuery UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"%s", err);
            sqlite3_free(err);
            sqlite3_close(db);
            db = nil;
            return;
        }
    }
    char *err = nil;
    NSString *sqlQuery = [NSString stringWithFormat:@"DELETE FROM  %@ WHERE tasklistId = %d", TASKLIST_TABLE_NAME, taskList.key];
    if (sqlite3_exec(db, [sqlQuery UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"%s", err);
        sqlite3_free(err);
        sqlite3_close(db);
        db = nil;
        return;
    }
    sqlite3_close(db);
    db = nil;
}

- (void)dropTable
{
    [self openDatabase];
    if (db) {
        char *err = nil;
        NSString *sqlQuery = [NSString stringWithFormat:@"DROP TABLE %@", TASK_TABLE_NAME];
        if (sqlite3_exec(db, [sqlQuery UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"%s", err);
            sqlite3_free(err);
            sqlite3_close(db);
            db = nil;
            return;
        }
        sqlQuery = [NSString stringWithFormat:@"DROP TABLE %@", TASKLIST_TABLE_NAME];
        if (sqlite3_exec(db, [sqlQuery UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"%s", err);
            sqlite3_free(err);
            sqlite3_close(db);
            db = nil;
            return;
        }
        NSLog(@"dropTable Succeeded");
        sqlite3_close(db);
        db = nil;
    }
}

#pragma mark -
#pragma inner methods
- (void)addTask:(SCPTask *)task tasklistId:(int)tasklistId
{
    char *err;
    NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO %@ VALUES(NULL,'%@','%@',%d, %d)",
                          TASK_TABLE_NAME, task.filePath, task.description, task.uploadState ,tasklistId];
    if (sqlite3_exec(db, [sqlQuery UTF8String], NULL,NULL, &err) != SQLITE_OK) {
        NSLog(@"%s", err);
        sqlite3_free(err);
        return;
    }
    task.key = sqlite3_last_insert_rowid(db);
}

- (NSMutableArray *)selectTaskListWithId:(int)taskListId
{
    if (!db)
        return nil;
    char *err;
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE taskListId = %d;", TASK_TABLE_NAME, taskListId];
    NSMutableArray *taskList = [[[NSMutableArray alloc] init] autorelease];
    if (sqlite3_exec(db, [sqlQuery UTF8String], SelectTaskListCallback, taskList, &err) != SQLITE_OK) {
        NSLog(@"%s", err);
        sqlite3_free(err);
        return nil;
    }
    return taskList;
}

- (void)openDatabase
{
    db = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DATABASE_NAME];
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        NSLog(@"%s, %s", __FUNCTION__,sqlite3_errmsg(db));
        sqlite3_close(db);
        db = nil;
    }

}

- (void)createTable
{
    [self openDatabase];
    if (db) {
        char *err = nil;
        NSString *sqlQuery = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@);", TASK_TABLE_NAME, TASK_TABLE_KEY];
        if (sqlite3_exec(db, [sqlQuery UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"%s", err);
            sqlite3_free(err);
            sqlite3_close(db);
            db = nil;
            return;
        }
        sqlQuery = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@);", TASKLIST_TABLE_NAME, TASKLIST_TABLE_KEY];
        if (sqlite3_exec(db, [sqlQuery UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"%s", err);
            sqlite3_free(err);
            sqlite3_close(db);
            db = nil;
            return;
        }
        
        NSLog(@"createTable Succeeded");
        sqlite3_close(db);
        db = nil;
    }
}

@end
