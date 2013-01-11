//
//  SCPRequestManager.m
//  SCPNetWork
//
//  Created by sohu on 12-11-19.
//  Copyright (c) 2012年 Qu. All rights reserved.
//

#import "SCPRequestManager.h"
#import "SCPURLLibaray.h"
#import "ASIFormDataRequest.h"
#import "SCPLoginPridictive.h"
#import "JSON.h"


#define TIMEOUT 10.f
@implementation SCPRequestManager
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        tempDic = [[NSMutableDictionary dictionaryWithCapacity:0] retain];
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [tempDic release];
    [super dealloc];
}
#pragma mark - Explore
- (void)getExploreFrom:(NSInteger)startIndex maxresult:(NSInteger)maxresult sucess:(void (^)(NSArray * infoArray))success failture:(void (^)(NSString * error))faiture
{
    
    NSString * str_url = [NSString stringWithFormat:@"%@/plaza?start=%d&count=%d",BASICURL_V1,startIndex,maxresult];
    NSLog(@"%@",str_url);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str_url]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]){
            success([[[request responseString] JSONValue] objectForKey:@"photos"]);
        }else {
            faiture([NSString stringWithFormat:@"网络连接异常"]);
        }
    }];
    [request setFailedBlock:^{
        faiture(@"网络连接异常");
    }];
    [request startAsynchronous];
}

#pragma mark - PhotoDetail
- (void)getPhotoDetailinfoWithUserID:(NSString *)user_id photoID:(NSString *)photo_ID
{
    NSString * str = [NSString stringWithFormat:@"%@/photos/%@?owner_id=%@",BASICURL_V1,photo_ID,user_id];
    NSLog(@"%@",str);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:dic];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
        }
    }];
    [request startAsynchronous];
}
#pragma mark - Personal Home
- (void)getUserInfoWithID:(NSString *)user_ID asy:(BOOL)isAsy success:(void (^) (NSDictionary * response))success  failure:(void (^) (NSString * error))failure
{
    NSString  * str = nil;
    if ([SCPLoginPridictive currentToken]) {
        str = [NSString stringWithFormat:@"%@/users/%@?access_token=%@",BASICURL_V1,user_ID,[SCPLoginPridictive currentToken]];
    }else{
        str = [NSString stringWithFormat:@"%@/users/%@",BASICURL_V1,user_ID];
    }
    NSLog(@"%@",str);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            success(dic);
            
        }else{
            failure(@"网络连接异常");
        }
    }];
    [request setFailedBlock:^{
        failure(@"网络连接异常");
    }];
    if (isAsy) {
        [request startAsynchronous];
    }else{
        [request startSynchronous];
    }
    
}
- (void)getUserInfoWithID:(NSString *)user_ID
{
    
    NSString  * str = nil;
    if ([SCPLoginPridictive currentToken]) {
        str = [NSString stringWithFormat:@"%@/users/%@?access_token=%@",BASICURL_V1,user_ID,[SCPLoginPridictive currentToken]];
        NSLog(@"Login:%@", str);
    }else{
        str = [NSString stringWithFormat:@"%@/users/%@",BASICURL_V1,user_ID];
        NSLog(@"%@",str);
    }
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            NSLog(@"tempdic %@",[tempDic objectForKey:@"userInfo"]);
            [self getUserInfoFeedWithUserID:user_ID page:1];
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
            }
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"%@ ------- %d",[request error], [request responseStatusCode]);
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
        }
    }];
    [request startAsynchronous];
}
- (void)getUserInfoFeedWithUserID:(NSString *)user_ID page:(NSInteger)page
{
    NSString * str = [NSString stringWithFormat:@"%@/feed?user_id=%@&page=%d",BASICURL_V1,user_ID,page];
    
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"feedList"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
        }
    }];
    [request startAsynchronous];
}
#pragma mark - Folders
- (void)getFoldersinfoWithID:(NSString *)uses_id
{
    NSString  * str = nil;
    if ([SCPLoginPridictive isLogin]) {
        str = [NSString stringWithFormat:@"%@/users/%@?access_token=%@",BASICURL_V1,uses_id,[SCPLoginPridictive currentToken]];
    }else{
        str = [NSString stringWithFormat:@"%@/users/%@",BASICURL_V1,uses_id];
    }
    NSLog(@"%s, %@",__FUNCTION__, str);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            [self getFoldersWithID:uses_id page:1];
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
        }
    }];
    [request startAsynchronous];
}
- (void)getFoldersWithID:(NSString *)user_id page:(NSInteger)page
{
    NSString * str = nil;
    if ([SCPLoginPridictive isLogin]) {
        str = [NSString stringWithFormat:@"%@/folders?owner_id=%@&page=%d&access_token=%@",BASICURL_V1,user_id,page,[SCPLoginPridictive currentToken]];
    }else{
        str = [NSString stringWithFormat:@"%@/folders?owner_id=%@&page=%d",BASICURL_V1,user_id,page];
    }
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            
            NSString * str = [request responseString];
//            NSLog(@"%@",str);
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"folderinfo"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
        }
    }];
    [request startAsynchronous];
}

