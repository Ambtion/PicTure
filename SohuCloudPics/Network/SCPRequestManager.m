//
//  SCPRequestManager.m
//  SCPNetWork
//
//  Created by sohu on 12-11-19.
//  Copyright (c) 2012年 Qu. All rights reserved.
//

#import "SCPRequestManager.h"
#import "ASIFormDataRequest.h"
#import "SCPLoginPridictive.h"
#import "JSON.h"
#import "SCPAlert_CustomeView.h"


#define TIMEOUT 10.f
#define STRINGENCODING NSUTF8StringEncoding
#define REQUSETFAILERROR @"当前网络不给力,请稍后重试"
#define OAUTHFAILED 401
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
- (void)refreshToken:(NSInteger)requsetStatusCode
{
    if (requsetStatusCode != OAUTHFAILED) return;
    NSString * str = [NSString stringWithFormat:@"%@/oauth2/access_token?grant_type=refresh_token",BASICURL];
    __block  ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:CLIENT_ID forKey:@"client_id"];
    [request setPostValue:CLIENT_SECRET forKey:@"client_secret"];
    NSLog(@"ACCESS_TOKEN:%@",[SCPLoginPridictive currentToken]);
    [request setPostValue:[SCPLoginPridictive refreshToken] forKey:@"refresh_token"];
    [request setCompletionBlock:^{
        if ([request responseStatusCode] == 200) {
            NSDictionary * dic = [[request responseString] JSONValue];
            [SCPLoginPridictive refreshToken:[NSString stringWithFormat:@"%@",[dic objectForKey:@"access_token"]] RefreshToken:[NSString stringWithFormat:@"%@",[dic objectForKey:@"refresh_token"]]];
        }else{
            SCPAlert_CustomeView * cus = [[[SCPAlert_CustomeView alloc] initWithTitle:@"认证失败,请重新登录"] autorelease];
            [cus show];
        }
    }];
    [request setFailedBlock:^{
        SCPAlert_CustomeView * cus = [[[SCPAlert_CustomeView alloc] initWithTitle:@"认证失败,请重新登录"] autorelease];
        [cus show];
    }];
    [request startAsynchronous];
}
- (BOOL)handlerequsetStatucode:(NSInteger)requsetCode
{
    NSLog(@"%s",__FUNCTION__);

    if (requsetCode >= 200 && requsetCode <= 300) return YES;
    
    if (requsetCode == 401) [self refreshToken:401];
    
    if ([_delegate respondsToSelector:@selector(requestFailed:)])
        [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
    
    return NO;
}
- (BOOL)handlerequsetStatucode:(NSInteger)requsetCode withblock:(void (^) (NSString * error))failure
{
    NSLog(@"%s",__FUNCTION__);
    if (requsetCode >= 200 && requsetCode <= 300) return YES;
    if (requsetCode == 401) [self refreshToken:401];
    failure(REQUSETFAILERROR);
    return NO;
}


#pragma mark - Explore
- (void)getExploreFrom:(NSInteger)startIndex maxresult:(NSInteger)maxresult sucess:(void (^)(NSArray * infoArray))success failture:(void (^)(NSString * error))faiture
{
//    NSString * str_url = [NSString stringWithFormat:@"%@/plaza?start=%d&count=%d",BASICURL_V1,startIndex,maxresult];
//    ASIHTTPRequest * requset = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str_url]];
//    [requset setTimeOutSeconds:TIMEOUT];
//    [requset setDelegate:self];
//    [requset startAsynchronous];
    NSString * str_url = [NSString stringWithFormat:@"%@/plaza?start=%d&count=%d",BASICURL_V1,startIndex,maxresult];
    NSLog(@"%@",str_url);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str_url]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:faiture]){
            success([[[request responseString] JSONValue] objectForKey:@"photos"]);
        }
    }];
    [request setFailedBlock:^{
        faiture(REQUSETFAILERROR);
    }];
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300){
        if ([_delegate respondsToSelector:@selector(requestFinished:output:)])
            [_delegate requestFinished:nil output:[[request responseString] JSONValue]];
    }else {
        [self requestFailed:nil];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if ([_delegate respondsToSelector:@selector(SCPRequestManagerequestFailed:)]) {
        [_delegate SCPRequestManagerequestFailed:REQUSETFAILERROR];
    }
}

#pragma mark - PhotoDetail
- (void)getPhotoDetailinfoWithUserID:(NSString *)user_id photoID:(NSString *)photo_ID
{
    NSString * str = [NSString stringWithFormat:@"%@/photos/%@?owner_id=%@",BASICURL_V1,photo_ID,user_id];
    NSLog(@"%@",str);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:dic];
            }
        }
    }];
    
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
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
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        
        NSInteger  code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:failure]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            success(dic);
        }
    }];
    [request setFailedBlock:^{
        failure(REQUSETFAILERROR);
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
    }else{
        str = [NSString stringWithFormat:@"%@/users/%@",BASICURL_V1,user_ID];
    }
    
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    
    [request setCompletionBlock:^{
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            [self getUserInfoFeedWithUserID:user_ID page:1];
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
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
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"feedList"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
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
    
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            [self getFoldersWithID:uses_id page:1];
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
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
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"folderinfo"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
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
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"folderInfo"];
            [self getPhotosWithUserID:user_id FolderID:folder_id page:1];
        }
    }];
    
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
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
    
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            NSLog(@" %s ,%@",__FUNCTION__,[tempDic allKeys]);
            [tempDic setObject:dic forKey:@"photoList"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
        }
    }];
    [request startAsynchronous];
}

