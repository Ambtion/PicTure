//
//  SettingManager.m
//  ISohu
//
//  Created by mysohu on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingManager.h"

@implementation SettingManager

+(void)saveOAuthInfo:(NSString *)accessKey accessSecret:(NSString *)accessSecret userId:(NSString *)userId{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessKey forKey:oauth_token_key];
    [defaults setObject:accessSecret forKey:oauth_secret_key];
    [defaults setObject:userId forKey:oauth_id_key];
}
+(void)loadOAuthInfo:(NSMutableString *)accessKey accessSecret:(NSMutableString *)accessSecret userId:(NSMutableString *)userId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:oauth_token_key];
    NSString *secret = [defaults objectForKey:oauth_secret_key];
    NSString *uid = [defaults objectForKey:oauth_id_key];
    
    [accessKey appendString:key];
    [accessSecret appendString:secret];
    [userId appendString:uid];
}
+(void)removeOAuthInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:oauth_token_key];
    [defaults removeObjectForKey:oauth_secret_key];
    [defaults removeObjectForKey:oauth_id_key];
}
+(BOOL)hasOAuthInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"hasOAuthInfo");
    if([defaults objectForKey:oauth_token_key] == nil)
        return false;
    if([defaults objectForKey:oauth_secret_key] == nil)
        return false;
    if([defaults objectForKey:oauth_id_key] == nil)
        return false;
    
    NSLog(@"hasOAuthInfo");
    return true;
}

/////////////////////////////////////
// functions used by post draft start
+ (NSString *)encodeString1:(NSString *)string1 andString2:(NSString *)string2 {
    return [NSString stringWithFormat:@"%d%@%@%d%@%@", string1.length, SEPERATOR, string1, string2.length, SEPERATOR, string2];
}

+ (BOOL)decodeString:(NSString *)string toString1:(NSMutableString *)string1 andString2:(NSMutableString *)string2 {
    if (string == nil || string1 == nil || string2 == nil)
        return NO;
    if (string.length == 0 || string1.length != 0 || string2.length != 0)
        return NO;
    
    NSRange lengthRange;
    NSRange contentRange;
    
    NSRange searchRange;
    searchRange.location = 0;
    searchRange.length = 10 < string.length ? 10 : string.length;
    
    NSRange colonRange = [string rangeOfString:SEPERATOR options:0 range:searchRange];
    lengthRange.location = 0;
    lengthRange.length = colonRange.location;
    contentRange.location = colonRange.location + 1;
    contentRange.length = [[string substringWithRange:lengthRange] integerValue];
    [string1 appendString:[string substringWithRange:contentRange]];
    
    searchRange.location = contentRange.location + contentRange.length;
    searchRange.length = 10 < string.length - searchRange.location ? 10 : string.length - searchRange.location;
    colonRange = [string rangeOfString:SEPERATOR options:0 range:searchRange];
    contentRange.location = colonRange.location + 1;
    [string2 appendString:[string substringFromIndex:contentRange.location]];
    
    return YES;
}

+ (void)saveMicroblog:(NSString *)content withImage:(NSString *)path {
    [[NSUserDefaults standardUserDefaults] setObject:[SettingManager encodeString1:content andString2:path] forKey:DRAFT_MICROBLOG_KEY];
}

+ (void)saveBlog:(NSString *)content withTitle:(NSString *)title {
    [[NSUserDefaults standardUserDefaults] setObject:[SettingManager encodeString1:content andString2:title] forKey:DRAFT_BLOG_KEY];
}

+ (void)savePhoto:(NSString *)path withDescript:(NSString *)desc {
    [[NSUserDefaults standardUserDefaults] setObject:[SettingManager encodeString1:path andString2:desc] forKey:DRAFT_PHOTO_KEY];
}

+ (BOOL)loadMicroblogContentTo:(NSMutableString *)content andPathTo:(NSMutableString *)path {
    return [SettingManager decodeString:[[NSUserDefaults standardUserDefaults] objectForKey:DRAFT_MICROBLOG_KEY] toString1:content andString2:path];
}

+ (BOOL)loadBlogTitleTo:(NSMutableString *)title andContentTo:(NSMutableString *)content {
    return [SettingManager decodeString:[[NSUserDefaults standardUserDefaults] objectForKey:DRAFT_BLOG_KEY] toString1:content andString2:title];
}

+ (BOOL)loadPhotoPathTo:(NSMutableString *)path andDescritionTo:(NSMutableString *)desc {
    return [SettingManager decodeString:[[NSUserDefaults standardUserDefaults] objectForKey:DRAFT_PHOTO_KEY] toString1:path andString2:desc];
}

+ (BOOL)hasMicroblogDraft {
    return [[NSUserDefaults standardUserDefaults] objectForKey:DRAFT_MICROBLOG_KEY] != nil;
}

+ (BOOL)hasBlogDraft {
    return [[NSUserDefaults standardUserDefaults] objectForKey:DRAFT_BLOG_KEY] != nil;
}

+ (BOOL)hasPhotoDraft {
    return [[NSUserDefaults standardUserDefaults] objectForKey:DRAFT_PHOTO_KEY] != nil;
}

+ (void)removeMicroblogDraft {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DRAFT_MICROBLOG_KEY];
}

+ (void)removeBlogDraft {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DRAFT_BLOG_KEY];
}

+ (void)removePhotoDraft {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DRAFT_PHOTO_KEY];
}

+ (void)removeAllDraft {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DRAFT_MICROBLOG_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DRAFT_BLOG_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DRAFT_PHOTO_KEY];
}
// functions used by post draft end
/////////////////////////////////////

@end
