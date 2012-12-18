//
//  SCPPhotoDetailViewController.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPMenuNavigationController.h"
#import "SCPPhotoDetailViewController.h"

@implementation SCPPhotoDetailViewController

@synthesize manager = _manager;

@synthesize pullingController = _pullingController;
@synthesize commentPostBar = _commentPostBar;

- (void)dealloc
{
    [super dealloc];
    [_manager release];
    [_pullingController release];
    [_commentPostBar release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (id)initWithuseId:(NSString*) useId photoId:(NSString*)photoId
{
    self = [super init];
    if (self) {
        _manager = [[PhotoDetailManager alloc] initWithController:self useId:useId photoId:photoId];
    }
    return self;
}

- (id)initWithinfo:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _manager = [[PhotoDetailManager alloc] initWithController:self info:dic];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.pullingController = [[[PullingRefreshController alloc] initWithImageName:[UIImage imageNamed:@"title_photos.png"] frame:self.view.bounds] autorelease];
    
    //customer for  scrollview
    
    self.pullingController.delegate = self.manager;
    self.pullingController.tableView.dataSource = self.manager;
    self.pullingController.headView.datasouce = self.manager;
    [self.pullingController.footView setHidden:YES];
    [self.view addSubview:self.pullingController.view];
    [self.manager dataSourcewithRefresh:YES];
    
    _commentPostBar = [[CommentPostBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y + self.view.bounds.size.height, 320, 45)];
    _commentPostBar.delegate = self;
    [self.view addSubview:_commentPostBar];
    self.view.backgroundColor = [UIColor clearColor];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    backButton.frame = CGRectMake(0, 0, 26, 26);
    UIBarButtonItem* left = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItem = left;
    [super viewWillAppear:animated];
}

- (void)navigationBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)displayCommentPostBar
{
    // check whether logged in
    
    CGRect barFrame = _commentPostBar.frame;
    
    if (barFrame.origin.y == self.view.bounds.size.height - barFrame.size.height)
        return;
    
    barFrame.origin.y = self.view.bounds.size.height - barFrame.size.height;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:NO];
    _commentPostBar.frame = barFrame;
    [UIView commitAnimations];
}

- (void)dismissCommentPostBar
{
    CGRect barFrame = _commentPostBar.frame;
    
    if (barFrame.origin.y == self.view.bounds.size.height)
        return;
    
    barFrame.origin.y = self.view.bounds.size.height;
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:NO];
    _commentPostBar.frame = barFrame;
    [UIView commitAnimations];
}

- (void)commentPostBar:(CommentPostBar *)bar postComment:(NSString *)comment
{
    // do the posting
    [self dismissCommentPostBar];
    // TODO
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //    CGRect frame = self.view.frame;
    //    frame.size.height -= keyboardSize.height;
    CGRect frame = _commentPostBar.frame;
    frame.origin.y -= keyboardSize.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    //    self.view.frame = frame;
    _commentPostBar.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    CGRect frame = _commentPostBar.frame;
    frame.origin.y = self.view.frame.size.height;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    _commentPostBar.frame = frame;
    [UIView commitAnimations];
}
#pragma mark - controller Action
- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
