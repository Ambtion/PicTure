//
//  SCPTaskManager.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPTaskManager.h"

static SCPTaskManager *sharedTaskManager = nil;

@implementation SCPTaskManager

@synthesize isAutoStartNextTasks = _isAutoStartNextTasks;
@synthesize tasksList = _tasksList;
@synthesize currentTaskList = _currentTaskList;
@synthesize taskDelegate = _taskDelegate;
@synthesize sqliteManager = _sqliteManager;
@synthesize isUploading = _isUploading;
#pragma mark -
#pragma singleton method

+ (SCPTaskManager *)getInstance
{
    if (sharedTaskManager == nil) {
        @synchronized (self) {
            if (sharedTaskManager == nil) {
                [[self alloc] init];
            }
        }
    }
    return sharedTaskManager;
}

+ (void)removeInstance
{
    [sharedTaskManager release];
    sharedTaskManager = nil;
}

+ (id)allocWithZone:(NSZone *)zone
{
    if (sharedTaskManager == nil) {
        @synchronized (self) {
            if (sharedTaskManager == nil) {
                sharedTaskManager = [super allocWithZone:zone];
                return sharedTaskManager;
            }
        }
    }
    return nil;
}

- (id)retain
{
    return self;
}

- (id)autorelease
{
    return self;
}

#pragma mark -
#pragma other method
- (id)init
{
    self = [super init];
    if (self) {
        
        _isAutoStartNextTasks = YES;
        _isUploading = NO;
        _tasksList = [[NSMutableArray alloc] init];
        _sqliteManager = [[SCPSQLiteManager alloc] init];
        
        _uploadManager = [[ISohuUploadManager alloc] init];
        _uploadManager.networkQueue.delegate = self;
        [_uploadManager.networkQueue setQueueDidFinishSelector:@selector(queueFinished:)];
        [_uploadManager.networkQueue setRequestDidFinishSelector:@selector(uploadFinished:)];
        [_uploadManager.networkQueue setRequestDidFailSelector:@selector(uploadFailed:)];
        [_uploadManager.networkQueue setRequestDidStartSelector:@selector(uploadStarted:)];
    }
    return self;
}

- (void)dealloc
{
    [_uploadManager release];
    [_tasksList release];
    [_taskDelegate release];
    [_currentTaskList release];
    [_sqliteManager release];
    
    [super dealloc];
}

- (void)reloadTasksList
{
    self.tasksList = [_sqliteManager selectTasksList];
}

- (void)saveTasksList
{
    if (_currentTaskList != nil) {
        [_sqliteManager updateTaskList:_currentTaskList];
    }
}

- (void)addTaskListToDB:(SCPTaskList *)taskList
{
    [_tasksList addObject:taskList];
    [_sqliteManager addTaskList:taskList];
}

- (void)start
{
    _isUploading = YES;
    [_uploadManager.networkQueue cancelAllOperations];
    NSLog(@"%s",__FUNCTION__);
    [self setupNewTasksList];
    [_uploadManager.networkQueue go];
}
- (void)stop{
    _isUploading = NO;
    [_uploadManager.networkQueue reset];
}

- (SCPTaskList *)getTaskListWithAlbumId:(NSString *)albumId
{
    for (SCPTaskList *taskList in _tasksList) {
        if (taskList.albumId == albumId) {
            return taskList;
        }
    }
    return nil;
}

