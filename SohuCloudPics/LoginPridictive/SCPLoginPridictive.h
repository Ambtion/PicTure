//
//  SCPLoginPridictive.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPStoreLibaray.h"

@interface SCPLoginPridictive : NSObject

+ (BOOL)isLogin;

+ (void)loginUserId:(NSString *)uid withToken:(NSString *)token RefreshToken:(NSString *)refreshToken;

+ (void)refreshToken:(NSString *)token RefreshToken:(NSString *)refreshToken;

+ (void)logout;

+ (NSString *)currentUserId;

+ (NSString *)currentToken;

+ (NSString *)refreshToken;

//+ (void)storeData:(NSString *)data forKey:(NSString *)username;
//
//+ (NSString*)dataForKey:(NSString *)username;
//
//+ (void)removeDataForKey:(NSString *)username;

@end
