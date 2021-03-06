//
//  SCPRequestManager.h
//  SCPNetWork
//
//  Created by sohu on 12-11-19.
//  Copyright (c) 2012年 Qu. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "URLLibaray.h"
#import "ASIHTTPRequest.h"
#import "UMFeedback.h"


#define TIMEOUT 10.f
#define STRINGENCODING NSUTF8StringEncoding
#define REQUSETFAILERROR @"当前网络不给力,请稍后重试"
#define REFRESHFAILTURE @"登录过期,请重新登录"
#define OAUTHFAILED 401

@class SCPRequestManager;

@protocol SCPRequestManagerDelegate <NSObject>
@optional
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info;
- (void)requestFailed:(NSString *)error;
- (void)SCPRequestManagerequestFailed:(NSString *)error;
@end


@interface SCPRequestManager : NSObject <ASIHTTPRequestDelegate, UMFeedbackDataDelegate>
{
    NSMutableDictionary * tempDic;
    id<SCPRequestManagerDelegate> _delegate;
	UMFeedback *umFeedBack;
}

@property (nonatomic,assign) id<SCPRequestManagerDelegate> delegate;

//Plaze
- (void)getPlazeFrom:(NSInteger)startIndex maxresult:(NSInteger)maxresult sucess:(void (^)(NSArray * infoArray))success failture:(void (^)(NSString * error))faiture;
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
- (void)destoryFollowing:(NSString *)user_id success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
- (void)friendshipsFollowing:(NSString *)user_id success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure;
- (void)deleteFolderWithUserId:(NSString *)user_id folderId:(NSString *)folder_id success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
#pragma  deletaFolders
- (void)deletePhotosWithUserId:(NSString *)user_id	folderId:(NSString *)folder_id photoIds:(NSArray *)photo_ids success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
- (void)createAlbumWithName:(NSString *)newName success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure;
- (void)renameAlbumWithUserId:(NSString *)user_id folderId:(NSString *)folder_id newName:(NSString *)newName ispublic:(BOOL)ispublic success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure;
- (void)renameUserinfWithnewName:(NSString *)newName Withdescription:(NSString *)description success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure;
- (void)feedBackWithidea:(NSString *)idea success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure;
- (void)editphotot:(NSString * )photo_id Description:(NSString *)des success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure;
@end
