//
//  AccountSystem.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-22.
//
//

#import "AccountSystemRequset.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

#define CLIENT_KEY @"J4kUXVJZzF_LoIBaRsSGmyIzvn3qTIFU"
#define CLIENT_SECRET @"SD9n6c92i8yOo1SNZs6brym2DdAQqLHe"

@implementation AccountSystemRequset
+ (void)sohuLoginWithuseName:(NSString *)useName password:(NSString *)password sucessBlock:(void (^)(NSDictionary  * response))success failtureSucess:(void (^)(NSString * error))faiture
{
    
    NSString * url_s = @"http://61.135.181.37:8888/api/v1/login";
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url_s]];
    [request setPostValue:useName forKey:@"passport"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:CLIENT_KEY forKey:@"client_key"];
    [request setPostValue:CLIENT_SECRET forKey:@"client_secret"];
    [request setCompletionBlock:^{
        NSLog(@"sucess StatusCode : %d",[request responseStatusCode]);
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
                success([[request responseString] JSONValue]);
        }else if ([request responseStatusCode] == 403) {
            faiture(@"账号或密码不正确");
        }else{
            faiture([NSString stringWithFormat:@"%d,未知错误",[request responseStatusCode]]);
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"fail StatusCode : %d",[request responseStatusCode]);
        faiture(@"连接失败");
        NSLog(@"MMMMMMMMMMMM %s %@, %d",__FUNCTION__, [request error],[request responseStatusCode]);
    }];
    [request startAsynchronous];
}
@end
