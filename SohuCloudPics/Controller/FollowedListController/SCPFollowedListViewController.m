//
//  SCPFollowedListViewController.m
//  SohuCloudPics
//
//  Created by Zhong Sheng on 12-9-6.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "SCPFollowedListViewController.h"

@implementation SCPFollowedListViewController

@synthesize pullingController = _pullingController;
@synthesize manager = _manager;
@synthesize refreshButton = _refreshButton;
- (void)dealloc
{
    [_pullingController release];
    [_manager release];
    [_refreshButton release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil useID:(NSString *) use_ID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.manager = [[[SCPFollowedListManager alloc] initWithViewController:self useID:use_ID] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pullingController = [[[PullingRefreshController alloc] initWithImageName:[UIImage imageNamed:@"title_follower.png"]frame:self.view.bounds] autorelease];
    self.pullingController.headView.bannerName.frame = CGRectMake(130, 44, 60, 24);
    
    //customer for  scrollview
    self.pullingController.delegate = self.manager;
    self.pullingController.tableView.dataSource = self.manager;
    self.pullingController.headView.datasouce = self.manager;
    [self.view addSubview:self.pullingController.view];
//    [self.manager dataSourcewithRefresh:YES];
//    [self.pullingController showLoadingMore];
    [self.pullingController realLoadingMore:nil];
}

#pragma mark -
#pragma mark customer Navigationiteam
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [((SCPMenuNavigationController *) self.navigationController).menuView setHidden:YES];
    [((SCPMenuNavigationController *) self.navigationController).ribbonView setHidden:YES];
    
    _refreshButton = [[RefreshButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [_refreshButton addTarget:self.manager action:@selector(refreshData:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right = [[[UIBarButtonItem alloc] initWithCustomView:_refreshButton] autorelease];
    self.navigationItem.rightBarButtonItem = right;
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(navigationBack:) forControlEvents:UIControlEventTouchUpInside];
//    backButton.frame = CGRectMake(0, 0, 26, 26);
    backButton.frame = CGRectMake(0, 0, 35, 35);
    UIBarButtonItem* left = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItem = left;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [((SCPMenuNavigationController *) self.navigationController).menuView setHidden:NO]; menu应该保持隐藏状态
    [((SCPMenuNavigationController *) self.navigationController).ribbonView setHidden:NO];
}
- (void)navigationBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.pullingController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
