//
//  NoticeViewController.m
//  SohuCloudPics
//
//  Created by sohu on 12-11-15.
//
//

#import "NoticeViewController.h"

@interface NoticeViewController ()

@end

@implementation NoticeViewController

@synthesize pullingController = _pullingController;
@synthesize manager = _manager;
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
            
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pullingController = [[[PullingRefreshController alloc] initWithImageName:[UIImage imageNamed:@"title_alert.png"]frame:self.view.bounds] autorelease];
    self.pullingController.headView.bannerName.frame = CGRectMake(130, 44, 60, 24);
    self.manager = [[[NoticeManager alloc] initWithViewController:self] autorelease];
    self.manager.controller = self;
    //customer for  scrollview
    self.pullingController.delegate = self.manager;
    self.pullingController.tableView.dataSource = self.manager;
    self.pullingController.headView.datasouce = self.manager;
    [self.pullingController.footView setHidden:YES];
    [self.view addSubview:self.pullingController.view];
    
}

#pragma mark -
#pragma mark customer Navigationiteam
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(navigationBack:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 35, 35);
    UIBarButtonItem* left = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItem = left;
    [self.manager dataSourcewithRefresh:YES];
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


@end
