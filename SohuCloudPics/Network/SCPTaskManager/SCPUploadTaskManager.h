//
//  SCPUploadTaskManager.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-13.
//
//

#import <Foundation/Foundation.h>
#import "SCPAlbumTaskList.h"

#import "SCPTaskNotification.h"
#import "JSON.h"

@interface SCPUploadTaskManager : NSObject<SCPAlbumTaskListDelegate>
{
    NSMutableArray * _taskList;
    NSMutableDictionary * _taskDic;
}
@property (nonatomic,retain)SCPAlbumTaskList * curTask;
@property (nonatomic,retain)NSMutableArray * taskList;
+ (SCPUploadTaskManager *)currentManager; // 单例模式

//增加队列上传任务
- (void)addTaskList:(SCPAlbumTaskList *)taskList; // 将任务列表加入到队列中

- (void)cancelOperationWithAlbumID:(NSString *)albumID;

- (void)cancelupLoadWithAlbumID:(NSString *)albumId WithUnit:(NSArray *)unitArray;

- (void)cancelAllOperation;
#pragma mark view
//管理相册列表上传进度

//管理照片列表下载进度
- (SCPAlbumTaskList *)getAlbumTaskWithAlbum:(NSString *)albumId;
@end
