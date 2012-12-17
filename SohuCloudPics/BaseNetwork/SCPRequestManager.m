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

#import "JSON.h"


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
    if (request) pageCount--;
    NSLog(@"%d ", pageCount);
	NSLog(@"__________________Request fail %@, %d code:%d", [request error],pageCount,[request responseStatusCode]);
    if (request) isFailed = YES;
    if (pageCount <= 0) return;
    [operationQuene cancelAllOperations];
    [tempDic removeAllObjects];
    
//    [self commonShowWhenRequsetFailed:request];
    if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
        [_delegate performSelector:@selector(requestFailed:) withObject:request];
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
- (void)getExploreFrom:(NSInteger)startIndex maxresult:(NSInteger)maxresult
{
    isFailed = NO;
    [operationQuene cancelAllOperations];
    [tempDic removeAllObjects];
    
    startPage = startIndex / 20;
    startPageOffset = startIndex % 20;
    endPage = ceil((startIndex +maxresult) / 20.f);
    maxResult = maxresult;
    pageCount = endPage - startPage;
    
    for (int i = 0; i < pageCount; i++) {
        NSString * url_str = [NSString stringWithFormat:@"%@%d",URL_EXPLORE,startPage + i];
        NSLog(@"explore:%@",url_str);
        NSURL * url = [NSURL URLWithString:url_str];
        [self addOperation:i URL:url action:@selector(explorerequestFinished:)];
    }
    [operationQuene go];
}

- (void)explorerequestFinished:(ASIHTTPRequest *)request
{
    
    NSString * str = [request responseString];
    NSDictionary * dic = [str JSONValue];
    NSArray * array = [dic objectForKey:@"photoList"];
    pageCount--;
    if (!array || ![array count]) {
        isFailed = YES;
    }
    if (isFailed && pageCount == 0) {
        [self requestFailed:nil];
        return;
    }
    if(!isFailed) {
        [tempDic setObject:array forKey:[NSNumber numberWithInt:request.tag]];
        if (pageCount == 0) {
            [self exploreoutputArray];
		}
    }
}

- (void)exploreoutputArray
{
    NSArray * finalarray = [NSArray arrayWithArray:nil];
    for (int i = 0; i < [tempDic allKeys].count; i++) {
        NSArray * array = [tempDic objectForKey:[NSNumber numberWithInt:i]];
        finalarray = [finalarray arrayByAddingObjectsFromArray:array];
    }
    NSInteger length = MIN(maxResult, finalarray.count - startPageOffset);
    finalarray  = [finalarray subarrayWithRange:(NSRange){startPageOffset,length}];
    NSDictionary * dic = [NSDictionary  dictionaryWithObject:finalarray forKey:@"NetworkDataSouce"];
    if ([_delegate respondsToSelector:@selector(requestFinished:output:)])
        [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:dic];
    [tempDic removeAllObjects];
}

#pragma mark - PhotoDetail
- (void)getPhotoDetailinfoWithUserID:(NSString *)user_id photoID:(NSString *)photo_ID
{
    isFailed = NO;
    pageCount = 1;
    NSString * url_str = URL_PHOTOINFO(user_id, photo_ID);
    NSURL * url = [NSURL URLWithString:url_str];
    [self addOperation:0 URL:url action:@selector(photoDetailrequestFinished:)];
    [operationQuene go];
}

- (void)photoDetailrequestFinished:(ASIHTTPRequest *)request
{
    NSString * str = [request responseString];
    NSDictionary * dic = [str JSONValue];
    if (!dic || ![dic allKeys].count) {
        [self requestFailed:nil];
    }
    if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
        [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:dic];
    }
}

#pragma mark - Personal Home

- (void)getUserInfoWithID:(NSString *)user_ID
{
    isFailed = NO;
    pageCount = 2;
    NSString * str_info = URL_USERINFO(user_ID);
    NSURL * url = [NSURL URLWithString:str_info];
    [self addOperation:0 URL:url action:@selector(userInfoFeedrequestFinished:)];
    [self getUserInfoFeedWithUserID:user_ID page:1 only:NO];
}

- (void)getUserInfoFeedWithUserID:(NSString *)user_ID page:(NSInteger)page only:(BOOL)only
{
    if (only) {
        isFailed = NO;
        pageCount = 1;
    }
    NSString * str_feed = URL_USERINFOFeed(user_ID, page);
    NSURL * url = [NSURL URLWithString:str_feed];
    [self addOperation:1 URL:url action:@selector(userInfoFeedrequestFinished:)];
    [operationQuene go];
}

