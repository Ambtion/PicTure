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
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            NSLog(@"%@",[request responseString]);
            NSString * str = [NSString stringWithFormat:@"%@/user?access_token=%@",BASICURL_V1,[[[request responseString] JSONValue] objectForKey:@"access_token"]];
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[[request responseString] JSONValue]];
            ASIHTTPRequest * user_id = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
            [user_id startSynchronous];
            
            if ([user_id responseStatusCode]>= 200 && [user_id responseStatusCode] < 300 && [user_id responseString]) {
                [dic setObject:[[[user_id responseString] JSONValue] objectForKey:@"user_id"] forKey:@"user_id"];
                success(dic);
            }else{
                faiture([NSString stringWithFormat:@"user:%d,未知错误",[user_id responseStatusCode]]);
                NSLog(@"user: %@",[user_id responseString]);
            }
            
        }else{
            NSLog(@"oauth2: %@",[request responseString]);
            faiture([NSString stringWithFormat:@"oauth2:%d,未知错误",[request responseStatusCode]]);
        }
    }];
    [request setFailedBlock:^{
        faiture(@"连接失败");
    }];
    [request startAsynchronous];
}
+ (void)resigiterWithuseName:(NSString *)useName password:(NSString *)password nickName:(NSString *)nick sucessBlock:(void (^)(NSDictionary  * response))success failtureSucess:(void (^)(NSString * error))faiture
{
    NSLog(@" %s",__FUNCTION__);
    NSString * str = [NSString stringWithFormat:@"%@/register",BASICURL_V1];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:useName forKey:@"passport"];
    [request setPostValue:password forKey:@"password"];
    //    [request setPostValue:nick forKey:@"nickname"];
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        NSLog(@" %s, %@ : %d",__FUNCTION__,[request responseString],[request responseStatusCode]);
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
                    faiture(@"请确认密码长度为6-16位");//密码不符合要求
                    break;
                case 2:
                    faiture(@"通行证出错");
                    break;
                case 3:
                    faiture(@"帐户仅支持字母开头，4-16位，数字、字母、下划线组成,且必须有@");//账号不符合要求
                    break;
                case 4:
                    faiture(@"该账号已存在");//已有账号
                    break;
                default:
                    faiture(@"请求失败");
                    break;
            }
        }else{
            
            faiture(@"请求失败");
        }
    }];
    [request setFailedBlock:^{
        NSLog(@" %s, %@ : %d",__FUNCTION__,[request responseString],[request responseStatusCode]);
        faiture(@"请求失败");
    }];
    [request startAsynchronous];
}
@end
