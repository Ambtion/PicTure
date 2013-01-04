//
//  PersonalPageManager.m
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-29.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "PersonalPageManager.h"

#import "SCPPersonalPageViewController.h"
#import "SCPAlbumListController.h"
#import "SCPPhotoDetailViewController.h"
#import "SCPFollowingListViewController.h"
#import "SCPFollowedListViewController.h"
#import "SCPLoginPridictive.h"

#define MAXIMAGEHEIGTH 320
#define MAXPICTURE 200
#define PAGEPHOTONUMBER 

static float OFFSET = 0.f;
@implementation PersonalPageManager

@synthesize controller = _controller;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_requestManager setDelegate:nil];
    [_requestManager release];
    [_dataArray release];
    [_personalDataSource release];
    [_user_ID release];
    [super dealloc];
}
- (id)initWithController:(SCPPersonalPageViewController *)ctrl useID:(NSString *)useID
{
    
    self = [super init];
    if (self) {
        _user_ID = [useID retain];
        _controller = ctrl;
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        _personalDataSource = [[PersonalPageCellDateSouce alloc] init];
        _requestManager = [[SCPRequestManager alloc] init];
        _requestManager.delegate = self;
        _willRefresh = YES;
        _isinit = YES;
        _loadingMore = NO;
        curPage = 0;
        hasNextpage = YES;
        
    }
    return self;
}
- (CGFloat)getHeightofImage:(CGFloat)O_height :(CGFloat) O_width
{
    CGFloat finalHeigth = 0.f;
    finalHeigth = O_height * (320.f / O_width);
    if (!finalHeigth) {
        finalHeigth = 320;
    }
    return finalHeigth;
}
- (void)refreshUserinfo
{
    if (_isinit || !_user_ID) return;
    [_requestManager getUserInfoWithID:[NSString stringWithFormat:@"%@",_user_ID]success:^(NSDictionary *response) {
        _personalDataSource.portrait = [response objectForKey:@"user_icon"];
        _personalDataSource.name = [response objectForKey:@"user_nick"];
        _personalDataSource.desc = [response objectForKey:@"user_desc"];
        _personalDataSource.albumAmount = [[response objectForKey:@"public_folders"] intValue];
        _personalDataSource.followedAmount = [[response objectForKey:@"followers"] intValue];
        _personalDataSource.followingAmount = [[response objectForKey:@"followings"] intValue];
        _personalDataSource.isFollowByMe = [[response objectForKey:@"is_following"] boolValue];
        [self.controller.tableView reloadData];
    } failure:^(NSString *error) {
        [self requestFailed:error];
    }];
}
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
//    NSLog(@"%@",info);
    if (wait) {
        [wait dismissWithClickedButtonIndex:0 animated:YES];
        [wait release],wait = nil;
    }
    if (_willRefresh) {
        [_dataArray removeAllObjects];
        NSDictionary * userInfo = [info objectForKey:@"userInfo"];
        _personalDataSource.isInit = NO;
        _personalDataSource.portrait = [userInfo objectForKey:@"user_icon"];
        _personalDataSource.name = [userInfo objectForKey:@"user_nick"];
        _personalDataSource.desc = [userInfo objectForKey:@"user_desc"];
        _personalDataSource.albumAmount = [[userInfo objectForKey:@"public_folders"] intValue];
        _personalDataSource.followedAmount = [[userInfo objectForKey:@"followers"] intValue];
        _personalDataSource.followingAmount = [[userInfo objectForKey:@"followings"] intValue];
        _personalDataSource.isFollowByMe = [[userInfo objectForKey:@"is_following"] boolValue];
        if ([SCPLoginPridictive currentUserId]) {
            _personalDataSource.isMe = [_user_ID isEqualToString:(NSString *)[SCPLoginPridictive currentUserId]];
        }else{
            _personalDataSource.isMe = NO;
        }
    }
    
    NSDictionary * feedinfo = [info objectForKey:@"feedList"];
    hasNextpage = [[feedinfo objectForKey:@"has_next"] boolValue];
    curPage = [[feedinfo objectForKey:@"page"] intValue];
    
    NSArray * photoList = [[info objectForKey:@"feedList"] objectForKey:@"feed"];
    for (int i = 0; i < photoList.count; ++i) {
        FeedCellDataSource *adapter = [[FeedCellDataSource alloc] init];
        NSDictionary * photo = [photoList objectAtIndex:i];
        adapter.allInfo = photo;
        adapter.heigth = [self getHeightofImage:[[photo objectForKey:@"height"] floatValue] :[[photo objectForKey:@"width"] floatValue]];
        adapter.name = [photo objectForKey:@"user_nick"];
        adapter.update =[photo objectForKey:@"upload_at_desc"];
        adapter.portrailImage = [photo objectForKey:@"user_icon"];
        adapter.photoImage  = [photo objectForKey:@"photo_url"];
        [_dataArray addObject:adapter];
        [adapter release];
    }
    if (_isinit) {
        _isinit = NO;
        _isLoading = NO;
        [self.controller.tableView reloadData];
    }
    if (_willRefresh) {
        [self refreshFinished];
    }else{
        [self loadingMoreFinished];
    }
}

