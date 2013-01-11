//
//  SCPRequestManager.h
//  SCPNetWork
//
//  Created by sohu on 12-11-19.
//  Copyright (c) 2012年 Qu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequestDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

//外网
//#define BASICURL_V1 @"http://61.135.181.37:8888/api/v1"
//内网
#define BASICURL_V1 @"http://10.10.68.104:8888/api/v1"
//内网延时
//#define BASICURL_V1 @"http://10.10.68.104:8889/api/v1"

@class SCPRequestManager;

@protocol SCPRequestManagerDelegate <NSObject>
@optional
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info;
- (void)requestFailed:(NSString *)error;
@end


@interface SCPRequestManager : NSObject<ASIHTTPRequestDelegate>
{
    NSMutableDictionary * tempDic;
    id<SCPRequestManagerDelegate> _delegate;
    
}

@property (nonatomic,assign) id<SCPRequestManagerDelegate> delegate;

- (void)getExploreFrom:(NSInteger)startIndex maxresult:(NSInteger)maxresult sucess:(void (^)(NSArray * infoArray))success failture:(void (^)(NSString * error))faiture;
- (void)getPhotoDetailinfoWithUserID:(NSString *)user_id photoID:(NSString *)photo_ID;
//personal Home
- (void)getUserInfoWithID:(NSString *)user_ID asy:(BOOL)isAsy success:(void (^) (NSDictionary * response))success  failure:(void (^) (NSString * error))failure;
- (void)getUserInfoWithID:(NSString *)user_ID;
- (void)getUserInfoFeedWithUserID:(NSString *)user_ID page:(NSInteger)page;
//Folders
- (void)getFoldersinfoWithID:(NSString *)uses_id;
- (void)getFoldersWithID:(NSString *)user_id page:(NSInteger)page;
//photoList
- (void)getFolderinfoWihtUserID:(NSString *)user_id WithFolders:(NSString *)folder_id;
- (void)getPhotosWithUserID:(NSString *)user_id FolderID:(NSString *)folder_id page:(NSInteger)page;
//token

//Feed
- (void)getFeedMineInfo;
- (void)getFeedMineWithPage:(NSInteger)page;
//Followings
- (void)getFollowingInfoWithUserID:(NSString * ) use_id;
- (void)getfollowingsWihtUseId:(NSString *)user_id page:(NSInteger)pagenum;
//Followed
- (void)getFollowedsInfoWithUseID:(NSString *)user_id;
- (void)getfollowedsWihtUseId:(NSString *)user_id page:(NSInteger)pagenum;
//Notification
- (void)getNotificationUser;
- (void)destoryNotificationAndsuccess:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;


#pragma mark Action
#pragma Follwe_Action
- (void)destoryFollowing:(NSString *)following_Id success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
- (void)friendshipsFollowing:(NSString *)following_Id success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure;
- (void)deleteFolderWithUserId:(NSString *)user_id folderId:(NSString *)folder_id success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
#pragma  deletaFolders
- (void)deletePhotosWithUserId:(NSString *)user_id	folderId:(NSString *)folder_id photoIds:(NSArray *)photo_ids success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
- (void)createAlbumWithName:(NSString *)newName success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure;
- (void)renameAlbumWithUserId:(NSString *)user_id folderId:(NSString *)folder_id newName:(NSString *)newName ispublic:(BOOL)ispublic success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure;
- (void)renameUserinfWithnewName:(NSString *)newName Withdescription:(NSString *)description success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure;
- (void)feedBackWithidea:(NSString *)idea success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure;
@end
