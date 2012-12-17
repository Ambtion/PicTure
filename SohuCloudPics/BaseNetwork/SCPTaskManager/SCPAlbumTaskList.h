//
//  SCPAlbumTaskList.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-12.
//
//

#import <Foundation/Foundation.h>

#import "SCPTaskUnit.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "SCPURLLibaray.h"
@class SCPAlbumTaskList;
@protocol SCPAlbumTaskListDelegate <NSObject>
- (void)albumTask:(SCPAlbumTaskList *)albumTaskList requsetFinish:(ASIHTTPRequest *)requset;
- (void)albumTask:(SCPAlbumTaskList *)albumTaskList requsetFailed:(ASIHTTPRequest *)requset;
- (void)albumTaskQueneFinished:(SCPAlbumTaskList *)albumTaskList ;
@end

@interface SCPAlbumTaskList : NSObject<ASIHTTPRequestDelegate>
{
    NSMutableArray * _taskList;
}

@property (assign, nonatomic) id<SCPAlbumTaskListDelegate> delegate;

// 关于SCPTask的数组
@property (strong, nonatomic) NSMutableArray *taskList;
// 该任务列表所要上传到的相册的id
@property (strong, nonatomic) NSString *albumId;
@property (nonatomic,retain ) SCPTaskUnit * currentTask;
// 该任务列表是否已经完成
@property (assign, nonatomic) BOOL isUpLoading;
-(id)initWithTaskList:(NSMutableArray *)taskList album_id:(NSString *)albumID;

@property (nonatomic,retain)ASINetworkQueue * operationQuene;

//队列任务管理
- (void)go;
- (void)setSuspended;

- (void)cancelupLoadWithTag:(NSArray *)unitArray;
// 任务记忆管理
//....
@end
