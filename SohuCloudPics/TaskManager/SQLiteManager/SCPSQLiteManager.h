//
//  SCPSQLiteManager.h
//  SohuCloudPics
//
//  Created by mysohu on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

#import "SCPTaskList.h"
#import "SCPTask.h"


#define TASK_TASKID 0
#define TASK_FILEPATH 1
#define TASK_DESCRIPTION 2
#define TASK_UPLOADSTATE 3

#define TASKLIST_TASKLISTID 0
#define TASKLIST_ALBUMID 1
#define TASKLIST_ISFINISHED 2

#define RELATION_TASKID 0
#define RELATION_TASKLISTID 1

static NSString *DATABASE_NAME = @"database.sqlite";

static const NSString *TASK_TABLE_NAME = @"task_table";
static const NSString *TASK_TABLE_KEY = @"taskId INTEGER PRIMARY KEY,"
                                        " filepath TEXT NOT NULL,"
                                        " description TEXT,"
                                        " uploadState INTEGER DEFAULT 1,"
                                        " tasklistId INTEGER NOT NULL";

static const NSString *TASKLIST_TABLE_NAME = @"tasklist_table";
static const NSString *TASKLIST_TABLE_KEY = @"tasklistId INTEGER PRIMARY KEY,"
                                            " albumId INTEGER NOT NULL,"
                                            " isFinished INTEGER DEFAULT 0";



@interface SCPSQLiteManager : NSObject
{
    sqlite3 *db;
}

@property (strong, nonatomic) NSString *dbFilePath;

- (id)init;
- (void)dropTable;
- (void)createTable;
//data
- (void)addTaskList:(SCPTaskList *)taskList;

- (NSMutableArray *)selectTasksList;

- (void)updataTask:(SCPTask *)task;
- (void)updateTaskList:(SCPTaskList *)taskList;

- (void)deleteTaskList:(SCPTaskList *)taskList;


@end