- (void)userInfoFeedrequestFinished:(ASIHTTPRequest *)request
{
    NSString * str = [request responseString];
    NSDictionary * dic = [str JSONValue];
    if (0 == request.tag) {
        NSDictionary * info = [dic objectForKey:@"creator"];
        if (!info) {
            isFailed = YES;
        }else{
            [tempDic setObject:info forKey:@"userinfo"];
        }
    } else {
        NSArray * array = [dic objectForKey:@"photoList"];
        if (!array) {
            isFailed = YES;
        } else {
            [tempDic setObject:array forKey:@"photoList"];
        }
    }
    pageCount--;
    if (pageCount == 0) {
        if (isFailed) {
            [self requestFailed:nil];
        } else {
            if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
                [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:tempDic];
            }
        }
        [tempDic removeAllObjects];
    }
}
#pragma mark User Feed
- (void)getUserFollwesNumWithID:(NSString *)user_ID
{
    [operationQuene cancelAllOperations];
    
    isFailed = NO;
    pageCount = 2;
    NSString * str_info = URL_USERINFO(user_ID);
    NSURL * url = [NSURL URLWithString:str_info];
    [self addOperation:0 URL:url action:@selector(userFollowFeedrequestFinished:)];
    [self getUserFollowFeedWithUserID:user_ID page:1 only:NO];
}
- (void)getUserFollowFeedWithUserID:(NSString *)user_ID page:(NSInteger)page only:(BOOL)only
{
    if (only) {
        isFailed = NO;
        pageCount = 1;
    }
    
    NSString * str_info = [NSString stringWithFormat:@"%@/%d/?yuntu_token=%@",URL_USERFEED,page,user_ID];
    NSURL * url = [NSURL URLWithString:str_info];
    [self addOperation:1 URL:url action:@selector(userFollowFeedrequestFinished:)];
    [operationQuene go];
}
- (void)userFollowFeedrequestFinished:(ASIHTTPRequest *)request
{
    [self userInfoFeedrequestFinished:request];
}
#pragma mark - Follow Info
- (void)getUserFollowersWithUserID:(NSString *)user_ID page:(NSInteger)page
{
    isFailed = NO;
    pageCount = 1;
    NSString * str_url = URL_USERFOLLOWERS(user_ID, page);
    [self addOperation:0 URL:[NSURL URLWithString:str_url] action:@selector(followRequestFinished:)];
    [operationQuene go];
}
- (void)getUserFollowingsWithUserID:(NSString *)user_ID page:(NSInteger)page
{
    isFailed = NO;
    pageCount = 1;
    NSString * str_url = URL_USERFOLLOWINGS(user_ID,page);
    [self addOperation:0 URL:[NSURL URLWithString:str_url] action:@selector(followRequestFinished:)];
    [operationQuene go];
    
}
- (void)followRequestFinished:(ASIHTTPRequest *)request
{
    NSString * str = [request responseString];
    NSDictionary * dic = [str JSONValue];
    if (!dic) {
        [self requestFailed:nil];
    }else{
        if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
            [_delegate  performSelector:@selector(requestFinished:output:) withObject:self withObject:dic];
        }
    }
}
#pragma mark Follow Action

#pragma mark - Folders
- (void)getFoldersWithID:(NSString *)user_id page:(NSInteger)page  yuntuToken:(NSString *)token
{
    NSString * foldersURL = nil;
    pageCount = 1;
    if (!token) {
    	foldersURL = [NSString stringWithFormat:API_BASE "/u/%@/folders/%d", user_id, page];
    }else{
        foldersURL = [NSString stringWithFormat:API_BASE "/u/%@/folders/%d?yuntu_token=%@", user_id, page,token];
    }
	NSURL *url = [NSURL URLWithString:foldersURL];
	[self addOperation:0 URL:url action:@selector(getFoldersFinished:)];
	[operationQuene go];
}

- (void)getFoldersFinished:(ASIHTTPRequest *)request
{
    
	if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
        [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[[request responseString] JSONValue]];
	}
}

