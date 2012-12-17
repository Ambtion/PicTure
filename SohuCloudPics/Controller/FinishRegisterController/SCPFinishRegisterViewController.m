//
//  SCPFinishRegisterViewController.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPFinishRegisterViewController.h"

#import "SCPMenuNavigationController.h"

@implementation SCPFinishRegisterViewController

@synthesize emailAddr = _emailAddr;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize emailLabel = _emailLabel;
@synthesize emailButton = _emailButton;

- (void)dealloc
{
    [_emailAddr release];
    [_backgroundImageView release];
    [_emailLabel release];
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

- (id)initWithEmail:(NSString *)email
{
    self = [super init];
    if (self) {
        self.emailAddr = email;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGRect frame = self.view.frame;
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    _backgroundImageView.image = [UIImage imageNamed:@"linkin_email.png"];
    
    _emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 195, 200, 15)];
    _emailLabel.font = [UIFont systemFontOfSize:12];
    _emailLabel.textColor = [UIColor colorWithRed:0 green:0.4392 blue:0.8471 alpha:1];
    _emailLabel.backgroundColor = [UIColor clearColor];
    _emailLabel.text = _emailAddr;
    
    _emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _emailButton.frame = CGRectMake(47, 237, 225, 35);
    [_emailButton setBackgroundImage:[UIImage imageNamed:@"linkin_email_btn_normal.png"] forState:UIControlStateNormal];
    [_emailButton setBackgroundImage:[UIImage imageNamed:@"linkin_email_btn_press.png"] forState:UIControlStateHighlighted];
    [_emailButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    _emailButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_emailButton setTitle:@"查看邮箱" forState:UIControlStateNormal];
    [_emailButton addTarget:self action:@selector(gotoEmail) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_backgroundImageView];
    [self.view addSubview:_emailLabel];
    [self.view addSubview:_emailButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.backgroundImageView = nil;
    self.emailLabel = nil;
    self.emailButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    if ([self.navigationController class] == [SCPMenuNavigationController class]) {
        [((SCPMenuNavigationController *) self.navigationController) setDisableMenu:YES];
    }
}

- (void)gotoEmail
{
    UINavigationController *nav = self.navigationController;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mail.163.com"]];
    [nav popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
