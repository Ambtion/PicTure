//
//  SCPRegisterViewController.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPRegisterViewController.h"

#import "SCPMenuNavigationController.h"
#import "SCPFinishRegisterViewController.h"

#define EMAIL_ARRAY ([NSArray arrayWithObjects:@"126.com", @"163.com", @"qq.com", @"sohu.com", @"sina.com.cn", @"sina.com", @"yahoo.com", @"yahoo.com.cn", @"yahoo.cn", nil])



@implementation SCPRegisterViewController

@synthesize backgroundImageView = _backgroundImageView;
@synthesize backgroundControl = _backgroundControl;
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize nicknameTextField = _nicknameTextField;
@synthesize displayPasswordButton = _displayPasswordButton;
@synthesize registerButton = _registerButton;

- (void)dealloc
{
    [_backgroundImageView release];
    [_backgroundControl release];
    [_usernameTextField release];
    [_passwordTextField release];
    [_nicknameTextField release];
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
    
    UIScrollView *view = [[[UIScrollView alloc] initWithFrame:self.view.bounds] autorelease];
    view.bounces = NO;
    view.contentSize = view.frame.size;
    [self.view addSubview:view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _checked = [[UIImage imageNamed:@"check_box_select.png"] stretchableImageWithLeftCapWidth:44 topCapHeight:0];
    _noChecked = [[UIImage imageNamed:@"check_box_no_select.png"] stretchableImageWithLeftCapWidth:44 topCapHeight:0];

    CGRect frame = self.view.bounds;
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    _backgroundImageView.image = [UIImage imageNamed:@"signin_bg.png"];
    
    _backgroundControl = [[UIControl alloc] initWithFrame:frame];
    [_backgroundControl addTarget:self action:@selector(allTextFieldsResignFirstResponder) forControlEvents:UIControlEventTouchDown];
    
    _usernameTextField = [[EmailTextField alloc] initWithFrame:CGRectMake(79, 129, 200, 22) dropDownListFrame:CGRectMake(69, 158, 214, 200) domainsArray:EMAIL_ARRAY];
    _usernameTextField.font = [UIFont systemFontOfSize:15];
    _usernameTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.placeholder = @"通行证/手机号";
    [_usernameTextField addTarget:self action:@selector(usernameDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(79, 186, 200, 22)];
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _passwordTextField.returnKeyType = UIReturnKeyNext;
    _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"密码";
    _passwordTextField.secureTextEntry = YES;
    [_passwordTextField addTarget:self action:@selector(passwordDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(79, 243, 200, 22)];
    _nicknameTextField.font = [UIFont systemFontOfSize:15];
    _nicknameTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _nicknameTextField.returnKeyType = UIReturnKeyDone;
    _nicknameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _nicknameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _nicknameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _nicknameTextField.placeholder = @"名号";
    [_nicknameTextField addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _displayPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _displayPasswordButton.frame = CGRectMake(35, 291, 100, 22);
    _displayPasswordButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_displayPasswordButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    [_displayPasswordButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
    [_displayPasswordButton setTitle:@"显示密码" forState:UIControlStateNormal];
    [_displayPasswordButton setBackgroundImage:_noChecked forState:UIControlStateNormal];
    [_displayPasswordButton setBackgroundImage:_checked forState:UIControlStateSelected];
    [_displayPasswordButton setBackgroundImage:_checked forState:UIControlStateHighlighted];
    [_displayPasswordButton setBackgroundImage:_checked forState:UIControlStateHighlighted | UIControlStateSelected];
    [_displayPasswordButton addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame = CGRectMake(35, 332, 250, 35);
    [_registerButton setBackgroundImage:[UIImage imageNamed:@"signin_btn_normal"] forState:UIControlStateNormal];
    [_registerButton setBackgroundImage:[UIImage imageNamed:@"signin_btn_press"] forState:UIControlStateHighlighted];
    [_registerButton setTitle:@"完成注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_registerButton addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_backgroundImageView];
    [self.view addSubview:_backgroundControl];
    [self.view addSubview:_usernameTextField];
    [self.view addSubview:_passwordTextField];
    [self.view addSubview:_nicknameTextField];
    [self.view addSubview:_displayPasswordButton];
    [self.view addSubview:_registerButton];
    
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 8, 28, 28);
    [backButton setImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.backgroundImageView = nil;
    self.backgroundControl = nil;
    self.usernameTextField = nil;
    self.passwordTextField = nil;
    self.nicknameTextField = nil;
    self.displayPasswordButton = nil;
    self.registerButton = nil;
    
    [_checked release];
    _checked = nil;
    [_noChecked release];
    _noChecked = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    if ([self.navigationController class] == [SCPMenuNavigationController class]) {
        [((SCPMenuNavigationController *) self.navigationController) setDisableMenu:YES];
    }
}
- (void)backButtonClick:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)allTextFieldsResignFirstResponder
{
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_nicknameTextField resignFirstResponder];
}

- (void)usernameDidEndOnExit
{
    [_passwordTextField becomeFirstResponder];
}

- (void)passwordDidEndOnExit
{
    [_nicknameTextField becomeFirstResponder];
}

- (void)checkBoxClicked
{
    [self allTextFieldsResignFirstResponder];
    _displayPasswordButton.selected = !_displayPasswordButton.selected;
    _passwordTextField.secureTextEntry = !_displayPasswordButton.selected;
}

- (void)doRegister
{
    UINavigationController *nav = self.navigationController;
    SCPFinishRegisterViewController *ctrl = [[SCPFinishRegisterViewController alloc] initWithEmail:_usernameTextField.text];
    [nav popViewControllerAnimated:NO];
    [nav pushViewController:ctrl animated:YES];
    [ctrl release];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    UIScrollView *view = (UIScrollView *) self.view;
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGSize size = view.contentSize;
    size.height += keyboardSize.height;
    view.contentSize = size;
    
    CGPoint point = view.contentOffset;
    point.y += 118;
    
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
    point.y -= 118;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    view.contentOffset = point;
    [UIView commitAnimations];
    
    CGSize size = view.contentSize;
    size.height -= keyboardSize.height;
    view.contentSize = size;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
