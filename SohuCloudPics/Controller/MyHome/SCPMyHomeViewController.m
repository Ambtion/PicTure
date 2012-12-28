//
//  SCPMyHomeViewController.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import "SCPMyHomeViewController.h"
#import "SCPMenuNavigationController.h"

@interface SCPMyHomeViewController ()

@end

@implementation SCPMyHomeViewController
@synthesize manager = _manager;
@synthesize homeTable = _homeTable;
@synthesize topButton = _topButton;

- (void)dealloc
{
    self.manager = nil;
    self.homeTable = nil;
    self.footView = nil;
    self.topButton = nil;
    [super dealloc];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil useID:(NSString *) use_ID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _manager = [[MyhomeManager alloc] initWithController:self useID:use_ID];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISwipeGestureRecognizer * nothing = [[[UISwipeGestureRecognizer alloc] init] autorelease];
    nothing.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:nothing];
    CGRect frame = self.view.frame;
    _homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
    _homeTable.separatorColor = [UIColor clearColor];
    _homeTable.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1];

    _homeTable.dataSource = _manager;
    _homeTable.delegate = _manager;
    [self.view addSubview:_homeTable];
    [self addTableFootView];
    
    if ([SCPLoginPridictive isLogin]) {
        [self.manager dataSourcewithRefresh:YES];
    }
}
- (void)addTableFootView
{
    self.footView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
    _footView.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1];
    UITapGestureRecognizer * gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self.manager action:@selector(loadingMore:)] autorelease];
    [_footView addGestureRecognizer:gesture];
    UIImageView * imageview = [[[UIImageView alloc] initWithFrame:CGRectMake(110, 21, 18, 18)] autorelease];
    imageview.image = [UIImage imageNamed:@"load_more_pics.png"];
    [_footView addSubview:imageview];
    
    UILabel * label = [[[UILabel alloc] initWithFrame:CGRectMake(66  + 10, 0, 320 - 142, 50)] autorelease];
    label.tag = 100;
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:97.0/255 green:120.0/255 blue:137.0/255 alpha:1];
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
    
    ////
    UIImageView * bg_imageview = [[[UIImageView alloc] initWithFrame:CGRectMake((320 - 30)/2.f,10.f, 30.f, 30.f)]autorelease];
    bg_imageview.image =[UIImage imageNamed:@"end_bg.png"];
    UIView * view = [[[UIView alloc] initWithFrame:_footView.bounds] autorelease];
    view.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
    [view addSubview:bg_imageview];
    [view addSubview:_footView];
    _homeTable.tableFooterView = view;
    [self.navigationItem setHidesBackButton:YES];
    
    _topButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_topButton setBackgroundImage:[UIImage imageNamed:@"explore_up_page_icon.png"] forState:UIControlStateNormal];
    _topButton.frame = CGRectMake(self.view.bounds.size.width - 10 - 45, self.view.bounds.size.height - 55, 45, 45);
    [_topButton addTarget:self action:@selector(homeTopButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    [_topButton setHidden:YES];
    [self.view addSubview:_topButton];
}

- (void)homeTopButtonHandle:(id)sender
{
    [self.homeTable setContentOffset:CGPointZero animated:YES];
    [self showNavigationBar];
}

#pragma mark -
#pragma mark customerNavigationIteam

- (void)viewDidAppear:(BOOL)animated
{
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(myHomeNavigationBack:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 26, 26);
    UIBarButtonItem * left = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItem = left;
    [self.manager refreshUserinfo];
}
- (void)myHomeNavigationBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"%s",__FUNCTION__);
}

@end
