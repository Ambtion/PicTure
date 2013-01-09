//
//  SCPAuthorizeViewController.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-8.
//
//

#import "SCPAuthorizeViewController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

#define BASICURL_V1 @"http://10.10.68.104:8888/api/v1"
#define CLIENT_ID @"355d0ee5-d1dc-3cd3-bdc6-76d729f61655"

//#define WEIBO_CLIENT_ID @"992243007"
//#define QQ_CLIENT_ID @"100319476"
//#define RENREN_CLIENT_ID @"ed8838c335d146319b6612a3026190ae"

static NSString * url_string = nil;
static NSString * title = nil;

static NSString * provider = nil;
 
@implementation SCPAuthorizeViewController
@synthesize delegate;

- (id)initWithMode:(LoginModel)loginMode controller:(id)Acontroller
{
    self = [super init];
    if (self) {
        switch (loginMode) {
            case 0: //weibo
                url_string = @"https://api.weibo.com/oauth2/authorize?display=mobile&response_type=code&redirect_uri=http://pp.sohu.com/users/auth/weibo/callback/aHR0cDovL3BwLnNvaHUuY29tLw!!&client_id=992243007";
                title = @"微博登陆";
                provider = @"weibo";
                break;
            case 1: //qq
                url_string = @"https://graph.qq.com/oauth2.0/authorize?scope=get_user_info&response_type=code&redirect_uri=http://pp.sohu.com/users/auth/qq/callback/aHR0cDovL3BwLnNvaHUuY29tLz91c2VySWQ9NDEz&client_id=100319476";
                title = @"QQ登陆";
                provider = @"qq";
                break;
            case 2: //renren
                url_string = @"https://graph.renren.com/oauth/authorize?response_type=code&redirect_uri=http://pp.sohu.com/users/auth/renren/callback&display=popup&client_id=ed8838c335d146319b6612a3026190ae";
                title = @"人人登陆";
                provider = @"renren";
                
                break;
            default:
                break;
        }
        controller = Acontroller;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * cancelLogin = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelLogin:)] autorelease];
    self.navigationItem.leftBarButtonItem = cancelLogin;
    self.title = title;
    [self OAuth2authorize];
}
- (void)OAuth2authorize
{
    UIWebView * webView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url_string] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:20]];
    webView.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
    webView.scrollView.bounces = NO;
    webView.delegate = self;
    [self.view addSubview:webView];
}
- (void)cancelLogin:(id)sender
{
    [controller dismissModalViewControllerAnimated:YES];
}
- (void)loginWithCode
{
    NSString * url_s = @"http://10.10.79.134/oauth2/access_token";
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url_s]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setPostValue:@"third_party_code" forKey:@"grant_type"];
    [request setPostValue:CLIENT_ID forKey:@"client_id"];
    [request setPostValue:provider forKey:@"provider"];
    [request setPostValue:code forKey:@"code"];
    [request setCompletionBlock:^{
        
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 && [request responseString]) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[[request responseString] JSONValue]];
            NSString * str = [NSString stringWithFormat:@"%@/user?access_token=%@",BASICURL_V1,[[[request responseString] JSONValue] objectForKey:@"access_token"]];
            ASIHTTPRequest * user_id = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
            [user_id startSynchronous];
            if ([user_id responseStatusCode]>= 200 && [user_id responseStatusCode] <= 300 && [user_id responseString]) {
                [dic setObject:[[[user_id responseString] JSONValue] objectForKey:@"user_id"] forKey:@"user_id"];
                if ([delegate respondsToSelector:@selector(loginSucessInfo:)])
                    [delegate performSelector:@selector(loginSucessInfo:) withObject:dic];
            }else{
                if ([delegate respondsToSelector:@selector(loginFailture:)])
                    [delegate performSelector:@selector(loginFailture:) withObject:[NSString stringWithFormat:@"%d,未知错误",[user_id responseStatusCode]]];
            }
        }else if ([request responseStatusCode] == 403) {
            if ([delegate respondsToSelector:@selector(loginFailture:)]) {
                [delegate performSelector:@selector(loginFailture:) withObject:@"账号或密码不正确"];
            }
        }else{
            if ([delegate respondsToSelector:@selector(loginFailture:)]) {
                [delegate performSelector:@selector(loginFailture:) withObject:[NSString stringWithFormat:@"%d,未知错误",[request responseStatusCode]]];
            }
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"fail StatusCode : %d",[request responseStatusCode]);
        if ([delegate respondsToSelector:@selector(loginFailture:)]) {
            [delegate performSelector:@selector(loginFailture:) withObject:@"连接失败"];
        }
    }];
    [request startAsynchronous];
    
}
#pragma mark webViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * str = [request.URL absoluteString];
    if ([str rangeOfString:@"http://pp.sohu.com"].length && ![str rangeOfString:@"client_id"].length) {
        NSRange rang = [str rangeOfString:@"code="];
        if (rang.length) {
            code = [[NSString alloc] initWithString:[str substringFromIndex:rang.length + rang.location]];
            [webView stopLoading];
            NSLog(@"%@, &&&:%@",str, code);
            [self loginWithCode];
        }
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self waitForMomentsWithTitle:@"加载中..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self stopWait];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self stopWait];
}
#pragma alertView
-(void)waitForMomentsWithTitle:(NSString*)str
{
    _alterView = [[SCPAlert_WaitView alloc] initWithImage:[UIImage imageNamed:@"pop_alert.png"] text:str withView:self.view];
    [_alterView show];
}

-(void)stopWait
{
    if(_alterView){
        [_alterView dismissWithClickedButtonIndex:0 animated:YES];
        [_alterView release],_alterView = nil;
    }
}
@end
