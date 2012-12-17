//
//  SCPTaskManager.h
//  SohuCloudPics
//
//  Created by mysohu on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCPTask.h"
#import "SCPTaskList.h"
#import "ISohuUploadManager.h"
#import "SCPSQLiteManager.h"


@protocol TaskManagerDelegate <NSObject>

@optional
- (void)requestDidFinish:(ASIFormDataRequest *)request task:(SCPTask *)task;
- (void)requestDidFail:(ASIFormDataRequest *)request task:(SCPTask *)task;
- (void)requestQueueDidFinish:(ASINetworkQueue *)networkQueue taskList:(SCPTaskList *)taskList;
- (void)startNewTaskList:(SCPTaskList *)taskList;

@end

@interface SCPTaskManager : NSObject
{
    ISohuUploadManager *_uploadManager;
}
@property (readonly, atomic) BOOL isUploading;
@property (strong, atomic) id<TaskManagerDelegate> taskDelegate;
@property (assign, atomic) BOOL isAutoStartNextTasks;
@property (strong, atomic) SCPSQLiteManager *sqliteManager;

// 当前正在进行中的任务列表
@property (strong, atomic) SCPTaskList *currentTaskList;

// 所有的任务列表
@property (strong, atomic) NSMutableArray *tasksList;

+ (SCPTaskManager *)getInstance; // 单例模式

#pragma mark task
- (void)addTaskListToDB:(SCPTaskList *)taskList; // 将任务列表加入到数据库中
- (void)reloadTasksList;    // 重新载入所有的任务列表
- (void)saveTasksList;      // 保存所有的任务列表
- (void)start;              // 开始一个新的任务列表
- (void)stop;               // 重置所有的任务列表
- (SCPTaskList *)getTaskListWithAlbumId:(NSString *)albumId; //获取上传到给定相册id的任务列表，若有多个任务列表，只返回第一个
- (void)printDatabase;

#pragma mark view
- (BOOL)setRequestQueueProgressView:(NSString *)albumId progressView:(UIProgressView *)progressView;

#pragma mark data
- (void)clearAllDelegates;

@end
