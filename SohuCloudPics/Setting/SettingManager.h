//
//  SettingManager.h
//  ISohu
//
//  Created by mysohu on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *oauth_token_key = @"accessKey";
static NSString *oauth_secret_key = @"accessSecret";
static NSString *oauth_id_key = @"userId";

static NSString * const DRAFT_MICROBLOG_KEY = @"_dr_mb_key_";
static NSString * const DRAFT_BLOG_KEY = @"_dr_blg_key";
static NSString * const DRAFT_PHOTO_KEY = @"_dr_pht_key_";

static NSString * const SEPERATOR = @":";

@interface SettingManager : NSObject{

}

+(void)saveOAuthInfo:(NSString *)accessKey accessSecret:(NSString *)accessSecret userId:(NSString *)userId;
+(void)loadOAuthInfo:(NSMutableString *)accessKey accessSecret:(NSMutableString *)accessSecret userId:(NSMutableString *)userId;
+(void)removeOAuthInfo;
+(BOOL)hasOAuthInfo;

/////////////////////////////////////
// functions used by post draft start
+ (void)saveMicroblog:(NSString *)content withImage:(NSString *)path;
+ (void)saveBlog:(NSString *)content withTitle:(NSString *)title;
+ (void)savePhoto:(NSString *)path withDescript:(NSString *)desc;
+ (BOOL)loadMicroblogContentTo:(NSMutableString *)content andPathTo:(NSMutableString *)path;
+ (BOOL)loadBlogTitleTo:(NSMutableString *)title andContentTo:(NSMutableString *)content;
+ (BOOL)loadPhotoPathTo:(NSMutableString *)path andDescritionTo:(NSMutableString *)desc;
+ (BOOL)hasMicroblogDraft;
+ (BOOL)hasBlogDraft;
+ (BOOL)hasPhotoDraft;
+ (void)removeMicroblogDraft;
+ (void)removeBlogDraft;
+ (void)removePhotoDraft;
+ (void)removeAllDraft;
// functions used by post draft end
/////////////////////////////////////

@end
