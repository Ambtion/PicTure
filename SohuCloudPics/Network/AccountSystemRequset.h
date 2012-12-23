//
//  AccountSystem.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-22.
//
//


#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface AccountSystemRequset : NSObject

+ (void)sohuLoginWithuseName:(NSString *)useName password:(NSString *)password sucessBlock:(void (^)(NSDictionary  * response))success failtureSucess:(void (^)(NSString * error))faiture;

@end
