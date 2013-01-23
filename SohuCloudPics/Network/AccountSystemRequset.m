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
#import "SCPAlert_CustomeView.h"

#define CLIENT_ID @"355d0ee5-d1dc-3cd3-bdc6-76d729f61655"

@implementation AccountSystemRequset
+ (void)sohuLoginWithuseName:(NSString *)useName password:(NSString *)password sucessBlock:(void (^)(NSDictionary  * response))success failtureSucess:(void (^)(NSString * error))faiture
{
    
    NSString * url_s = [NSString stringWithFormat:@"%@/oauth2/access_token",BASICURL];
    
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url_s]];
    [request setPostValue:useName forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:@"password" forKey:@"grant_type"];
    [request setPostValue:CLIENT_ID forKey:@"client_id"];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setCompletionBlock:^{
//        NSLog(@"%@ %d",[request responseString],[request responseStatusCode]);
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSString * str = [NSString stringWithFormat:@"%@/api/v1/user?access_token=%@",BASICURL,[[[request responseString] JSONValue] objectForKey:@"access_token"]];
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[[request responseString] JSONValue]];
            ASIHTTPRequest * user_id = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
            [user_id startSynchronous];
            if ([user_id responseStatusCode]>= 200 && [user_id responseStatusCode] < 300 && [user_id responseString]) {
                [dic setObject:[[[user_id responseString] JSONValue] objectForKey:@"user_id"] forKey:@"user_id"];
//                NSLog(@"user_dic::%@",dic);
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
//        NSLog(@"Failture::%@ %d",[request responseString],[request responseStatusCode]);
        faiture(@"当前网络不给力，请稍后重试");
    }];
    [request startAsynchronous];
}
+ (void)resigiterWithuseName:(NSString *)useName password:(NSString *)password nickName:(NSString *)nick sucessBlock:(void (^)(NSDictionary  * response))success failtureSucess:(void (^)(NSString * error))faiture
{
    NSString * str = [NSString stringWithFormat:@"%@/api/v1/register",BASICURL];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:useName forKey:@"passport"];
    [request setPostValue:password forKey:@"password"];
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
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
                    faiture(@"您的用户名格式不正确");
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
@end
