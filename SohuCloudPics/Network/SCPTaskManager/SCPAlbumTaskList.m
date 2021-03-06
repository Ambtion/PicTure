//
//  SCPAlbumTaskList.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-12.
//
//

#import "SCPAlbumTaskList.h"
#import "JSON.h"
#import "SCPTaskNotification.h"
#import "SCPLoginPridictive.h"
#import "SCPAlert_CustomeView.h"

#define UPTIMEOUT 30.f
#define UPLOADIMAGESIZE 1024 * 1024 * 10  // 图片最大10MB


@implementation SCPAlbumTaskList
@synthesize taskList = _taskList;
@synthesize albumId = _albumId;
@synthesize isUpLoading = _isUpLoading;
@synthesize delegate = _delegate;

@synthesize currentTask = _currentTask;
- (void)dealloc
{
    self.taskList = nil;
    self.albumId = nil;
    [self.currentTask.request cancel];
    [self.currentTask.request clearDelegatesAndCancel];
    self.currentTask = nil;
    [super dealloc];
}

-(id)initWithTaskList:(NSMutableArray *)taskList album_id:(NSString *)albumID
{
    self = [super init];
    if (self) {
        self.taskList = taskList;
        self.albumId = albumID;
        _isUpLoading = NO;
    }
    return self;
}

- (void)goNextTask
{
    //    NSLog(@"%s",__FUNCTION__);
    [self addTaskUnitToQuene];
}
- (void)addTaskUnitToQuene
{
    if (!self.currentTask) self.currentTask = [self.taskList objectAtIndex:0];
    self.currentTask.request = [self getUploadRequest:nil];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.currentTask getImageSucess:^(NSData *imageData, SCPTaskUnit * unit) {
            if ([imageData length] > UPLOADIMAGESIZE) {
//                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [self.currentTask.request setUserInfo:[NSDictionary dictionaryWithObject:@"图片太大,无法上传" forKey:@"FAILTURE"]];
                    [self requestFailed:self.currentTask.request];
                    return ;
//                });
                
            }else{
                [self.currentTask.request setData:imageData withFileName:@"fromIOS" andContentType:@"image/*" forKey:@"file"];
            }
            if (unit.description && ![unit.description isEqualToString:@""])
                [self.currentTask.request setPostValue:unit.description forKey:@"desc"];
            if (!self.currentTask.request.isCancelled)
                [self.currentTask.request startAsynchronous];
        } failture:^(NSError *error, SCPTaskUnit *unit) {
            //            NSLog(@"%s, %@",__FUNCTION__,error);
            unit.taskState = UPLoadStatusFailedUpload;
            [self goNextTask];
            SCPAlert_CustomeView * cus = [[[SCPAlert_CustomeView alloc] initWithTitle:@"图片上传失败"] autorelease];
            [cus show];
        }];
//    });
    return;
}
- (void)startTaskUnit
{
    if (!self.currentTask) self.currentTask = [self.taskList objectAtIndex:0];
    self.currentTask.request = [self getUploadRequest:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.currentTask getImageSucess:^(NSData *imageData, SCPTaskUnit * unit) {
            if ([imageData length] > UPLOADIMAGESIZE) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.currentTask.request setUserInfo:[NSDictionary dictionaryWithObject:@"图片太大,无法上传" forKey:@"FAILTURE"]];
                    [self requestFailed:self.currentTask.request];
                    return ;
                });
                
            }else{
                [self.currentTask.request setData:imageData withFileName:@"fromIOS" andContentType:@"image/*" forKey:@"file"];
            }
            if (unit.description && ![unit.description isEqualToString:@""])
                [self.currentTask.request setPostValue:unit.description forKey:@"desc"];
            if (!self.currentTask.request.isCancelled)
                [self.currentTask.request startAsynchronous];
        } failture:^(NSError *error, SCPTaskUnit *unit) {
            unit.taskState = UPLoadStatusFailedUpload;
            [self goNextTask];
            SCPAlert_CustomeView * cus = [[[SCPAlert_CustomeView alloc] initWithTitle:@"图片上传失败"] autorelease];
            [cus show];
        }];
    });
    return;
}
- (void)go
{
    [self startTaskUnit];
    //    NSLog(@"%s",__FUNCTION__);
//    [self addTaskUnitToQuene];
}
- (void)cancelupLoadWithTag:(NSArray *)unitArray
{
    for (SCPTaskUnit * unit in unitArray) {
        if ([self.currentTask isEqual:unit]) {
            [self.currentTask.request cancel];
            [self.currentTask.request clearDelegatesAndCancel];
            [self requestFinished:nil];
            continue;
        }
        for (int i = _taskList.count - 1 ; i >= 0;i--) {
            SCPTaskUnit * tss = [_taskList objectAtIndex:i];
            if ([tss isEqual:unit]) [self.taskList removeObject:tss];
        }
    }
}