#pragma mark - Covers
- (void)getFolderCoverURLWithUserId:(NSString *)user_id folderID:(NSString *)folder_id coverShowId:(NSString *)cover_id tag:(int)tag
{
    pageCount = 1;
	if ([cover_id isEqualToString:@"0"]) {
		NSString *photosURL = [NSString stringWithFormat:API_BASE "/u/%@/f%@/%d", user_id, folder_id, 1];
		NSURL *url = [NSURL URLWithString:photosURL];
		[self addOperation:tag URL:url action:@selector(getPhotoForCoverURLFinished:)];
		[operationQuene go];
		
	} else {
		NSString *photoURL = [NSString stringWithFormat:API_BASE "/u/%@/p%@", user_id, cover_id];
		NSURL *url = [NSURL URLWithString:photoURL];
		[self addOperation:tag URL:url action:@selector(getFolderCoverURLFinished:)];
		[operationQuene go];
	}
}

- (void)getPhotoForCoverURLFinished:(ASIHTTPRequest *)request
{
	if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
		NSArray *photoList = [[[request responseString] JSONValue] objectForKey:@"photoList"];
		NSMutableDictionary *result = [NSMutableDictionary dictionary];
		if (photoList.count == 0) {
			[result setObject:[NSNull null] forKey:@"url"];
		} else {
			[result addEntriesFromDictionary:[photoList objectAtIndex:0]];
		}
		[result setObject:[NSNumber numberWithInt:request.tag] forKey:@"tag"];
        [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:result];
	}
}

- (void)getFolderCoverURLFinished:(ASIHTTPRequest *)request
{
	if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
		NSMutableDictionary *result = [NSMutableDictionary dictionary];
		[result addEntriesFromDictionary:[[[request responseString] JSONValue] objectForKey:@"photo"]];
		[result setObject:[NSNumber numberWithInt:request.tag] forKey:@"tag"];
        [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:result];
	}
}

#pragma mark - Photos
- (void)getPhotosWithUserID:(NSString *)user_id FolderID:(NSString *)folder_id page:(NSInteger)page
{
	isFailed = NO;
	pageCount = 1;
	NSString *photosURL = [NSString stringWithFormat:API_BASE "/u/%@/f%@/%d", user_id, folder_id, page];
	NSURL *url = [NSURL URLWithString:photosURL];
	[self addOperation:0 URL:url action:@selector(getPhotosFinished:)];
	[operationQuene go];
}

- (void)getPhotosFinished:(ASIHTTPRequest *)request
{
	if ([_delegate respondsToSelector:@selector(requestFinished:output:)]) {
        [_delegate performSelector:@selector(requestFinished:output:) withObject:self withObject:[[request responseString] JSONValue]];
	}
}
#pragma mark  - Action
#pragma mark Like_Unlike
- (void)makeUser:(NSString *)user_ID likephotoWith:(NSString *)photo_useID :(NSString *)photo_ID success:(void (^) (NSString * response))success
{
    NSString * url_like = [NSString stringWithFormat:@"%@/like/%@/p%@?yuntu_token=%@",API_BASE,photo_useID,photo_ID,user_ID];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url_like]];
    [self addRequestHeaderIn:request];
    [request setCompletionBlock:^{
        NSString * str = [request responseString];
        dispatch_async(dispatch_get_main_queue(), ^{
            success(str);
        });
    }];
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showWhenRequsetFailed:request];
        });
    }];
    [request startAsynchronous];
}

- (void)makeUser:(NSString *)user_ID unLikephotoWith:(NSString *)photo_useID :(NSString *)photo_ID success:(void (^) (NSString * response))success 
{
    NSString * url_like = [NSString stringWithFormat:@"%@/unlike/%@/p%@?yuntu_token=%@",API_BASE,photo_useID,photo_ID,user_ID];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url_like]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setCompletionBlock:^{
        NSString * str = [request responseString];
        
        NSLog(@"%s,%@ end",__FUNCTION__, str);
        dispatch_async(dispatch_get_main_queue(), ^{
            success(str);
        });
    }];
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showWhenRequsetFailed:request];
        });
    }];
    [request startAsynchronous];
}

