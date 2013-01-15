//
//  FeedViewController.m
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-17.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "SCPMainFeedController.h"

#import "SCPNavigationController.h"
#import "PullingRefreshTableView.h"


@implementation SCPMainFeedController

@synthesize manager = _manager;
@synthesize pullingController = _pullingController;
@synthesize item = _item;

- (void)dealloc
{
    [_pullingController release];
    [_manager release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.manager = [[[FeedListManager alloc] initWithController:self] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pullingController = [[[PullingRefreshController alloc] initWithImageName:[UIImage imageNamed:@"title_feed.png"]frame:self.view.bounds] autorelease];
    //customer for  scrollview
    self.pullingController.delegate = self.manager;
    self.pullingController.tableView.dataSource = self.manager;
    self.pullingController.headView.datasouce = self.manager;
    [self.pullingController setFootViewoffsetY:-10];
    [self.view addSubview:self.pullingController.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataWhenLoginStateChange:) name:@"LoginStateChange" object:nil];
    [self.pullingController realLoadingMore:nil];
    
}

- (void)handleDataWhenLoginStateChange:(NSNotification *)notifition
{
    if ([[[notifition userInfo] objectForKey:@"LogState"] isEqualToString:@"Logout"]) {
        [self.manager showViewForNoLogin];
    }else{
        [self.manager dismissLogin];
    }
    [self.manager dataSourcewithRefresh:YES];
}

#pragma mark -
#pragma mark customerNavigationItem
- (void)refreshButton:(UIButton *)button
{
    if (self.manager.isLoading) return;
    if ([self.pullingController.tableView numberOfSections]){
        [self.pullingController.tableView setContentOffset:CGPointZero];
    }
    [self.manager performSelector:@selector(refreshData:) withObject:nil afterDelay:0.2];
}
- (void)viewDidAppear:(BOOL)animated
{
    if (_item == nil) {
        _item = [[SCPBaseNavigationItem alloc] initWithNavigationController:self.navigationController];
        [_item addRefreshtarget:self action:@selector(refreshButton:)];
    }
    if (!_item.superview)    [self.navigationController.navigationBar addSubview:_item];
    
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    if (_item.superview)
        [_item removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated
{

    [self.manager refreshUserinfo];
}
@end