#pragma mark - Network Failed
- (void)requestFailed:(NSString *)error
{
    if (wait) {
        [wait dismissWithClickedButtonIndex:0 animated:YES];
        [wait release],wait = nil;
    }
    SCPAlert_CustomeView * alertView = [[[SCPAlert_CustomeView alloc] initWithTitle:error] autorelease];
    [alertView show];
    [self restNetWorkState];
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex != 0) {
//        [self dataSourcewithRefresh:_willRefresh];
//    }else{
//        [self restNetWorkState];
//    }
//}
- (void)restNetWorkState
{
    if (_willRefresh) {
        [self refreshFinished];
    }else{
        [self loadingMoreFinished];
    }    
}
#pragma mark Data Source
- (void)dataSourcewithRefresh:(BOOL)isRefresh
{
    if (_isinit) {
        wait = [[SCPAlert_WaitView alloc] initWithImage:[UIImage imageNamed:@"pop_alert.png"] text:@"加载中..." withView:_controller.view];
        [wait show];
     }
    
    _isLoading = YES;
    _willRefresh = isRefresh;
    if(_willRefresh | !_dataArray.count){
        [_requestManager getUserInfoWithID:_user_ID];
    }else{
        [_requestManager getUserInfoFeedWithUserID:_user_ID page:curPage + 1];
    }
}
#pragma mark -

#pragma mark  Limit Scrollview
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + 44 && scrollView.contentOffset.y >= 44 && !self.controller.footView.hidden) {
        [self showLoadingMore];
        _loadingMore = YES;
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 368 - 480) {
        scrollView.contentOffset = CGPointMake(0, 368  - 480);
    }
    if (scrollView.contentOffset.y <= scrollView.contentSize.height - scrollView.frame.size.height) {
        if (_loadingMore) {
            _loadingMore = NO;
            [self loadingMore:nil];
        }
    }
    if (scrollView.contentOffset.y >= scrollView.bounds.size.width && scrollView.contentOffset.y < OFFSET && scrollView.contentOffset.y < scrollView.contentSize.height - 580) {
        [_controller.topButton setHidden:NO];
    }else{
        [_controller.topButton setHidden:YES];
    }
    OFFSET = scrollView.contentOffset.y;

}
- (void)personalPageCell:(PersonalPageCell *)personal refreshClick:(id)sender
{
    if (_isLoading) {
        return;
    }
    [self dataSourcewithRefresh:YES];
}
#pragma mark RefreshData Action
- (void)refreshFinished
{
    _isLoading = NO;
    [self.controller.tableView reloadData];
}
- (void)showLoadingMore
{
    if (_isLoading) {
        return;
    }
    UIView * view  = _controller.tableView.tableFooterView;
    UILabel * label = (UILabel *)[view viewWithTag:100];
    UIActivityIndicatorView * acv  = (UIActivityIndicatorView *)[view viewWithTag:200];
    label.text = @"加载中...";
    [acv startAnimating];

}
- (void)loadingMore:(id)sender
{
    if (sender) {
        [self showLoadingMore];
    }
    [self dataSourcewithRefresh:NO];
}
- (void)loadingMoreFinished
{
    _isLoading = NO;
    UIView *  view = _controller.tableView.tableFooterView;
    UILabel * label = (UILabel *)[view viewWithTag:100];
    label.text  = @"加载更多...";
    UIActivityIndicatorView * act = (UIActivityIndicatorView *)[view viewWithTag:200];
    [act stopAnimating];
    [_controller.tableView reloadData];
}