- (NSData *)convertDicToData:(NSDictionary *)dic
{
    
    NSMutableData * data = [NSMutableData dataWithCapacity:0];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:dic forKey: @"mydata"];
    [archiver finishEncoding];
    [archiver release];
    return data;
}
#pragma mark Delete
- (void)deleteFolderWithUserId:(NSString *)user_id folderId:(NSString *)folder_id success:(void (^) (NSString * response))success 
{
	NSString *url = [NSString stringWithFormat:API_BASE "/folders/%@?yuntu_token=%@", folder_id, user_id];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.requestMethod = @"DELETE";
    [request addRequestHeader:@"accept" value:@"application/json"];
	[request setCompletionBlock:^{
        NSString * str = [request responseString];
        dispatch_async(dispatch_get_main_queue(), ^{
            success(str);
        });
    }];
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showWhenRequsetFailed:request];
        });
    }];
    [request startAsynchronous];
}
- (void)deletePhotosWithUserId:(NSString *)user_id	folderId:(NSString *)folder_id photoIds:(NSArray *)photo_ids success:(void (^) (NSString * response))success  
{
    
    NSString *url = [NSString stringWithFormat:API_BASE "/photos/deletes?yuntu_token=%@", user_id];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    for (id ob in photo_ids)
        [request setPostValue:ob withoutRemoveforKey:@"id"];
    [request setPostValue:folder_id forKey:@"folder_id"];
    
	[request setCompletionBlock:^{
        NSString * str = [request responseString];
        dispatch_async(dispatch_get_main_queue(), ^{
            success(str);
        });
    }];
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showWhenRequsetFailed:request];
        });
    }];
    [request startAsynchronous];
    
}
- (void)renameAlbumWithUserId:(NSString *)user_id folderId:(NSString *)folder_id newName:(NSString *)newName success:(void (^) (NSString * response))success
{
    NSString *url = [NSString stringWithFormat:API_BASE "/folders/%@/rename?_method=PUT&yuntu_token=%@",folder_id,user_id];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setPostValue:newName forKey:@"new_name"];
    
	[request setCompletionBlock:^{
        NSString * str = [request responseString];
        dispatch_async(dispatch_get_main_queue(), ^{
            success(str);
        });
    }];
    
    [request setFailedBlock:^{
        NSLog(@"%s failture %d",__FUNCTION__, [request responseStatusCode]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showWhenRequsetFailed:request];
        });
    }];
    [request startAsynchronous];
    
}

- (void)createAlbumWithUserId:(NSString *)user_id  name:(NSString *)newName success:(void (^) (NSString * response))success
{
    NSString *url = [NSString stringWithFormat:API_BASE "/folders?yuntu_token=%@",user_id];
    
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    
    [request setPostValue:newName forKey:@"name"];
    [request setPostValue:[NSNumber numberWithBool:YES] forKey:@"isPublic"];
	[request setCompletionBlock:^{
        NSString * str = [request responseString];
        dispatch_async(dispatch_get_main_queue(), ^{
            success(str);
        });
    }];
    [request setFailedBlock:^{
        NSLog(@"%s failture %d",__FUNCTION__, [request responseStatusCode]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showWhenRequsetFailed:request];
        });
    }];
    [request startAsynchronous];
}
- (BOOL)whetherFollowUs:(NSString *)following_Id userID:(NSString *)useId success:(void (^) (NSString * response))success
{
    NSString *url = [NSString stringWithFormat:API_BASE "/v1/friendships?user_id=%@&yuntu_token=%@",following_Id,useId];
    NSLog(@"%@",url);
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setTimeOutSeconds:5];
    [request startSynchronous];
    NSLog(@"request %@",[request responseString]);
    return NO;
}
- (void)destoryFollowing:(NSString *)following_Id userID:(NSString *)useId success:(void (^) (NSString * response))success
{
    NSString *url = [NSString stringWithFormat:API_BASE "/friendships/destroy?yuntu_token=%@",useId];
    
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setPostValue:[NSNumber numberWithInt:[following_Id intValue]] forKey:@"followed_id"];
	[request setCompletionBlock:^{
        NSString * str = [request responseString];
        dispatch_async(dispatch_get_main_queue(), ^{
            success(str);
        });
    }];
    [request setFailedBlock:^{
        NSLog(@"%s failture %d",__FUNCTION__, [request responseStatusCode]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showWhenRequsetFailed:request];
        });
    }];
    [request startAsynchronous];
}
- (void)friendshipsFollowing:(NSString *)following_Id userID:(NSString *)useId success:(void (^) (NSString * response))success
{
    
    NSString *url = [NSString stringWithFormat:API_BASE "/friendships?yuntu_token=%@",useId];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setPostValue:[NSNumber numberWithInt:[following_Id intValue]] forKey:@"followed_id"];
	[request setCompletionBlock:^{
        NSString * str = [request responseString];
        dispatch_async(dispatch_get_main_queue(), ^{
            success(str);
        });
    }];
    [request setFailedBlock:^{
        NSLog(@"%s failture %d",__FUNCTION__, [request responseStatusCode]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showWhenRequsetFailed:request];
        });
    }];
    [request startAsynchronous];
}
@end
