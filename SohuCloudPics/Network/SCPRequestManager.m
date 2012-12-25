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

#define BASICURL_V1 @"http://10.10.68.104:8888/api/v1"

@implementation SCPRequestManager (common)

- (void)addOperation:(NSInteger)tag URL:(NSURL *)url method:(NSString *)method action:(SEL)action
{
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	request.requestMethod = method;
    [self addRequestHeaderIn:request];
    request.tag = tag;
    request.delegate = self;
    [request setDidFinishSelector:action];
    [request setDidFailSelector:@selector(requestFailed:)];
    [operationQuene addOperation:request];
}

- (void)addOperation:(NSInteger)tag URL:(NSURL *)url action:(SEL)action
{
	[self addOperation:tag URL:url method:@"GET" action:action];
}

- (void)addRequestHeaderIn:(ASIHTTPRequest *)request
{
    [request addRequestHeader:@"accept" value:@"application/json"];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
        [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
    }
    
}
- (void)commonShowWhenRequsetFailed:(ASIHTTPRequest *)request
{
    UIAlertView * alter = [[[UIAlertView alloc] initWithTitle:@"请求失败" message:[NSString stringWithFormat:@"%@",[request error]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alter show];
    
}

@end


@implementation SCPRequestManager

@synthesize delegate = _delegate;

- (void)showWhenRequsetFailed:(ASIHTTPRequest *)request
{
    UIAlertView * alter = [[[UIAlertView alloc] initWithTitle:@"请求失败" message:[NSString stringWithFormat:@"%@",[request error]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alter show];
}

- (id)init
{
    self = [super init];
    if (self) {
        operationQuene = [[ASINetworkQueue alloc] init];
        operationQuene.maxConcurrentOperationCount  = 8;
        tempDic = [[NSMutableDictionary dictionaryWithCapacity:0] retain];
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:_delegate];
    [operationQuene cancelAllOperations];
    [operationQuene setRequestDidFinishSelector:nil];
    [operationQuene setRequestDidFailSelector:nil];
    [operationQuene release];
    [tempDic release];
    [super dealloc];
}

#pragma mark - Explore
- (void)getExploreFrom:(NSInteger)startIndex maxresult:(NSInteger)maxresult sucess:(void (^)(NSArray * infoArray))success failture:(void (^)(NSString * error))faiture
{
    
    NSString * str_url = [NSString stringWithFormat:@"%@/plaza?start=%d&count=%d",BASICURL_V1,startIndex,maxresult];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str_url]];
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        NSLog(@"sucess StatusCode : %d",[request responseStatusCode]);
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
//            NSLog(@"%@",[[[[request responseString] JSONValue] objectForKey:@"photos"] lastObject]);
            success([[[request responseString] JSONValue] objectForKey:@"photos"]);
        }else {
            faiture([NSString stringWithFormat:@"请求失败"]);
        }
    }];
    [request setFailedBlock:^{
        faiture(@"连接失败");
    }];
    [request startAsynchronous];
}

