//
//  SCPLoginViewController.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPLoginViewController.h"

#import "SCPMenuNavigationController.h"
#import "SCPMainTabController.h"
#import "SCPRegisterViewController.h"
#import "SCPLoginPridictive.h"

#define EMAIL_ARRAY ([NSArray arrayWithObjects:@"126.com", @"163.com", @"qq.com", @"sohu.com", @"sina.com.cn", @"sina.com", @"yahoo.com", @"yahoo.com.cn", @"yahoo.cn", nil])



@implementation SCPLoginViewController

@synthesize delegate = _delegate;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize backgroundControl = _backgroundControl;
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize registerButton = _registerButton;
@synthesize loginButton = _loginButton;

- (void)dealloc
{   
    [_backgroundImageView release];
    [_backgroundControl release];
    [_usernameTextField release];
    [_passwordTextField release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithRed:244.0f/255.f green:244.0f/255.f blue:244.0f/255.f alpha:1];
    CGRect frame = CGRectMake(0, 0, 320, 480);
    UIScrollView *view = [[[UIScrollView alloc] initWithFrame:frame] autorelease];
    view.bounces = NO;
    view.contentSize = frame.size;
    [self.view addSubview:view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addsubViews];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)addsubViews
{
    CGRect frame = CGRectMake(0, 0, 320, 480);
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    _backgroundImageView.image = [UIImage imageNamed:@"login_bg.png"];
    
    _backgroundControl = [[UIControl alloc] initWithFrame:frame];
    [_backgroundControl addTarget:self action:@selector(allTextFieldsResignFirstResponder) forControlEvents:UIControlEventTouchDown];
    

    _usernameTextField = [[EmailTextField alloc] initWithFrame:CGRectMake(79, 131, 200, 22) dropDownListFrame:CGRectMake(69, 160, 214, 200) domainsArray:EMAIL_ARRAY];
    _usernameTextField.font = [UIFont systemFontOfSize:15];
    _usernameTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.placeholder = @"通行证/手机号";
    [_usernameTextField addTarget:self action:@selector(usernameDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(79, 189, 200, 22)];
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"密码";
    [_passwordTextField addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame = CGRectMake(35, 239, 110, 35);
    [_registerButton setBackgroundImage:[UIImage imageNamed:@"login_btn_normal"] forState:UIControlStateNormal];
    [_registerButton setBackgroundImage:[UIImage imageNamed:@"login_btn_press"] forState:UIControlStateHighlighted];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = CGRectMake(175, 239, 110, 35);
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_normal"] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_press"] forState:UIControlStateHighlighted];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_backgroundImageView];
    [self.view addSubview:_backgroundControl];
    [self.view addSubview:_usernameTextField];
    [self.view addSubview:_passwordTextField];
    [self.view addSubview:_registerButton];
    [self.view addSubview:_loginButton];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 8, 28, 28);
    [backButton setImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.backgroundImageView = nil;
    self.backgroundControl = nil;
    self.usernameTextField = nil;
    self.passwordTextField = nil;
    self.registerButton = nil;
    self.loginButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];

    if ([self.navigationController class] == [SCPMenuNavigationController class]) {
        [((SCPMenuNavigationController *) self.navigationController) setDisableMenu:YES];
    }
}

- (void)allTextFieldsResignFirstResponder
{
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

#pragma mark -
#pragma mark buttonClick
- (void)usernameDidEndOnExit
{
    [_passwordTextField becomeFirstResponder];
}

- (void)loginButtonClicked:(UIButton*)button
{
    //after login
    if ([button isEqual:_loginButton]) {
        
        [SCPLoginPridictive loginUserId:@"123" withToken:@"123"];
        
        if ([_delegate respondsToSelector:@selector(SCPLogin:doLogin:)]) {
            [_delegate SCPLogin:self doLogin:button];
        }
    }else {
        if ([_delegate respondsToSelector:@selector(SCPLogin:cancelLogin:)]) {
            [_delegate SCPLogin:self cancelLogin:button];
        }
    }
    
}

- (void)registerButtonClicked:(UIButton *)button
{
    
    NSLog(@"registerButtonClicked start");
    SCPRegisterViewController *reg = [[[SCPRegisterViewController alloc] init] autorelease];
    [self.navigationController pushViewController:reg animated:YES];
    NSLog(@"registerButtonClicked end");

}

- (void)doLogin
{
    // TODO
}

#pragma mark keyboard
- (void)keyboardWillShow:(NSNotification *)notification
{
    UIScrollView *view = (UIScrollView *) self.view;
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize size = view.contentSize;
    size.height += keyboardSize.height;
    view.contentSize = size;
    
    CGPoint point = view.contentOffset;
    point.y += 120;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    view.contentOffset = point;
    [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIScrollView *view = (UIScrollView *) self.view;
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGPoint point = view.contentOffset;
    point.y -= 120;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    view.contentOffset = point;
    [UIView commitAnimations];
    
    CGSize size = view.contentSize;
    size.height -= keyboardSize.height;
    view.contentSize = size;
}

@end
