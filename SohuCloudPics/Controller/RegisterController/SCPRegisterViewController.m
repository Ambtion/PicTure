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
    [_registerButton release];
    [_displayPasswordButton release];
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
    [_backgroundControl addTarget:self action:@selector(allTextFieldsResignFirstResponder:) forControlEvents:UIControlEventTouchDown];
    
	_usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(78, 128, 110, 22) ];
    _usernameTextField.font = [UIFont systemFontOfSize:15];
    _usernameTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.placeholder = @"通行证";
    _usernameTextField.delegate = self;
    _usernameTextField.backgroundColor = [UIColor clearColor];
    _usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
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
    _passwordTextField.backgroundColor = [UIColor clearColor];
    
    _displayPasswordButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _displayPasswordButton.frame = CGRectMake(35, 258, 100, 22);
    _displayPasswordButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_displayPasswordButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    [_displayPasswordButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [_displayPasswordButton setTitle:@"显示密码" forState:UIControlStateNormal];
    [_displayPasswordButton setBackgroundImage:_noChecked forState:UIControlStateNormal];
    [_displayPasswordButton setBackgroundImage:_checked forState:UIControlStateSelected];
    [_displayPasswordButton setBackgroundImage:_checked forState:UIControlStateHighlighted];
    [_displayPasswordButton setBackgroundImage:_checked forState:UIControlStateHighlighted | UIControlStateSelected];
    [_displayPasswordButton addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _dealPassButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _dealPassButton.frame = CGRectMake(35, 291, 22, 22);
    _dealPassButton.selected = YES;
    [_dealPassButton setBackgroundImage:_noChecked forState:UIControlStateNormal];
    [_dealPassButton setBackgroundImage:_checked forState:UIControlStateSelected];
    [_dealPassButton setBackgroundImage:_checked forState:UIControlStateHighlighted];
    [_dealPassButton setBackgroundImage:_checked forState:UIControlStateHighlighted | UIControlStateSelected];
    [_dealPassButton addTarget:self action:@selector(agreeDeal:) forControlEvents:UIControlEventTouchUpInside];
    _dealPassButton.backgroundColor = [UIColor clearColor];
    
    _readDealButton  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _readDealButton.frame = CGRectMake(57, 291, 230, 22);
    _readDealButton.backgroundColor = [UIColor clearColor];
    _readDealButton.titleLabel.textAlignment = UITextAlignmentLeft;
    [_readDealButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    _readDealButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_readDealButton setTitle:@"同意搜狐云图《用户注册协议》" forState:UIControlStateNormal];
    [_registerButton setTitle:@"同意搜狐云图《用户注册协议》" forState:UIControlStateHighlighted];
    [_readDealButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_readDealButton addTarget:self action:@selector(readDeal:) forControlEvents:UIControlEventTouchUpInside];
    
    _registerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
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
#pragma mark - TextFiledDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text  = [textField.text lowercaseString];
}
- (void)agreeDeal:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [_registerButton setUserInteractionEnabled:YES];
        [_registerButton setAlpha:1.0];
    }else{
        [_registerButton setAlpha:0.3];
        [_registerButton setUserInteractionEnabled:NO];
    }
}
- (void)readDeal:(UIButton *)button
{
    [self.navigationController pushViewController:[[[SCPReadDealController alloc] init] autorelease] animated:YES];
}
- (void)backButtonClick:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)allTextFieldsResignFirstResponder:(id)sender
{
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)usernameDidEndOnExit
{
    [_passwordTextField becomeFirstResponder];
}

- (void)checkBoxClicked
{
    [self allTextFieldsResignFirstResponder:nil];
    _displayPasswordButton.selected = !_displayPasswordButton.selected;
    _passwordTextField.secureTextEntry = !_displayPasswordButton.selected;
    
}
- (void)doRegister
{
    if (!_usernameTextField.text || [_usernameTextField.text isEqualToString:@""]) {
        SCPAlertView_LoginTip * alterview = [[[SCPAlertView_LoginTip alloc] initWithTitle:@"您还没有填写用户名" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
        [alterview show];
        return;
    }
    if (!_passwordTextField.text || [_passwordTextField.text isEqualToString:@""]) {
        SCPAlertView_LoginTip * alterview = [[[SCPAlertView_LoginTip alloc] initWithTitle:@"您还没有填写密码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
        [alterview show];
        return;
    }
    [self allTextFieldsResignFirstResponder:nil];
    [self waitForMomentsWithTitle:@"注册中"];
    NSString * username = [NSString stringWithFormat:@"%@@sohu.com",_usernameTextField.text];
    NSString * password = [NSString stringWithFormat:@"%@",_passwordTextField.text];
    [AccountSystemRequset resigiterWithuseName:username password:password nickName:nil sucessBlock:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [AccountSystemRequset sohuLoginWithuseName:username password:password sucessBlock:^(NSDictionary * response) {
                [SCPLoginPridictive loginUserId:[NSString stringWithFormat:@"%@",[response objectForKey:@"user_id"]] withToken:[response objectForKey:@"access_token"]RefreshToken:[NSString stringWithFormat:@"%@",[response objectForKey:@"refresh_token"]]];
                [self backhome];
            } failtureSucess:^(NSString *error) {
                [self stopWait];
                SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [tip  show];
                [tip release];
            }];
        });
        
    } failtureSucess:^(NSString *error) {
        [self stopWait];
        SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [tip  show];
        [tip release];
    }];
}

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
- (void)backhome
{
    [self stopWait];
    SCPLoginViewController * vc = [[self.navigationController childViewControllers] objectAtIndex:0];
    if ([vc.delegate respondsToSelector:@selector(SCPLogin:doLogin:)])
                        [vc.delegate  SCPLogin:vc doLogin:nil];
    
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
