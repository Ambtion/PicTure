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


@class SCPRequestManager;

@protocol SCPRequestManagerDelegate <NSObject>
@optional
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info;
- (void)requestFailed:(NSString *)error;
@end



@interface SCPRequestManager : NSObject<ASIHTTPRequestDelegate>
{
    
    ASINetworkQueue * operationQuene;
    NSInteger startPage;
    NSInteger startPageOffset;
    NSInteger endPage;
    NSInteger maxResult;
    
    NSInteger pageCount;
    NSMutableDictionary * tempDic;
    BOOL isFailed;
    id<SCPRequestManagerDelegate> _delegate;
}

@property (nonatomic,assign) id<SCPRequestManagerDelegate> delegate;

- (void)getExploreFrom:(NSInteger)startIndex maxresult:(NSInteger)maxresult sucess:(void (^)(NSArray * infoArray))success failture:(void (^)(NSString * error))faiture;
- (void)getPhotoDetailinfoWithUserID:(NSString *)user_id photoID:(NSString *)photo_ID;
//personal Home
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



#pragma mark Action
- (void)makeUser:(NSString *)user_ID likephotoWith:(NSString *)photo_useID :(NSString *)photo_ID success:(void (^) (NSString * response))success;
- (void)makeUser:(NSString *)user_ID unLikephotoWith:(NSString *)photo_useID :(NSString *)photo_ID success:(void (^) (NSString * response))success;

- (void)deleteFolderWithUserId:(NSString *)user_id folderId:(NSString *)folder_id success:(void (^) (NSString * response))success;
- (void)deletePhotosWithUserId:(NSString *)user_id	folderId:(NSString *)folder_id photoIds:(NSArray *)photo_ids success:(void (^) (NSString * response))success;
- (void)renameAlbumWithUserId:(NSString *)user_id folderId:(NSString *)folder_id newName:(NSString *)newName success:(void (^) (NSString * response))success;
- (void)createAlbumWithUserId:(NSString *)user_id  name:(NSString *)newName success:(void (^) (NSString * response))success;
#pragma Follwe_Action
- (void)destoryFollowing:(NSString *)following_Id userID:(NSString *)useId success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
- (void)friendshipsFollowing:(NSString *)following_Id userID:(NSString *)useId success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure;
@end