#pragma mark - PhotosList
- (void)getFolderinfoWihtUserID:(NSString *)user_id WithFolders:(NSString *)folder_id
{
    NSString  * str = nil;
    if ([SCPLoginPridictive isLogin]) {
        str = [NSString stringWithFormat:@"%@/folders/%@?owner_id=%@&access_token=%@",BASICURL_V1,folder_id,user_id,[SCPLoginPridictive currentToken]];
    }else{
        str = [NSString stringWithFormat:@"%@/folders/%@?owner_id=%@",BASICURL_V1,folder_id,user_id];
    }
    NSLog(@"Login:%@", str);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"folderInfo"];
            [self getPhotosWithUserID:user_id FolderID:folder_id page:1];
            
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
            }
        }
    }];
    
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
        }
    }];
    [request startAsynchronous];
    
}
- (void)getPhotosWithUserID:(NSString *)user_id FolderID:(NSString *)folder_id page:(NSInteger)page
{
    NSString  * str = nil;
    if ([SCPLoginPridictive isLogin]) {
        str = [NSString stringWithFormat:@"%@/folders/%@/photos?owner_id=%@&page=%d&access_token=%@",BASICURL_V1,folder_id,user_id,page,[SCPLoginPridictive currentToken]];
    }else{
        str = [NSString stringWithFormat:@"%@/folders/%@/photos?owner_id=%@&page=%d",BASICURL_V1,folder_id,user_id,page];
    }
    NSLog(@"%@",str);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            NSLog(@" %s ,%@",__FUNCTION__,[tempDic allKeys]);
            [tempDic setObject:dic forKey:@"photoList"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
        }
    }];
    [request startAsynchronous];
}
#pragma mark FeedMine
- (void)getFeedMineInfo
{
    NSString * str = [NSString stringWithFormat:@"%@/users/%@?access_token=%@",BASICURL_V1,[SCPLoginPridictive currentUserId],[SCPLoginPridictive currentToken]];
    NSLog(@"%@",str);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            [self getFeedMineWithPage:1];
            
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
        }
    }];
    [request startAsynchronous];
    
}
- (void)getFeedMineWithPage:(NSInteger)page
{
    NSString * str = [NSString stringWithFormat:@"%@/feed/mine?access_token=%@&page=%d",BASICURL_V1,[SCPLoginPridictive currentToken],page];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"feedList"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
        }
    }];
    [request startAsynchronous];
    
}
#pragma mark - Followings
- (void)getFollowingInfoWithUserID:(NSString * ) use_id
{
    NSString * str = [NSString stringWithFormat:@"%@/users/%@?access_token=%@",BASICURL_V1,use_id,[SCPLoginPridictive currentToken]];
    NSLog(@"%@",str);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            [self getfollowingsWihtUseId:use_id page:1];
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
        }
    }];
    [request startAsynchronous];
    
}
- (void)getfollowingsWihtUseId:(NSString *)user_id page:(NSInteger)pagenum
{
    NSString * str = nil;
    if (![SCPLoginPridictive isLogin]) {
        str = [NSString stringWithFormat:@"%@/followings?user_id=%@&page=%d",BASICURL_V1,user_id,pagenum];
    }else{
        str = [NSString stringWithFormat:@"%@/followings?user_id=%@&page=%d&access_token=%@",BASICURL_V1,user_id,pagenum,[SCPLoginPridictive currentToken]];
    }
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"Followings"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
        }
    }];
    [request startAsynchronous];
    
}
#pragma mark  - Followers
- (void)getFollowedsInfoWithUseID:(NSString *)user_id
{
    NSString * str = [NSString stringWithFormat:@"%@/users/%@?access_token=%@",BASICURL_V1,user_id,[SCPLoginPridictive currentToken]];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            [self getfollowedsWihtUseId:user_id page:1];
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
        }
    }];
    [request startAsynchronous];
}
- (void)getfollowedsWihtUseId:(NSString *)user_id page:(NSInteger)pagenum
{
    NSString * str = nil;
    if (![SCPLoginPridictive isLogin]) {
        str = [NSString stringWithFormat:@"%@/followers?user_id=%@&page=%d",BASICURL_V1,user_id,pagenum];
    }else{
        str = [NSString stringWithFormat:@"%@/followers?user_id=%@&page=%d&access_token=%@",BASICURL_V1,user_id,pagenum,[SCPLoginPridictive currentToken]];
    }
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"Followers"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
        }
    }];
    [request startAsynchronous];
}
#pragma mark Notificatin
- (void)getNotificationUser
{
    NSString * str = [NSString stringWithFormat:@"%@/notifications?access_token=%@",BASICURL_V1, [SCPLoginPridictive currentToken]];
    NSLog(@"%@",str);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setCompletionBlock:^{
//        NSLog(@"%@",[request responseString]);
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:dic]];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"网络连接异常"];
        }
    }];
    [request startAsynchronous];
}
- (void)destoryNotificationAndsuccess:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    
    NSString * str = [NSString stringWithFormat:@"%@/notifications/deletes?&access_token=%@",BASICURL_V1,
                      [SCPLoginPridictive currentToken]];
    NSLog(@"%@",str );
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
	[request setCompletionBlock:^{
//        NSLog(@"%@",[request responseString]);
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] < 300) {
            success([request responseString]);
        }else{
            failure(@"网络连接异常");
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"%@",[request error]);
        failure(@"网络连接异常");
    }];
    
    [request startAsynchronous];
}
#pragma mark - Action Follow
- (void)destoryFollowing:(NSString *)following_Id success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    
    NSString * str = [NSString stringWithFormat:@"%@/friendships/destroy?&access_token=%@",BASICURL_V1,[SCPLoginPridictive currentToken]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:[NSNumber numberWithInt:[following_Id intValue]] forKey:@"user_id"];
	[request setCompletionBlock:^{
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] < 300) {
            success([request responseString]);
        }else{
            failure(@"网络连接异常");
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"%@",[request error]);
        failure(@"网络连接异常");
    }];
    
    [request startAsynchronous];
}
- (void)friendshipsFollowing:(NSString *)following_Id success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"%@/friendships?&access_token=%@",BASICURL_V1,[SCPLoginPridictive currentToken]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:[NSNumber numberWithInt:[following_Id intValue]] forKey:@"user_id"];
	[request setCompletionBlock:^{
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] < 300) {
            success([request responseString]);
        }else{
            failure(@"网络连接异常");
        }
    }];
    [request setFailedBlock:^{
        failure(@"网络连接异常");
    }];
    [request startAsynchronous];
}

