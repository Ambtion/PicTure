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
#import "MoreAlertView.h"

#define MAXIMAGEHEIGTH 320

#define MAXPICTURE 200
#define PAGEPHOTONUMBER 
@implementation PersonalPageManager

@synthesize controller = _controller;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
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
//        [self dataSourcewithRefresh:YES];
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

- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    
    if (_willRefresh) {
        [_dataArray removeAllObjects];
        NSDictionary * userInfo = [info objectForKey:@"userinfo"];
        _personalDataSource.allInfo = userInfo;
        _personalDataSource.portrait = [userInfo objectForKey:@"icon"];
        _personalDataSource.name = [userInfo objectForKey:@"nickname"];
        _personalDataSource.desc = [userInfo objectForKey:@"bio"];
        _personalDataSource.albumAmount = [[userInfo objectForKey:@"publicFolders"] intValue];
        _personalDataSource.followedAmount = [[userInfo objectForKey:@"followerCount"] intValue];
        _personalDataSource.followingAmount = [[userInfo objectForKey:@"followingCount"] intValue];
        _personalDataSource.isFollowed = [_requestManager whetherFollowUs:_user_ID userID:[SCPLoginPridictive currentUserId] success:nil];
        _personalDataSource.favouriteAmount = -1;
    }
    
    NSArray * photoList = [info objectForKey:@"photoList"];
    for (int i = 0; i < photoList.count; ++i) {
        FeedCellDataSource *adapter = [[FeedCellDataSource alloc] init];
        NSDictionary * photo = [photoList objectAtIndex:i];
        adapter.allInfo = photo;
        adapter.heigth = [self getHeightofImage:[[photo objectForKey:@"height"] floatValue] :[[photo objectForKey:@"width"] floatValue]];
        adapter.name = [photo objectForKey:@"creatorNick"];
        adapter.update =[photo objectForKey:@"uploadAtDesc"];
        adapter.portrailImage = [photo objectForKey:@"creatorIcon"];
        adapter.photoImage  = [photo objectForKey:@"bigUrl"];

        adapter.favourtecount = i * 17;
        adapter.ismyLike = YES;
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
- (void)requestFailed:(ASIHTTPRequest *)mangeger
{    
    UIAlertView * alterView = [[[UIAlertView alloc] initWithTitle:@"访问失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"重试", nil] autorelease];
    [alterView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        [self dataSourcewithRefresh:_willRefresh];
    }else{
        [self restNetWorkState];
    }
}
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
    _isLoading = YES;
    _willRefresh = isRefresh;
    if(_willRefresh | !_dataArray.count){
        [_requestManager getUserInfoWithID:_user_ID];
    }else{
//        if (MAXPICTURE < _dataArray.count || _dataArray.count % 20){
//            MoreAlertView * moreView = [[[MoreAlertView alloc] init] autorelease];
//            [moreView show];
//            [self loadingMoreFinished];
//            return;
//        }
        NSInteger pagenum = [_dataArray count] / 20;
        [_requestManager getUserInfoFeedWithUserID:_user_ID page:pagenum + 1 only:YES];
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
//    [self.controller.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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
    if (MAXPICTURE < _dataArray.count|| !_dataArray.count || _dataArray.count % 20 ){
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
    NSLog(@"%s",__FUNCTION__);
    if (personal.datasource.isFollowed) {
        [_requestManager destoryFollowing:_user_ID userID:[SCPLoginPridictive currentUserId] success:^(NSString *response) {
            _personalDataSource.isFollowed = NO;
        }];
        
    }else{
        
        [_requestManager friendshipsFollowing:_user_ID userID:[SCPLoginPridictive currentUserId] success:^(NSString *response) {
            _personalDataSource.isFollowed = YES;
        }];
    }
    [self.controller.tableView reloadData];
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
    NSLog(@"%@",_user_ID);
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
