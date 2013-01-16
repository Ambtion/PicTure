//
//  SCPCacheManager.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-16.
//
//

#import "SCPCacheManager.h"

@implementation SCPCacheManager
+ (void)removeCacheOfImage
{
    NSFileManager * manager  = [NSFileManager defaultManager];
    NSString * str = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];
    NSError * error = nil;
    [manager removeItemAtPath:str error:&error];
    if (error) NSLog(@"error::%@",error);
}
+ (void)removeCacheAlluserInfo:(BOOL)isRemove
{
    
    NSDictionary * dic = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleId = [dic  objectForKey: @"CFBundleIdentifier"];
    NSUserDefaults *appUserDefaults = [[[NSUserDefaults alloc] init] autorelease];
    NSDictionary * cacheDic = [appUserDefaults persistentDomainForName: bundleId];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * _use_id = nil;
    NSString * _use_token = nil;
    NSString * _refresh_token = nil;
    NSNumber * GuideViewShowed = nil;
    NSNumber * FunctionShowed = nil;
    NSNumber * JPEG = nil;
    //read
    if ([defaults objectForKey:USER_ID])
        _use_id = [NSString stringWithFormat:@"%@",[defaults objectForKey:USER_ID]];
    if ([defaults objectForKey:USER_TOKEN])
        _use_token = [NSString stringWithFormat:@"%@",[defaults objectForKey:USER_TOKEN]];
    if ([defaults objectForKey:REFRESH_TOKEN])
        _refresh_token = [NSString stringWithFormat:@"%@",[defaults objectForKey:REFRESH_TOKEN]];
    if ([defaults objectForKey:@"GuideViewShowed"])
        GuideViewShowed = [[[defaults objectForKey:@"GuideViewShowed"] copy] autorelease];
    if ([defaults objectForKey:@"FunctionShowed"])
        FunctionShowed = [[[defaults objectForKey:@"FunctionShowed"] copy] autorelease];
    if ([defaults objectForKey:@"JPEG"]) {
        JPEG = [[[defaults objectForKey:@"JPEG"] copy] autorelease];
    }
    //remove
    for (NSString * str in [cacheDic allKeys])
        [defaults removeObjectForKey:str];
    if (_use_id)
        [defaults setObject:_use_id forKey:USER_ID];
    if (_use_token)
        [defaults setObject:_use_token forKey:USER_TOKEN];
    if (_refresh_token)
        [defaults setObject:_refresh_token forKey:REFRESH_TOKEN];
    if (GuideViewShowed)
        [defaults setObject:GuideViewShowed forKey:@"GuideViewShowed"];
    if (FunctionShowed)
        [defaults setObject:FunctionShowed forKey:@"FunctionShowed"];
    if (!isRemove){
        if (JPEG)
            [defaults setObject:JPEG forKey:@"JPEG"];
    }
    [defaults synchronize];
}

@end