#pragma mark Delete
- (void)deleteFolderWithUserId:(NSString *)user_id folderId:(NSString *)folder_id success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
	NSString *url = [NSString stringWithFormat:@"%@/folders/%@?access_token=%@", BASICURL_V1,folder_id,[SCPLoginPridictive currentToken]];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.requestMethod = @"DELETE";
	[request setCompletionBlock:^{
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] < 300) {
            success([request responseString]);
        }else{
            failure(@"网络连接异常");
        }
    }];
    [request setFailedBlock:^{
        failure(@"网络连接异常");
    }];
    [request startAsynchronous];
}

- (void)deletePhotosWithUserId:(NSString *)user_id	folderId:(NSString *)folder_id photoIds:(NSArray *)photo_ids success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    
    NSString *url = [NSString stringWithFormat: @"%@/photos/batch_delete",BASICURL_V1];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setPostValue:[SCPLoginPridictive currentToken] forKey:@"access_token"];
    for (id ob in photo_ids)
        [request setPostValue:ob withoutRemoveforKey:@"photo_id"];
    [request setPostValue:folder_id forKey:@"folder_id"];
	[request setCompletionBlock:^{
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] < 300) {
            success([request responseString]);
        }else{
            failure(@"网络连接异常");
        }
    }];
    [request setFailedBlock:^{
        [request setFailedBlock:^{
            failure(@"网络连接异常");
        }];
    }];
    [request startAsynchronous];
}
- (void)createAlbumWithName:(NSString *)newName success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@/folders",BASICURL_V1];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:newName forKey:@"name"];
    [request setPostValue:[NSNumber numberWithBool:NO] forKey:@"is_public"];
    [request setPostValue:[SCPLoginPridictive currentToken] forKey:@"access_token"];
	[request setCompletionBlock:^{
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] < 300) {
            success([request responseString]);
        }else{
            failure(@"网络连接异常");
        }    }];
    [request setFailedBlock:^{
        failure(@"网络连接异常");
    }];
    [request startAsynchronous];
}

