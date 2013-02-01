//
//  SCPPerfrencdStoreManager.m
//  SohuCloudPics
//
//  Created by sohu on 13-2-1.
//
//

#import "SCPPerfrenceStoreManager.h"
#import "SCPLoginPridictive.h"

#define HOMEBACKGROUND  @"__HOMEBACKGROUND__"
#define ISUPLOADJPEGIMAGE @"__ISUPLOADJPEGIMAGE__"
#define ISSHOWINGGRIDVIEW @"__ISSHOWINGGRIDVIEW__"

@implementation SCPPerfrenceStoreManager

+ (NSDictionary *)valueForUserinfo
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[SCPLoginPridictive currentUserId]];
}

+ (id)valueForKey:(NSString *)key inUserinfo:(NSDictionary *)userinfo
{
    return [userinfo objectForKey:key];
}

+ (void)userDefoultStoreValue:(id)value forKey:(id)key
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userinfo = [NSMutableDictionary dictionaryWithDictionary:[self valueForUserinfo]];
    if (!userinfo) userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [userinfo setValue:value forKey:key];
    [userDefault setObject:userinfo forKey:[SCPLoginPridictive currentUserId]];
    [userDefault synchronize];
}

+ (NSString *)homeBackGroundImageName
{
    NSDictionary * userinfo = [self valueForUserinfo];
    return [self valueForKey:HOMEBACKGROUND inUserinfo:userinfo];
}

+ (void)resetHomeBackGroudImageName:(NSString *)newName
{
    [self userDefoultStoreValue:newName forKey:HOMEBACKGROUND];
}

+ (NSNumber *)isUploadJPEGImage
{
    NSDictionary * userinfo = [self valueForUserinfo];
    return [self valueForKey:ISUPLOADJPEGIMAGE inUserinfo:userinfo];
}
+ (void)setIsUploadJPEGImage:(BOOL)ture
{
    [self userDefoultStoreValue:[NSNumber numberWithBool:ture] forKey:HOMEBACKGROUND];
}

+ (NSNumber *)isShowingGridView
{
    NSDictionary * userinfo = [self valueForUserinfo];
    return [self valueForKey:ISSHOWINGGRIDVIEW inUserinfo:userinfo];
}

+ (void)setIsShowingGridView:(BOOL)ture
{
    [self userDefoultStoreValue:[NSNumber numberWithBool:ture] forKey:ISSHOWINGGRIDVIEW];
}
@end