#pragma mark - PhotoDetail
- (void)getPhotoDetailinfoWithUserID:(NSString *)user_id photoID:(NSString *)photo_ID
{
    NSString * str = [NSString stringWithFormat:@"%@/photos/%@?owner_id=%@",BASICURL_V1,photo_ID,user_id];
    NSLog(@"%@",str);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        [self photoDetailrequestFinished:request];
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
        }
    }];
    [request startAsynchronous];
}
- (void)photoDetailrequestFinished:(ASIHTTPRequest *)request
{
    
    if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
        NSString * str = [request responseString];
        NSDictionary * dic = [str JSONValue];
//        NSLog(@"%@",dic);
        if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
            [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:dic];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"请求失败"];
        }
    }
}
#pragma mark - Personal Home
- (void)getUserInfoWithID:(NSString *)user_ID
{
    
    NSString  * str = nil;
    if ([SCPLoginPridictive currentToken]) {
        str = [NSString stringWithFormat:@"%@/users/%@?access_token=%@",BASICURL_V1,user_ID,[SCPLoginPridictive currentToken]];
        NSLog(@"Login:%@", str);
    }else{
      str = [NSString stringWithFormat:@"%@/users/%@",BASICURL_V1,user_ID];
    }
    NSLog(@"%@",str);
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            [self getUserInfoFeedWithUserID:user_ID page:1];
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"请求失败"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
        }
    }];
    [request startAsynchronous];
}
- (void)getUserInfoFeedWithUserID:(NSString *)user_ID page:(NSInteger)page
{
    NSString * str = [NSString stringWithFormat:@"%@/feed?user_id=%@&page=%d",BASICURL_V1,user_ID,page];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"feedList"];
            NSLog(@"tempdic %@",[tempDic objectForKey:@"userInfo"]);
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"请求失败"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
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
        NSLog(@"Login:%@", str);
    }else{
        str = [NSString stringWithFormat:@"%@/users/%@",BASICURL_V1,uses_id];
    }
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            [self getFoldersWithID:uses_id page:1];
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"请求失败"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
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
    [request setTimeOutSeconds:5];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"folderinfo"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"请求失败"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
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
        NSLog(@"Login:%@", str);
    }else{
        str = [NSString stringWithFormat:@"%@/folders/%@?owner_id=%@",BASICURL_V1,folder_id,user_id];
    }
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"folderInfo"];
            [self getPhotosWithUserID:user_id FolderID:folder_id page:1];
            
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"请求失败"];
            }
        }
    }];
    
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
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
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
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
                [_delegate performSelector:@selector(requestFailed:) withObject:@"请求失败"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
        }
    }];
    [request startAsynchronous];
}
#pragma mark FeedMine
- (void)getFeedMineInfo
{
    NSString * str = [NSString stringWithFormat:@"%@/users/%@?access_token=%@",BASICURL_V1,[SCPLoginPridictive currentUserId],[SCPLoginPridictive currentToken]];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            [self getFeedMineWithPage:1];
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"请求失败"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
        }
    }];
    [request startAsynchronous];
    
}
- (void)getFeedMineWithPage:(NSInteger)page
{
    NSString * str = [NSString stringWithFormat:@"%@/feed/mine?access_token=%@&page=%d",BASICURL_V1,[SCPLoginPridictive currentToken],page];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"feedList"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"请求失败"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
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
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            [self getfollowingsWihtUseId:use_id page:1];
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"请求失败"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
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
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"Followings"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"请求失败"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
        }
    }];
    [request startAsynchronous];
    
}
#pragma mark  - Followers
- (void)getFollowedsInfoWithUseID:(NSString *)user_id
{
    NSString * str = [NSString stringWithFormat:@"%@/users/%@?access_token=%@",BASICURL_V1,user_id,[SCPLoginPridictive currentToken]];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic removeAllObjects];
            [tempDic setObject:dic forKey:@"userInfo"];
            [self getfollowedsWihtUseId:user_id page:1];
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"请求失败"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
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
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
            NSString * str = [request responseString];
            NSDictionary * dic = [str JSONValue];
            [tempDic setObject:dic forKey:@"Followers"];
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[NSDictionary dictionaryWithDictionary:tempDic]];
                [tempDic removeAllObjects];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
                [_delegate performSelector:@selector(requestFailed:) withObject:@"请求失败"];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
            [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
        }
    }];
    [request startAsynchronous];
}

#pragma mark - Follow
- (void)destoryFollowing:(NSString *)following_Id success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"%@/friendships/destroy?&access_token=%@",BASICURL_V1,[SCPLoginPridictive currentToken]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:[NSNumber numberWithInt:[following_Id intValue]] forKey:@"user_id"];
	[request setCompletionBlock:^{
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] <= 300) {
            success([request responseString]);
        }else{
            failure(@"请求失败");
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"%@",[request error]);
        failure(@"连接失败");
    }];
    
    [request startAsynchronous];
}
- (void)friendshipsFollowing:(NSString *)following_Id success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"%@/friendships?&access_token=%@",BASICURL_V1,[SCPLoginPridictive currentToken]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:[NSNumber numberWithInt:[following_Id intValue]] forKey:@"user_id"];
	[request setCompletionBlock:^{
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] <= 300) {
            success([request responseString]);
        }else{
            failure(@"请求失败");
        }
    }];
    [request setFailedBlock:^{
        failure(@"连接失败");
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
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] <= 300) {
            success([request responseString]);
        }else{
            failure(@"请求失败");
        }
    }];
    [request setFailedBlock:^{
        failure(@"连接失败");
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
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] <= 300) {
            success([request responseString]);
        }else{
            failure(@"请求失败");
        }
    }];
    [request setFailedBlock:^{
        [request setFailedBlock:^{
            failure(@"连接失败");
        }];
    }];
    [request startAsynchronous];
}
- (void)createAlbumWithName:(NSString *)newName success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@/folders",BASICURL_V1];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setPostValue:newName forKey:@"name"];
    [request setPostValue:[NSNumber numberWithBool:NO] forKey:@"is_public"];
    [request setPostValue:[SCPLoginPridictive currentToken] forKey:@"access_token"];
	[request setCompletionBlock:^{
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] <= 300) {
            success([request responseString]);
        }else{
            failure(@"请求失败");
        }    }];
    [request setFailedBlock:^{
        failure(@"连接失败");
    }];
    [request startAsynchronous];
}

- (void)renameAlbumWithUserId:(NSString *)user_id folderId:(NSString *)folder_id newName:(NSString *)newName success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    NSString *url = [NSString stringWithFormat: @"%@/folders/%@?access_token=%@",BASICURL_V1,folder_id,[SCPLoginPridictive currentToken]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setPostValue:newName forKey:@"new_name"];
    [request setRequestMethod:@"PUT"];
	[request setCompletionBlock:^{
        
        NSLog(@"%@",[request responseString]);
        if ([request responseStatusCode] >= 200 && [request responseStatusCode] <= 300) {
            success([request responseString]);
        }else{
            failure(@"请求失败");
        }
    }];
    [request setFailedBlock:^{
        failure(@"连接失败");
    }];
    
    [request startAsynchronous];
    
}



@end