- (void)clearProgreessView
{
    for (SCPTaskUnit * unit in _taskList) {
        [unit.request setUploadProgressDelegate:nil];
    }
}

#pragma mark - Requsetdelgate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    if ([request responseStatusCode] != 200) {
        [self requestFailed:request];
        return;
    }
    NSDictionary * dic = [[request responseString] JSONValue];
    NSInteger code = [[dic objectForKey:@"code"] intValue];
    if (![self handleCode:code]) return;
//    NSLog(@"%@",gi[request responseString]);
    [request cancel];
    [request clearDelegatesAndCancel];
    if (self.taskList.count)
        [self.taskList removeObjectAtIndex:0];
    if ([_delegate respondsToSelector:@selector(albumTask:requsetFinish:)]) {
        [_delegate performSelector:@selector(albumTask:requsetFinish:) withObject:self withObject:request];
    }
    self.currentTask = nil;
    if (self.taskList.count) {
        [self goNextTask];
    }else{
    //        NSLog(@"Task Finished");
        if ([_delegate respondsToSelector:@selector(albumTaskQueneFinished:)]) {
            [_delegate performSelector:@selector(albumTaskQueneFinished:) withObject:self];
        }
    }
}
- (BOOL)handleCode:(NSInteger)code
{
    BOOL returnValue = NO;
    NSString * reason = nil;
    switch (code) {
        case 0:
            returnValue = YES;
            break;
        case 1:
            reason = [NSString stringWithFormat:@"当前未登录,上传失败"];//取消任务;
            [self requestClearCurTask:reason];
            break;
        case 2:
            reason = [NSString stringWithFormat:@"专辑不存在,上传失败"];//取消任务;
            [self requestClearCurTask:reason];
            break;
        case 11:
            reason = [NSString stringWithFormat:@"专辑已满,上传失败"];//取消任务;
            [self requestClearCurTask:reason];
            break;
        case 12:
            reason = [NSString stringWithFormat:@"空间已满,上传失败"];//取消任务;
            [self requestClearCurTask:reason];
            break;
        default:
            [self requestFailed:nil];
            break;
    }
    return returnValue;
    
}
- (void)requestClearCurTask:(NSString *)reason
{
    [self.taskList removeAllObjects];
    self.currentTask = nil;
    SCPAlert_CustomeView * cus = [[[SCPAlert_CustomeView alloc] initWithTitle:reason] autorelease];
    [cus show];
    if ([_delegate respondsToSelector:@selector(albumTaskQueneFinished:)]) {
        [_delegate performSelector:@selector(albumTaskQueneFinished:) withObject:self];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
//    NSLog(@"requestFailed:NNNN::%s, %d, %@",__FUNCTION__,[request responseStatusCode],[request error]);
    [request cancel];
    [request clearDelegatesAndCancel];
    NSDictionary * dic = [request userInfo];
    if (dic) {
        SCPAlert_CustomeView * cus = [[[SCPAlert_CustomeView alloc] initWithTitle:[dic objectForKey:@"FAILTURE"]] autorelease];
        [cus show];
    }else{
        SCPAlert_CustomeView * cus = [[[SCPAlert_CustomeView alloc] initWithTitle:@"图片上传失败"] autorelease];
        [cus show];
    }
    if (self.taskList.count)
        [self.taskList removeObjectAtIndex:0];
    if ([_delegate respondsToSelector:@selector(albumTask:requsetFailed:)]) {
        [_delegate performSelector:@selector(albumTask:requsetFailed:) withObject:self withObject:request];
    }
    if (self.taskList.count) {
        [self goNextTask];
    }else{
        if ([_delegate respondsToSelector:@selector(albumTaskQueneFinished:)]) {
            [_delegate performSelector:@selector(albumTaskQueneFinished:) withObject:self];
        }
    }
}

- (ASIFormDataRequest *)getUploadRequest:(NSData *)imageData
{
    NSString * str = [NSString stringWithFormat:@"%@/upload/api?folder_id=%@&access_token=%@",BASICURL,self.albumId,[SCPLoginPridictive currentToken]];
    NSURL * url  = [NSURL URLWithString:str];
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:url];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setDelegate:self];
    [request setTimeOutSeconds:UPTIMEOUT];
    [request setShowAccurateProgress:YES];
    [request setShouldAttemptPersistentConnection:NO];
    [request setNumberOfTimesToRetryOnTimeout:5];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [request setShouldContinueWhenAppEntersBackground:YES];
#endif
    return request;
}

@end