#pragma mark TableView Deleagte
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (MAXPICTURE < _dataArray.count|| !hasNextpage || _isinit){
        [self.controller.footView setHidden:YES];
    }else{
        [self.controller.footView setHidden:NO];
    }
    return _dataArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.row;
    if (i == 0) {
        return 367 + 60 + 10;
    }
    CGFloat height = ((FeedCellDataSource *)[_dataArray objectAtIndex:i - 1]).heigth;
    if (height < 320) {
        return 320 + 70 + 10;
    }else if(height > MAXIMAGEHEIGTH){
        return MAXIMAGEHEIGTH + 70 + 10;
    }else{
        return height + 70 + 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    if (row == 0) {
        PersonalPageCell* pageCell = [tableView dequeueReusableCellWithIdentifier:@"PAGECELL"];
        if (pageCell == nil) {
            pageCell = [[[PersonalPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PAGECELL"] autorelease];
            pageCell.delegate = self;
        }
        pageCell.datasource = _personalDataSource;
        return pageCell;
    }
    else {
        FeedCell * feedCell = [tableView dequeueReusableCellWithIdentifier:@"FEEDCELL"];
        if (feedCell == nil) {
            feedCell = [[[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FEEDCELL"] autorelease];
            feedCell.delegate = self;
            feedCell.maxImageHeigth = MAXIMAGEHEIGTH;
        }
        feedCell.dataSource = [_dataArray objectAtIndex:row - 1];
        return feedCell;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1];
}
#pragma mark Picture Method
- (void)personalPageCell:(PersonalPageCell *)personal follwetogether:(id)sender
{
    if (![SCPLoginPridictive isLogin]) {
        SCPAlert_LoginView  * loginView = [[[SCPAlert_LoginView alloc] initWithMessage:LOGIN_HINT delegate:self] autorelease];
        [loginView show];
        return;
    }
    if (personal.datasource.isFollowByMe) {
        [_requestManager destoryFollowing:_user_ID  success:^(NSString *response) {
            NSLog(@"%@",response);
//            [self dataSourcewithRefresh:YES];
//            [self refreshFin]
            [self refreshUserinfo];
        } failure:^(NSString *error) {
            [self requestFailed:error];
            return ;
        }];
    }else{
        
        [_requestManager friendshipsFollowing:_user_ID  success:^(NSString *response) {
//            [self dataSourcewithRefresh:YES];
            [self refreshUserinfo];
        } failure:^(NSString *error) {
            [self requestFailed:error];
            return ;
        }];
    }    
}

#pragma mark Login
- (void)alertViewOKClicked:(SCPAlert_LoginView *)view
{
    SCPLoginViewController *loginCtrl = [[SCPLoginViewController alloc] init];
    loginCtrl.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginCtrl];
    [self.controller presentModalViewController:nav animated:YES];
    [loginCtrl release];
    [nav release];
}

- (void)SCPLogin:(SCPLoginViewController *)LoginController cancelLogin:(UIButton *)button
{
    [self.controller dismissModalViewControllerAnimated:YES];
}

- (void)SCPLogin:(SCPLoginViewController *)LoginController doLogin:(UIButton *)button
{
    [self.controller dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark CELL - Method
#pragma feedCell Method
-(void)feedCell:(FeedCell *)cell clickedAtPhoto:(id)object
{
    UINavigationController *nav = _controller.navigationController;
    SCPPhotoDetailViewController *ctrl = [[SCPPhotoDetailViewController alloc] initWithinfo:cell.dataSource.allInfo];
    [nav pushViewController:ctrl animated:YES];
    [ctrl release];
}

-(void)feedCell:(FeedCell *)cell clickedAtPortraitView:(id)object
{
    // do nothing, cause it's personal page 个人页面所有的头像都是自己
    NSLog(@"clickedAtPortraitView");
}

- (void)feedCell:(FeedCell *)cell clickedAtFavorButton:(id)object
{
    // do something 暂时不支持评论
    NSLog(@"clickedAtFavorButton");
}

-(void)feedCell:(FeedCell *)cell clickedAtCommentButton:(id)objectx
{
    //评论被取消
}
#pragma mark menu Delegate
- (void)personalPageCell:(PersonalPageCell *)personal photoBookClicked:(id)sender
{
    SCPAlbumListController *alb = [[SCPAlbumListController  alloc] initWithNibName:nil bundle:nil useID:_user_ID];
    [_controller.navigationController pushViewController:alb animated:YES];
    [alb release];
}
-(void)personalPageCell:(PersonalPageCell *)personal favoriteClicked:(id)sender
{
    NSLog(@"favoriteClicked");
}
- (void)personalPageCell:(PersonalPageCell *)personal followingButtonClicked:(id)sender
{
    UINavigationController *nav = _controller.navigationController;
    SCPFollowingListViewController *ctrl = [[SCPFollowingListViewController alloc] initWithNibName:nil bundle:nil useID:_user_ID];
    [nav pushViewController:ctrl animated:YES];
    [ctrl release];
}
- (void)personalPageCell:(PersonalPageCell *)personal followedButtonClicked:(id)sender
{
    UINavigationController *nav = _controller.navigationController;
    SCPFollowedListViewController *ctrl = [[SCPFollowedListViewController alloc] initWithNibName:nil bundle:nil useID:_user_ID];
    [nav pushViewController:ctrl animated:YES];
    [ctrl release];
}
@end