- (BOOL)setRequestQueueProgressView:(NSString *)albumId progressView:(UIProgressView *)progressView
{
    if (_currentTaskList != nil && _currentTaskList.albumId == albumId) {
        [_uploadManager.networkQueue setUploadProgressDelegate:progressView];
        return YES;
    }
    for (SCPTaskList *list in _tasksList) {
        if (albumId == list.albumId) {
            [progressView setProgress:0.0];
            return YES;
        }
    }
    return NO;
}
- (void)printDatabase
{
    NSArray *tasksList = [_sqliteManager selectTasksList];
    NSLog(@"==Total Tasks:%d==",tasksList.count);
    for (SCPTaskList *taskList in tasksList) {
        NSLog(@"taskList:key=%d,count=%d,aId=%@",
              taskList.key,taskList.taskList.count,taskList.albumId);
        for (SCPTask *task in taskList.taskList) {
            NSLog(@"----task:key=%d,path=%@,uploadState=%d",
                  task.key,task.filePath,task.uploadState);
        }
    }
}
#pragma mark -
#pragma inner call
- (void)setupNewTasksList
{
    if (_tasksList.count > 0) {
        self.currentTaskList = [_tasksList objectAtIndex:0];
        int i = 0;
        for (SCPTask *task in _currentTaskList.taskList) {
            if (!task.uploadState != TaskStatusFinishUpload) {
                NSLog(@"%s",__FUNCTION__);
                ASIFormDataRequest *req = [_uploadManager addUploadImageWithImage:[UIImage imageNamed:@"bigTest.jpg"]];
                //                NSString *filePath = task.filePath;
                //                ASIFormDataRequest *request = [_uploadManager addUploadImageWithPath:filePath];
                req.tag = i;
            }
            i++;
        }
    }
}

#pragma mark -
#pragma view
- (void)clearAllDelegates
{
    self.taskDelegate = nil;
    _uploadManager.networkQueue.uploadProgressDelegate = nil;
    for (ASIFormDataRequest *request in [_uploadManager.networkQueue operations]) {
        request.uploadProgressDelegate = nil;
    }
}

#pragma mark -
#pragma networkQueue delegate
- (void)queueFinished:(ASINetworkQueue *)networkQueue
{
    NSLog(@"task queue finished");
    _currentTaskList.isFinished = TRUE;
    for (SCPTask *task in _currentTaskList.taskList) {
        if (task.uploadState != TaskStatusFinishUpload) {
            _currentTaskList.isFinished = FALSE;
            break;
        }
    }
    [self printDatabase];
    if ([_taskDelegate respondsToSelector:@selector(requestQueueDidFinish:taskList:)]) {
        [_taskDelegate requestQueueDidFinish:networkQueue taskList:_currentTaskList];
    }
    
    if (_currentTaskList.isFinished) {
        [_sqliteManager deleteTaskList:_currentTaskList];
    }
    
    [_tasksList removeObject:self.currentTaskList];
    self.currentTaskList = nil;
    _isUploading = NO;
    if (_isAutoStartNextTasks && _tasksList.count > 0) {
        [self start];
    }
    [self printDatabase];
}

- (void)uploadStarted:(ASIFormDataRequest *)request
{
    int position = [request tag];
    SCPTask *nextTask = [_currentTaskList.taskList objectAtIndex:position];
    nextTask.uploadState = TaskStatusIsUploading;
    nextTask.request = request;
}

- (void)uploadFinished:(ASIFormDataRequest *)request
{
    NSLog(@"task finished");
    int position = [request tag];
    SCPTask *task = [_currentTaskList.taskList objectAtIndex:position];
    
    task.uploadState = TaskStatusFinishUpload;
    if ([_taskDelegate respondsToSelector:@selector(requestDidFinish:task:)]) {
        [_taskDelegate requestDidFinish:request task:task];
    }
    [_sqliteManager updataTask:task];
    task.request = nil;
    if (!_isAutoStartNextTasks) {
        //STOP ALL TASK? queueFinished called?
        //        [_uploadManager.networkQueue reset];
        
    }
}

- (void)uploadFailed:(ASIFormDataRequest *)request
{
    NSLog(@"task failed");
    int position = [request tag];
    SCPTask *task = [_currentTaskList.taskList objectAtIndex:position];
    
    if ([_taskDelegate respondsToSelector:@selector(requestDidFail:task:)]) {
        [_taskDelegate requestDidFail:request task:task];
    }
    task.uploadState = TaskStatusBeforeUpload;
    task.request = nil;
    //DEALING WITH FILE MISSING ? AND OTHER ERROR?
    //OR JUST IGONRE ALL ERROR AND DELETE TASK?
    if (!_isAutoStartNextTasks) {
        //STOP ALL TASK?  queueFinished  called?
        //        [_uploadManager.networkQueue reset];
        
    }
}

@end
