//
//  SCPRegisterViewController.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPRegisterViewController.h"

#import "SCPMenuNavigationController.h"
#import "SCPLoginPridictive.h"

#import "AccountSystemRequset.h"
#import "SCPAlertView_LoginTip.h"
#import "SCPLoginViewController.h"
#import "SCPReadDealController.h"

#define EMAIL_ARRAY ([NSArray arrayWithObjects:@"126.com", @"163.com", @"qq.com", @"sohu.com", @"sina.com.cn", @"sina.com", @"yahoo.com", @"yahoo.com.cn", @"yahoo.cn", nil])

@implementation SCPRegisterViewController

@synthesize backgroundImageView = _backgroundImageView;
@synthesize backgroundControl = _backgroundControl;
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize displayPasswordButton = _displayPasswordButton;
@synthesize dealPassButton = _dealPassButton;
@synthesize readDealButton = _readDealButton;
@synthesize registerButton = _registerButton;

- (void)dealloc
{
    [_backgroundImageView release];
    [_backgroundControl release];
    [_usernameTextField release];
    [_passwordTextField release];
    [_dealPassButton release];
    [_readDealButton release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    UIScrollView *view = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    view.bounces = NO;
    view.contentSize = view.frame.size;
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addViews];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)addViews
{
    
    _checked = [[UIImage imageNamed:@"check_box_select.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 0)];
    _noChecked = [[UIImage imageNamed:@"check_box_no_select.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 0)];
    CGRect frame = self.view.bounds;
    _backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    _backgroundImageView.image = [UIImage imageNamed:@"signin_bg.png"];
    _backgroundControl = [[UIControl alloc] initWithFrame:frame];
    [_backgroundControl addTarget:self action:@selector(allTextFieldsResignFirstResponder) forControlEvents:UIControlEventTouchDown];

	_usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(78, 128, 150, 22) ];
    _usernameTextField.font = [UIFont systemFontOfSize:15];
    _usernameTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.placeholder = @"通行证/用户名";
    _usernameTextField.backgroundColor = [UIColor redColor];
    [_usernameTextField addTarget:self action:@selector(usernameDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(78, 195, 198, 22)];
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"密码";
    _passwordTextField.secureTextEntry = YES;
    [_passwordTextField addTarget:self action:@selector(passwordDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    _passwordTextField.backgroundColor = [UIColor redColor];

    
    _displayPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _displayPasswordButton.frame = CGRectMake(35, 258, 100, 22);
    _displayPasswordButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_displayPasswordButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    [_displayPasswordButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
    [_displayPasswordButton setTitle:@"显示密码" forState:UIControlStateNormal];
    [_displayPasswordButton setBackgroundImage:_noChecked forState:UIControlStateNormal];
    [_displayPasswordButton setBackgroundImage:_checked forState:UIControlStateSelected];
    [_displayPasswordButton setBackgroundImage:_checked forState:UIControlStateHighlighted];
    [_displayPasswordButton setBackgroundImage:_checked forState:UIControlStateHighlighted | UIControlStateSelected];
    [_displayPasswordButton addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    _dealPassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dealPassButton.frame = CGRectMake(35, 291, 22, 22);
    _dealPassButton.selected = YES;
    [_dealPassButton setBackgroundImage:_noChecked forState:UIControlStateNormal];
    [_dealPassButton setBackgroundImage:_checked forState:UIControlStateSelected];
    [_dealPassButton setBackgroundImage:_checked forState:UIControlStateHighlighted];
    [_dealPassButton setBackgroundImage:_checked forState:UIControlStateHighlighted | UIControlStateSelected];
    [_dealPassButton addTarget:self action:@selector(agreeDeal:) forControlEvents:UIControlEventTouchUpInside];
    _dealPassButton.backgroundColor = [UIColor clearColor];
    
    _readDealButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    _readDealButton.frame = CGRectMake(57, 291, 150, 22);
    [_readDealButton setTitle:@" 同意用户注册协议" forState:UIControlStateNormal];
    [_registerButton setTitle:@" 同意用户注册协议" forState:UIControlStateHighlighted];
    [_readDealButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    _readDealButton.backgroundColor = [UIColor clearColor];
    [_readDealButton addTarget:self action:@selector(readDeal:) forControlEvents:UIControlEventTouchUpInside];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame = CGRectMake(35, 332, 250, 35);
    [_registerButton setBackgroundImage:[UIImage imageNamed:@"signin_btn_normal"] forState:UIControlStateNormal];
    [_registerButton setBackgroundImage:[UIImage imageNamed:@"signin_btn_press"] forState:UIControlStateHighlighted];
    [_registerButton setTitle:@"完成注册" forState:UIControlStateNormal];
    [_registerButton setTitle:@"完成注册" forState:UIControlStateHighlighted];
    [_registerButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_registerButton addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:_backgroundImageView];
    [self.view addSubview:_backgroundControl];
    [self.view addSubview:_usernameTextField];
    [self.view addSubview:_passwordTextField];
    [self.view addSubview:_displayPasswordButton];
    [self.view addSubview:_dealPassButton];
    [self.view addSubview:_readDealButton];
    [self.view addSubview:_registerButton];
    
    UILabel * label = [[[UILabel alloc] initWithFrame:CGRectMake(200, 128, 100, 22)] autorelease];
    label.backgroundColor = [UIColor greenColor];
    label.text = @"@sohu.com";
    [self.view addSubview:label];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(5, 2, 35, 35);
    [backButton setImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIImageView * sohu2003 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sohu-2013.png"]] autorelease];
    CGRect rect = CGRectMake(0, 0, 320, 10);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    rect.origin.y = screenRect.size.height - 20;
    sohu2003.frame = rect;
    [self.view addSubview:sohu2003];
    
}
- (void)agreeDeal:(UIButton *)button
{
    button.selected = !button.selected;
}
- (void)readDeal:(UIButton *)button
{
    [self.navigationController pushViewController:[[[SCPReadDealController alloc] init] autorelease] animated:YES];
}
- (void)backButtonClick:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)allTextFieldsResignFirstResponder
{
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)usernameDidEndOnExit
{
    [_passwordTextField becomeFirstResponder];
}

- (void)passwordDidEndOnExit
{
    
}

- (void)checkBoxClicked
{
    [self allTextFieldsResignFirstResponder];
    _displayPasswordButton.selected = !_displayPasswordButton.selected;
    _passwordTextField.secureTextEntry = !_displayPasswordButton.selected;
    
}
- (void)dealButton
{
    
}
- (void)doRegister
{
    if (!_usernameTextField.text || [_usernameTextField.text isEqualToString:@""]) {
        SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:@"请输入用户名" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [tip  show];
        [tip release];
        return;
    }
    if (!_passwordTextField.text || [_passwordTextField.text isEqualToString:@""]) {
        SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:@"请输入密码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [tip  show];
        [tip release];
        return;
    }
    
    [self allTextFieldsResignFirstResponder];
    [AccountSystemRequset resigiterWithuseName:_usernameTextField.text password:_passwordTextField.text nickName:nil sucessBlock:^(NSDictionary *response) {
        [AccountSystemRequset sohuLoginWithuseName:_usernameTextField.text password:_passwordTextField.text sucessBlock:^(NSDictionary * response) {
            
            [SCPLoginPridictive loginUserId:[NSString stringWithFormat:@"%@",[response objectForKey:@"user_id"]] withToken:[response objectForKey:@"access_token"]];
            SCPLoginViewController * vc = [[self.navigationController childViewControllers] objectAtIndex:0];
            if ([vc.delegate respondsToSelector:@selector(SCPLogin:doLogin:)])
                [vc.delegate  SCPLogin:vc doLogin:nil];
            
        } failtureSucess:^(NSString *error) {
            SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [tip  show];
            [tip release];
        }];
        
    } failtureSucess:^(NSString *error) {
        SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [tip  show];
        [tip release];
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    UIScrollView * view = (UIScrollView *) self.view;
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize size = view.bounds.size;
    size.height += keyboardSize.height;
    view.contentSize = size;
    
    CGPoint point = view.contentOffset;
    point.y = 118;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    view.contentOffset = point;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIScrollView *view = (UIScrollView *) self.view;
    CGPoint point = view.contentOffset;
    point.y  =  0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    view.contentOffset = point;
    [UIView commitAnimations];
    
    CGSize size = view.bounds.size;
    view.contentSize = size;
}

@end
