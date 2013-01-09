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

#define CLIENT_ID @"355d0ee5-d1dc-3cd3-bdc6-76d729f61655"

@implementation AccountSystemRequset
+ (void)sohuLoginWithuseName:(NSString *)useName password:(NSString *)password sucessBlock:(void (^)(NSDictionary  * response))success failtureSucess:(void (^)(NSString * error))faiture
{
    NSString * url_s = @"http://10.10.79.134/oauth2/access_token";
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url_s]];
    [request setPostValue:useName forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:@"password" forKey:@"grant_type"];
    [request setPostValue:CLIENT_ID forKey:@"client_id"];
    [request addRequestHeader:@"accept" value:@"application/json"];
    
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
            NSString * str = [NSString stringWithFormat:@"%@/user?access_token=%@",BASICURL_V1,[[[request responseString] JSONValue] objectForKey:@"access_token"]];
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[[request responseString] JSONValue]];
            ASIHTTPRequest * user_id = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
            [user_id startSynchronous];
            if ([user_id responseStatusCode]>= 200 && [user_id responseStatusCode] <= 300 && [user_id responseString]) {
                [dic setObject:[[[user_id responseString] JSONValue] objectForKey:@"user_id"] forKey:@"user_id"];
                success(dic);
            }else{
                faiture([NSString stringWithFormat:@"%d,未知错误",[user_id responseStatusCode]]);
            }
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
+ (void)resigiterWithuseName:(NSString *)useName password:(NSString *)password nickName:(NSString *)nick sucessBlock:(void (^)(NSDictionary  * response))success failtureSucess:(void (^)(NSString * error))faiture
{
    
    NSString * str = [NSString stringWithFormat:@"%@/register",BASICURL_V1];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:useName forKey:@"passport"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:nick forKey:@"nickname"];
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        
        NSLog(@"sucess:%@ %d",[request responseString],[request responseStatusCode]);
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 &&[[request responseString] JSONValue]) {
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"error:%@",[request responseString]);
    }];
    [request startAsynchronous];
}
@end
