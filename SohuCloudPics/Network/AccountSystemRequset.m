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
#import "SCPLoginPridictive.h"

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
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSLog(@"%s, %@",__FUNCTION__,[request responseString]);
            NSString * str = [NSString stringWithFormat:@"%@/user?access_token=%@",BASICURL_V1,[[[request responseString] JSONValue] objectForKey:@"access_token"]];
            NSLog(@"%@",str);
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[[request responseString] JSONValue]];
            ASIHTTPRequest * user_id = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
            [user_id startSynchronous];
            if ([user_id responseStatusCode]>= 200 && [user_id responseStatusCode] < 300 && [user_id responseString]) {
                [dic setObject:[[[user_id responseString] JSONValue] objectForKey:@"user_id"] forKey:@"user_id"];
                NSLog(@"user_dic::%@",dic);
                success(dic);
            }else{
                faiture(@"当前网络不给力，请稍后重试");
            }
        }else if([request responseStatusCode] == 403){
            faiture(@"您的用户名与密码不匹配");
        }else{
            faiture(@"当前网络不给力，请稍后重试");
        }
    }];
    [request setFailedBlock:^{
        faiture(@"当前网络不给力，请稍后重试");
    }];
    [request startAsynchronous];
}
+ (void)resigiterWithuseName:(NSString *)useName password:(NSString *)password nickName:(NSString *)nick sucessBlock:(void (^)(NSDictionary  * response))success failtureSucess:(void (^)(NSString * error))faiture
{
    NSString * str = [NSString stringWithFormat:@"%@/register",BASICURL_V1];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:useName forKey:@"passport"];
    [request setPostValue:password forKey:@"password"];
    [request setTimeOutSeconds:5.f];
    NSLog(@"useName:%@",useName);
    NSLog(@"password::%@",password);
    [request setCompletionBlock:^{
        NSLog(@"%@",[request responseString]);
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 ) {
            success(nil);
        }else if([request responseStatusCode] == 403){
            NSDictionary * dic = [[request responseString] JSONValue];
            NSInteger code = [[dic objectForKey:@"code"] intValue];
            switch (code) {
                case 0:
                    success(dic);
                    break;
                case 1:
                    faiture(@"您的密码格式不正确");//密码不符合要求
                    break;
                case 2:
                    faiture(@"通行证出错");
                    break;
                case 3:
                    faiture(@"您的用户名格式不正确");//账号不符合要求
                    break;
                case 4:
                    faiture(@"该用户名已被注册");//已有账号
                    break;
                default:
                    faiture(@"当前网络不给力，请稍后重试");
                    break;
            }
        }else{
            faiture(@"当前网络不给力，请稍后重试");
        }
    }];
    [request setFailedBlock:^{
        faiture(@"当前网络不给力，请稍后重试");
    }];
    [request startAsynchronous];
}
+ (void)refreshToken
{
    if (![SCPLoginPridictive isLogin]) return;
//    NSString * str = [NSString stringWithFormat:@"%@/oauth2/access_token?grant_type=refresh_token",BASICURL_V1];
//    client_id=355d0ee5-d1dc-3cd3-bdc6-76d729f61655&client_secret=47ae8860-2f8d-36c3-be99-3ebba8f1e7e7&refresh_token=4639f5b2-02b6-37ab-8bc3-a938d6eb40dd" http://10.10.79.134/oauth2/access_token?grant_type=refresh_token
    
}
@end
