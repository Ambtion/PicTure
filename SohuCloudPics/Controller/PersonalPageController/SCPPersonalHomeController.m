//
//  PersonalPageViewController.m
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-29.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "SCPPersonalHomeController.h"

#import "SCPMenuNavigationController.h"
#import "SCPFollowedListViewController.h"
#import "SCPFollowingListViewController.h"

@interface SCPPersonalHomeController ()
- (void)personalTopButtonHandle:(id)sender;
@end

@implementation SCPPersonalHomeController
@synthesize manager = _manager;
@synthesize footView = _footView;
@synthesize tableView = _tableView;
@synthesize topButton = _topButton;


- (void)dealloc
{
    self.footView = nil;
    [_tableView release];
    [_topButton release];
    self.manager.controller = nil;
    [_manager release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil useID:(NSString *) useID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _manager = [[PersonalHomeManager alloc] initWithController:self useID:useID];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.dataSource = _manager;
    _tableView.delegate = _manager;
    [self.view addSubview:_tableView];
    
    self.footView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
    _footView.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1];
    UITapGestureRecognizer * gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self.manager action:@selector(loadingMore:)] autorelease];
    [_footView addGestureRecognizer:gesture];
    UIImageView * imageview = [[[UIImageView alloc] initWithFrame:CGRectMake(110, 19, 18, 18)] autorelease];
    imageview.image = [UIImage imageNamed:@"load_more_pics.png"];
    [_footView addSubview:imageview];
    
    UILabel * label = [[[UILabel alloc] initWithFrame:CGRectMake(66  + 10, 0, 320 - 142, 50)] autorelease];
    label.tag = 100;
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:98.f/255 green:98.f/255 blue:98.f/255 alpha:1];
    label.text = @"加载更多...";
    label.backgroundColor = [UIColor clearColor];
    [_footView addSubview:label];
    
    UIActivityIndicatorView * active = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    active.tag = 200;
    active.frame = CGRectMake(320 - 66 + 22,30, 0, 0);
    active.color = [UIColor blackColor];
    active.hidesWhenStopped = YES;
    [active stopAnimating];
    [_footView addSubview:active];
    
    UIImageView * bg_imageview = [[[UIImageView alloc] initWithFrame:CGRectMake((320 - 30)/2.f,10.f, 30.f, 30.f)]autorelease];
    bg_imageview.image =[UIImage imageNamed:@"end_bg.png"];
    UIView * view = [[[UIView alloc] initWithFrame:_footView.bounds] autorelease];
    view.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
    [view addSubview:bg_imageview];
    
    [view addSubview:_footView];
    _tableView.tableFooterView = view;
    _topButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_topButton setBackgroundImage:[UIImage imageNamed:@"explore_up_page_icon.png"] forState:UIControlStateNormal];
    _topButton.frame = CGRectMake(self.view.bounds.size.width - 10 - 45, self.view.bounds.size.height - 55, 45, 45);
    [_topButton addTarget:self action:@selector(personalTopButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    [_topButton setHidden:YES];
    [self.view addSubview:_topButton];
    
    [self.manager dataSourcewithRefresh:YES];
}
- (void)personalTopButtonHandle:(id)sender
{
    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self showNavigationBar];
}
#pragma mark -
#pragma mark customer Navigationiteam
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_user_back.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_user_back_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(navigationBack:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 35, 35);
    
    UIBarButtonItem * left = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItem = left;
    [super viewWillAppear:animated];
}
- (void)navigationBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
