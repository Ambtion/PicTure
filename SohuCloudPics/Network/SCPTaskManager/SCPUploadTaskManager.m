//
//  SCPUploadTaskManager.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-13.
//
//

#import "SCPUploadTaskManager.h"

static SCPUploadTaskManager * sharedTaskManager = nil;
@implementation SCPUploadTaskManager
@synthesize curTask;
@synthesize taskList = _taskList;

#pragma mark -
+ (SCPUploadTaskManager *)currentManager  // 单例模式
{
    if (sharedTaskManager == nil) {
        @synchronized (self) {
            if (sharedTaskManager == nil) {
                sharedTaskManager = [[self alloc] init];
            }
        }
    }
    return sharedTaskManager;
}
#pragma mark -
- (void)dealloc
{
    [_taskList release];
    self.curTask = nil;
    [super dealloc];
}
- (id)init
{
    if (self = [super init]) {
        _taskList = [[NSMutableArray alloc] initWithCapacity:0];
        _taskDic = [[NSMutableDictionary dictionaryWithCapacity:0] retain];
    }
    return self;
}

- (void)addTaskList:(SCPAlbumTaskList *)taskList
{
    taskList.delegate = self;
    [_taskList addObject:taskList];
    [self updataAlbumInfoWith:taskList];
    [self go];
}

- (void)go
{
    SCPAlbumTaskList * task = [_taskList objectAtIndex:0];
    if (self.curTask == task) {
        NSLog(@"There is Task going");
        return;
    }else{
        self.curTask = task;
    }
    if (!task.isUpLoading) {
        [task go];
    }
}
#pragma mark - AlbumInfo

- (void)updataAlbumInfoWith:(SCPAlbumTaskList *)taskList
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    NSInteger total = [self getTotalNumWith:taskList];
    total += taskList.taskList.count;
    NSInteger finished = [self getFinisheNumWith:taskList];
    [dic setObject:[NSNumber numberWithInt:total] forKey:@"Total"];
    [dic setObject:[NSNumber numberWithInt:finished] forKey:@"Finish"];
    [_taskDic setObject:dic forKey:taskList.albumId];
    [dic release];
}
- (NSInteger)getTotalNumWith:(SCPAlbumTaskList *)taskList
{

    NSMutableDictionary * albumInfo = [_taskDic objectForKey:taskList.albumId];
    NSLog(@"%s",__FUNCTION__);
    if (!albumInfo || ![albumInfo objectForKey:@"Total"]) {
        return 0;
    }else{
        return [[albumInfo objectForKey:@"Total"] intValue];
    }
}
- (NSInteger)getFinisheNumWith:(SCPAlbumTaskList *)taskList
{
    NSMutableDictionary * albumInfo = [_taskDic objectForKey:taskList.albumId];
    if (!albumInfo || ![albumInfo objectForKey:@"Finish"]) {
        return 0;
    }else{
        return [[albumInfo objectForKey:@"Finish"] intValue];
    }
}
- (void)finishOneRequsetWith:(SCPAlbumTaskList *)taskList
{
    NSLog(@"%s",__FUNCTION__);
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    NSInteger total = [self getTotalNumWith:taskList];
    NSInteger finished = [self getFinisheNumWith:taskList];
    finished++;
    [dic setObject:[NSNumber numberWithInt:total] forKey:@"Total"];
    [dic setObject:[NSNumber numberWithInt:finished] forKey:@"Finish"];
    [_taskDic setObject:dic forKey:taskList.albumId];
    [dic release];
    
}
- (void)cancelOneRequestWith:(SCPAlbumTaskList *)taskList
{
    NSLog(@"%s",__FUNCTION__);
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    NSInteger total = [self getTotalNumWith:taskList];
    NSInteger finished = [self getFinisheNumWith:taskList];
    total--;
    [dic setObject:[NSNumber numberWithInt:total] forKey:@"Total"];
    [dic setObject:[NSNumber numberWithInt:finished] forKey:@"Finish"];
    [_taskDic setObject:dic forKey:taskList.albumId];
    [dic release];
}
- (void)removeAlbunInfo:(NSString  *)albumId
{
    NSLog(@"%s",__FUNCTION__);
    for (SCPAlbumTaskList * task in _taskList) {
        if ([task.albumId isEqualToString:albumId]) {
            return;
        }
    }
    [_taskDic removeObjectForKey:albumId];
}
- (void)gotoNext
{
    self.curTask = [_taskList objectAtIndex:0];
    [self.curTask go];
}
#pragma mark - GETALBUMYASK
- (SCPAlbumTaskList *)getAlbumTaskWithAlbum:(NSString *)albumId
{
    for (SCPAlbumTaskList * list in self.taskList) {
        if ([list.albumId isEqualToString:albumId]) {
            return list;
        }
    }
    return nil;
}
- (void)cancelOperationWithAlbumID:(NSString *)albumID
{
    NSLog(@"Operation cancel");
    if ([self.curTask.albumId isEqualToString:albumID]) {
        [self.curTask.currentTask.request cancel];
        [self.curTask.currentTask.request clearDelegatesAndCancel];
        [self.taskList removeObject:self.curTask];
        [self albumTaskQueneFinished:nil];
        return;
    }
    for (SCPAlbumTaskList * tss in _taskList) {
        if ([tss.albumId isEqualToString:albumID]) [self.taskList removeObject:tss];
    }
}
- (void)cancelupLoadWithAlbumID:(NSString *)albumId WithUnit:(NSArray *)unitArray
{
    if ([self.curTask.albumId isEqualToString:albumId]) {
        if (self.curTask.taskList.count == unitArray.count) {
            [self cancelOperationWithAlbumID:albumId];
        }else{
            [self.curTask cancelupLoadWithTag:unitArray];
        }
    }else{
        for (SCPAlbumTaskList * taskList in _taskList) {
            if ([taskList.albumId isEqualToString:albumId]) {
                if (self.curTask.taskList.count == unitArray.count) {
                    [self cancelOperationWithAlbumID:albumId];
                }else{
                    [self removeUint:unitArray From:taskList];
                }
            }
        }
    }
}
- (void)removeUint:(NSArray *)uintArray From:(SCPAlbumTaskList *)taskList
{
    for (SCPTaskUnit * unit in uintArray) {
        [taskList.taskList removeObject:unit];
        [self cancelOneRequestWith:taskList];
    }
}
#pragma mark AlbumProgress
- (void)albumTaskQueneFinished:(SCPAlbumTaskList *)albumTaskList
{
    NSLog(@"Finished one Operation");
    if (!albumTaskList) return;
    [_taskList removeObjectAtIndex:0];
    [self removeAlbunInfo:self.curTask.albumId];
    self.curTask = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ALBUMUPLOADOVER object:nil userInfo:[_taskDic objectForKey:self.curTask.albumId]];
    if (_taskList.count) {
        [self gotoNext];
    }else{
        NSLog(@"All operation Over");
    }

}
- (void)albumTask:(SCPAlbumTaskList *)albumTaskList requsetFinish:(ASIHTTPRequest *)requset
{
    [self finishOneRequsetWith:self.curTask];
    NSLog(@"%@",_taskDic);
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[_taskDic objectForKey:self.curTask.albumId]];
    if (requset && [requset responseString] && [[requset responseString] JSONValue])
        [dic setObject:[[requset responseString] JSONValue] forKey:@"RequsetInfo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:ALBUMTASKCHANGE object:nil userInfo:dic];

}
- (void)albumTask:(SCPAlbumTaskList *)albumTaskList requsetFailed:(ASIHTTPRequest *)requset
{
    NSLog(@"fail one Requset");
}

@end
