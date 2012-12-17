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

@implementation SCPAlbumTaskList

@synthesize taskList = _taskList;
@synthesize albumId = _albumId;
@synthesize isUpLoading = _isUpLoading;
@synthesize operationQuene = _operationQuene;
@synthesize delegate = _delegate;

@synthesize currentTask = _currentTask;
- (void)dealloc
{
    self.taskList = nil;
    self.albumId = nil;
    [self.currentTask.request cancel];
    [self.currentTask.request clearDelegatesAndCancel];
    self.currentTask = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:_operationQuene];
    self.operationQuene  = nil;
    [super dealloc];
}
-(id)initWithTaskList:(NSMutableArray *)taskList album_id:(NSString *)albumID
{
    self = [super init];
    if (self) {
        self.taskList = taskList;
        self.albumId = albumID;
        _isUpLoading = NO;
        
        _operationQuene = [[ASINetworkQueue  alloc] init];
        [_operationQuene setShouldCancelAllRequestsOnFailure:NO];
        [_operationQuene setShowAccurateProgress:NO];
        _operationQuene.maxConcurrentOperationCount = 1;
        _operationQuene.delegate = self;
    }
    return self;
}
- (void)goNextTask
{
    [self addTaskUnitToQuene];
}
- (void)addTaskUnitToQuene
{
    if (!self.currentTask) self.currentTask = [self.taskList objectAtIndex:0];
    self.currentTask.request = [self getUploadRequest:nil];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self.currentTask getImageSucess:^(NSData *imageData, SCPTaskUnit *unit) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.currentTask.request setData:imageData withFileName:@"fromIOS.png" andContentType:@"image/*" forKey:@"file"];
            [_operationQuene addOperation:self.currentTask.request];
            [_operationQuene go];
            NSLog(@"addTaskUnit :%@",self.currentTask.request);
        });
    } failture:^(NSError *error, SCPTaskUnit *unit) {
        NSLog(@"%s, %@",__FUNCTION__,error);
        unit.taskState = UPLoadStatusFailedUpload;
    }];
//    });
    return;
}

- (void)go
{
    NSLog(@"%s",__FUNCTION__);
    [_operationQuene go];
    [self addTaskUnitToQuene];
}

- (void)setSuspended
{
    [_operationQuene cancelAllOperations];
    [_operationQuene setSuspended:YES];
    [NSObject cancelPreviousPerformRequestsWithTarget:_operationQuene];
}
- (void)cancelupLoadWithTag:(NSArray *)unitArray
{
    NSLog(@"requset cancel");
    for (SCPTaskUnit * unit in unitArray) {
        if ([self.currentTask isEqual:unit]) {
            [self.currentTask.request cancel];
            [self.currentTask.request clearDelegatesAndCancel];
            [self requestFinished:nil];
            continue;
        }
        for (int i = _taskList.count - 1 ; i >=0;i--) {
            SCPTaskUnit * tss = [_taskList objectAtIndex:i];
            if ([tss isEqual:unit]) [self.taskList removeObject:tss];
        }
    }

}
#pragma mark - Requsetdelgate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [request cancel];
    [request clearDelegatesAndCancel];
    [self.taskList removeObjectAtIndex:0];
    if ([_delegate respondsToSelector:@selector(albumTask:requsetFinish:)]) {
        [_delegate performSelector:@selector(albumTask:requsetFinish:) withObject:self withObject:request];
    }
    self.currentTask = nil;
    if (self.taskList.count) {
        [self goNextTask];
    }else{
        NSLog(@"Task Finished");
        if ([_delegate respondsToSelector:@selector(albumTaskQueneFinished:)]) {
            [_delegate performSelector:@selector(albumTaskQueneFinished:) withObject:self];
        }
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [request cancel];
    [request clearDelegatesAndCancel];
    [self.taskList removeObjectAtIndex:0];
    if ([_delegate respondsToSelector:@selector(albumTask:requsetFailed:)]) {
        [_delegate performSelector:@selector(albumTask:requsetFailed:) withObject:self withObject:request];
    }
    
    if (!self.taskList.count) {
        [self goNextTask];
    }else{
        NSLog(@"Task Finished");
        if ([_delegate respondsToSelector:@selector(albumTaskQueneFinished:)]) {
            [_delegate performSelector:@selector(albumTaskQueneFinished:) withObject:self];
        }
    }
}

- (ASIFormDataRequest *)getUploadRequest:(NSData *)imageData
{
    NSString * str = [NSString stringWithFormat:@"%s/upload/api?folder_id=%@&yuntu_token=%@","http://10.10.79.134",self.albumId,@"123"];
    NSURL * url  = [NSURL URLWithString:str];
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"accept" value:@"application/json"];
    request.delegate = self;
//    [request setData:imageData withFileName:@"fromIOS.png" andContentType:@"image/*" forKey:@"file"];
    [request setTimeOutSeconds:10];
    [request setShowAccurateProgress:YES];
    
#if __IPHONE_OS_VERSION_MIN_ALLOWED >= __IPHONE_4_0
    [request setShouldContinueWhenAppEntersBackground:YES];
#endif
    return request;
}

@end