#pragma mark FeedMine
- (void)getFeedMineInfo
{
    NSString * str = [NSString stringWithFormat:@"%@/users/%@?access_token=%@",BASICURL_V1,[SCPLoginPridictive currentUserId],[SCPLoginPridictive currentToken]];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            [self getFeedMineWithPage:1];
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
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
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"feedList"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
        }
    }];
    [request startAsynchronous];
    
}
#pragma mark - Followings
- (void)getFollowingInfoWithUserID:(NSString * ) use_id
{
    NSString * str = [NSString stringWithFormat:@"%@/users/%@?access_token=%@",BASICURL_V1,use_id,[SCPLoginPridictive currentToken]];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setCompletionBlock:^{
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            [self getfollowingsWihtUseId:use_id page:1];
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
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
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"Followings"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
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
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            [self getfollowedsWihtUseId:user_id page:1];
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
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
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"Followers"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
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
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:dic]];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:REQUSETFAILERROR];
        }
    }];
    [request startAsynchronous];
}
- (void)destoryNotificationAndsuccess:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    
    NSString * str = [NSString stringWithFormat:@"%@/notifications/deletes?&access_token=%@",BASICURL_V1,
                      [SCPLoginPridictive currentToken]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
	[request setCompletionBlock:^{
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:failure]) {
            success([request responseString]);
        }
    }];
    [request setFailedBlock:^{
        failure(REQUSETFAILERROR);
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
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:failure]) {
            success([request responseString]);
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"%@",[request error]);
        failure(REQUSETFAILERROR);
    }];
    
    [request startAsynchronous];
}
- (void)friendshipsFollowing:(NSString *)following_Id success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"%@/friendships?&access_token=%@",BASICURL_V1,[SCPLoginPridictive currentToken]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:[NSNumber numberWithInt:[following_Id intValue]] forKey:@"user_id"];
	[request setCompletionBlock:^{
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:failure]) {
            success([request responseString]);
        }
    }];
    [request setFailedBlock:^{
        failure(REQUSETFAILERROR);
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
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:failure]) {
            success([request responseString]);
        }
    }];
    [request setFailedBlock:^{
        failure(REQUSETFAILERROR);
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
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:failure]) {
            success([request responseString]);
        }
    }];
    [request setFailedBlock:^{
        [request setFailedBlock:^{
            failure(REQUSETFAILERROR);
        }];
    }];
    [request startAsynchronous];
}
- (void)createAlbumWithName:(NSString *)newName success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@/folders",BASICURL_V1];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setStringEncoding:STRINGENCODING];
    [request setPostValue:newName forKey:@"name"];
    [request setPostValue:[NSNumber numberWithBool:NO] forKey:@"is_public"];
    [request setPostValue:[SCPLoginPridictive currentToken] forKey:@"access_token"];
	[request setCompletionBlock:^{
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:failure]) {
            success([request responseString]);
        }
    }];
    [request setFailedBlock:^{
        failure(REQUSETFAILERROR);
    }];
    [request startAsynchronous];
}

- (void)renameAlbumWithUserId:(NSString *)user_id folderId:(NSString *)folder_id newName:(NSString *)newName ispublic:(BOOL)ispublic success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    NSString *url = [NSString stringWithFormat: @"%@/folders/%@?access_token=%@",BASICURL_V1,folder_id,[SCPLoginPridictive currentToken]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setStringEncoding:STRINGENCODING];
    [request setPostValue:newName forKey:@"name"];
    [request setPostValue:[NSNumber numberWithBool:ispublic] forKey:@"is_public"];
    [request setRequestMethod:@"PUT"];
	[request setCompletionBlock:^{
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:failure]) {
            success([request responseString]);
        }
    }];
    [request setFailedBlock:^{
        failure(REQUSETFAILERROR);
    }];
    [request startAsynchronous];
}

- (void)renameUserinfWithnewName:(NSString *)newName Withdescription:(NSString *)description success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    NSString *url = [NSString stringWithFormat: @"%@/user?access_token=%@",BASICURL_V1,[SCPLoginPridictive currentToken]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setStringEncoding:STRINGENCODING];
    [request setPostValue:newName forKey:@"name"];
    [request setPostValue:description forKey:@"description"];
    [request setRequestMethod:@"PUT"];
	[request setCompletionBlock:^{
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:failure]) {
            success([request responseString]);
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"%@",[request responseString]);
        failure(REQUSETFAILERROR);
    }];
    [request startAsynchronous];
}
- (void)feedBackWithidea:(NSString *)idea success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    
    NSString * str =[NSString stringWithFormat:@"%@/feedback?access_token=%@",BASICURL_V1, [SCPLoginPridictive currentToken]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setStringEncoding:STRINGENCODING];
    [request setPostValue:idea forKey:@"content"];
    [request setData:nil forKey:@"mm"];
    [request setCompletionBlock:^{
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:failure]) {
            success([request responseString]);
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"%@",[request responseString]);
        failure(REQUSETFAILERROR);
    }];
    [request startAsynchronous];
    
}
- (void)editphotot:(NSString * )photo_id Description:(NSString *)des success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    NSString * str =[NSString stringWithFormat:@"%@/photos/%@?access_token=%@",BASICURL_V1,photo_id,[SCPLoginPridictive currentToken]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setStringEncoding:STRINGENCODING];
    [request setPostValue:des forKey:@"description"];
    [request setRequestMethod:@"PUT"];
    [request setCompletionBlock:^{
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:failure]) {
            success([request responseString]);
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"%@",[request responseString]);
        failure(REQUSETFAILERROR);
    }];
    [request startAsynchronous];
}
@end