- (void)renameAlbumWithUserId:(NSString *)user_id folderId:(NSString *)folder_id newName:(NSString *)newName ispublic:(BOOL)ispublic success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    NSString *url = [NSString stringWithFormat: @"%@/folders/%@?access_token=%@",BASICURL_V1,folder_id,[SCPLoginPridictive currentToken]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:newName forKey:@"name"];
    [request setPostValue:[NSNumber numberWithBool:ispublic] forKey:@"is_public"];
    [request setRequestMethod:@"PUT"];
	[request setCompletionBlock:^{
        NSLog(@"RENAME:%@",[request responseString]);
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] < 300) {
            success([request responseString]);
        }else{
            failure(@"网络连接异常");
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"RENAME:%@",[request responseString]);
        failure(@"网络连接异常");
    }];
    [request startAsynchronous];
}

- (void)renameUserinfWithnewName:(NSString *)newName Withdescription:(NSString *)description success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    NSString *url = [NSString stringWithFormat: @"%@/user?access_token=%@",BASICURL_V1,[SCPLoginPridictive currentToken]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:newName forKey:@"name"];
    [request setPostValue:description forKey:@"description"];
    [request setRequestMethod:@"PUT"];
    
	[request setCompletionBlock:^{
        NSLog(@"%@",[request responseString]);
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] < 300) {
            success([request responseString]);
        }else{
            failure(@"网络连接异常");
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"%@",[request responseString]);
        failure(@"网络连接异常");
    }];
    [request startAsynchronous];
}
- (void)feedBackWithidea:(NSString *)idea success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    NSString * str =[NSString stringWithFormat:@"%@/feedback?access_token=%@",BASICURL_V1, [SCPLoginPridictive currentToken]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:idea forKey:@"content"];
    [request setCompletionBlock:^{
        NSLog(@"%@",[request responseString]);
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] < 300) {
            success([request responseString]);
        }else{
            failure(@"网络连接异常");
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"%@",[request responseString]);
        failure(@"网络连接异常");
    }];
    [request startAsynchronous];
    
}
@end
