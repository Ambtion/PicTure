//
//  AccountSystem.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-22.
//
//


#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#define BASICURL_V1 @"http://10.10.68.104:8888/api/v1"

@interface AccountSystemRequset : NSObject

+ (void)sohuLoginWithuseName:(NSString *)useName password:(NSString *)password sucessBlock:(void (^)(NSDictionary  * response))success failtureSucess:(void (^)(NSString * error))faiture;
+ (void)resigiterWithuseName:(NSString *)useName password:(NSString *)password nickName:(NSString *)nick sucessBlock:(void (^)(NSDictionary  * response))success failtureSucess:(void (^)(NSString * error))faiture;

@end
