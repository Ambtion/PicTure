//
//  MyHomeManager.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import "MyhomeManager.h"

#import "SCPMyHomeViewController.h"

#import "SCPAlbumGridController.h"
#import "SCPPhotoDetailViewController.h"
#import "SCPFollowingListViewController.h"
#import "SCPFollowedListViewController.h"
#import "SCPSetttingController.h"
#import "MoreAlertView.h"


#define MAXIMAGEHEIGTH 320
#define MAXPICTURE 200
@implementation MyhomeManager
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
- (id)initWithController:(SCPMyHomeViewController *)ctrl useID:(NSString *)useID
{
    self = [super init];
    if (self) {
        _user_ID = [useID retain];
        _controller = ctrl;
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        _personalDataSource = [[MyPersonalCelldataSource alloc] init];
        _requestManager = [[SCPRequestManager alloc] init];
        _requestManager.delegate = self;
        _willRefresh = YES;
        _isinit = YES;
        // [self dataSourcewithRefresh:YES];
    }
    return self;
}

- (CGFloat)getHeightofImage:(CGFloat)O_height :(CGFloat) O_width
{
    CGFloat finalHeigth = 0.f;
    finalHeigth = O_height * (320.f / O_width);
    //    NSLog(@"finalHeigth %f",finalHeigth);
    if (!finalHeigth) {
        finalHeigth = 320;
    }
    return finalHeigth;
}
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    NSLog(@"requestFinished %@",info);
    if (_willRefresh) {
        [_dataArray removeAllObjects];
        NSDictionary * userInfo = [info objectForKey:@"userinfo"];
        //        MyPersonalCelldataSource * data = [[MyPersonalCelldataSource alloc] init];
        _personalDataSource.allInfo = userInfo;
        _personalDataSource.portrait = [userInfo objectForKey:@"icon"];
        _personalDataSource.name = [userInfo objectForKey:@"nickname"];
        _personalDataSource.desc = [userInfo objectForKey:@"bio"];
        
        NSLog(@"%s, %@",__FUNCTION__,[userInfo objectForKey:@"publicFolders"]);
        
        _personalDataSource.albumAmount = [[userInfo objectForKey:@"publicFolders"] intValue];
        _personalDataSource.followedAmount = [[userInfo objectForKey:@"followerCount"] intValue];
        _personalDataSource.followingAmount = [[userInfo objectForKey:@"followingCount"] intValue];
//        _personalDataSource.favouriteAmount = 0;
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

//        adapter.favourtecount = i * 17;
//        adapter.ismyLike = YES;
        [_dataArray addObject:adapter];
        [adapter release];
    }
    if (_isinit) {
        _isinit = NO;
        _isLoading = NO;
        [self.controller.homeTable reloadData];
    }
    if (_willRefresh) {
        [self refreshFinished];
    }else{
        [self loadingMoreFinished];
    }
}

#pragma mark - networkFailed
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
#pragma mark - limit scrollview
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
- (void)MyPersonalCell:(MyPersonalCell *)cell refreshClick:(id)sender
{
    if (_isLoading) {
        return;
    }
    [self dataSourcewithRefresh:YES];
}
#pragma mark refresh
- (void)refreshFinished
{
    _isLoading = NO;
    [self.controller.homeTable reloadData];
    //    [self.controller.homeTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)showLoadingMore
{
    if (_isLoading) {
        return;
    }
    UIView * view  = _controller.homeTable.tableFooterView;
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
    UIView *  view = _controller.homeTable.tableFooterView;
    UILabel * label = (UILabel *)[view viewWithTag:100];
    label.text  = @"加载更多...";
    UIActivityIndicatorView * act = (UIActivityIndicatorView *)[view viewWithTag:200];
    [act stopAnimating];
    [_controller.homeTable reloadData];
}
#pragma mark dataSource
- (void)dataSourcewithRefresh:(BOOL)isRefresh
{
    _isLoading = YES;
    _willRefresh = isRefresh;
    if(_willRefresh | !_dataArray.count){
        [_requestManager getUserInfoWithID:[SCPLoginPridictive currentToken]];
    }else{
//        if (MAXPICTURE < _dataArray.count || _dataArray.count % 20) {
//            MoreAlertView * moreView = [[[MoreAlertView alloc] init] autorelease];
//            [moreView show];
//            [self loadingMoreFinished];
//            return;
//        }
        NSInteger pagenum = [_dataArray count] / 20;
        [_requestManager getUserInfoFeedWithUserID:[SCPLoginPridictive currentUserId] page:pagenum + 1 only:YES];
        
    }
}

#pragma mark -
#pragma mark tableViewDeleagte
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (MAXPICTURE < _dataArray.count|| !_dataArray.count || _dataArray.count % 20) {
        [self.controller.footView setHidden:YES];
    }else{
        [self.controller.footView setHidden:NO];
    }
    return _dataArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.row;
    //    switch (i) {
    //        case 0:
    //            return 367 + 60 + 10;//for PersonalPageCell
    //        default:
    //            return MAX(((FeedCellDataSource *)[_dataArray objectAtIndex:indexPath.row]).heigth + 70 + 10, 390 + 10);;//for FeedCell
    //    }
    if (i == 0) {
        return 367 + 60 + 10;//for PersonalPageCell
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
        MyPersonalCell* pageCell = [tableView dequeueReusableCellWithIdentifier:@"PAGECELL"];
        if (pageCell == nil) {
            pageCell = [[[MyPersonalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PAGECELL"] autorelease];
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

#pragma feedCell Method
-(void)feedCell:(FeedCell *)cell clickedAtPhoto:(id)object
{
    if (![self isLogin]) return;
    UINavigationController * nav = _controller.navigationController;
    SCPPhotoDetailViewController *ctrl = [[SCPPhotoDetailViewController alloc] initWithinfo:cell.dataSource.allInfo];
    [nav pushViewController:ctrl animated:YES];
    [ctrl release];
}

-(void)feedCell:(FeedCell *)cell clickedAtPortraitView:(id)object
{
    // do nothing, cause it's personal page
    NSLog(@"clickedAtPortraitView");
    
}

-(void)feedCell:(FeedCell *)cell clickedAtFavorButton:(id)object
{
    // do something
    NSLog(@"clickedAtFavorButton");
}

-(void)feedCell:(FeedCell *)cell clickedAtCommentButton:(id)objectx
{
    //    UINavigationController * nav = _controller.navigationController;
    //    SCPPhotoDetailViewController *ctrl = [[SCPPhotoDetailViewController alloc] init];
    //    [nav pushViewController:ctrl animated:YES];
    //
    //    [ctrl release];
}
#pragma mark -
- (BOOL)isLogin
{
    if (![SCPLoginPridictive isLogin]) {
        MoreAlertView * more = [[[MoreAlertView alloc] init] autorelease];
        [more show];
    }
    return [SCPLoginPridictive isLogin];
}
#pragma mark CELL - Method
- (void)MyPersonalCell:(MyPersonalCell *)cell settingClick:(id)sender
{
    SCPSetttingController * setting = [[[SCPSetttingController alloc] initWithcontroller:_controller] autorelease];
    [_controller presentModalViewController:setting animated:YES];
}
- (void)MyPersonalCell:(MyPersonalCell *)cell photoBookClicked:(id)sender
{
    if (![self isLogin]) return;
    SCPAlbumGridController * alb = [[SCPAlbumGridController  alloc] initWithNibName:nil bundle:nil useID:[SCPLoginPridictive currentUserId]];
    [_controller.navigationController pushViewController:alb animated:YES];
    [alb release];
}
- (void)MyPersonalCell:(MyPersonalCell *)cell favoriteClicked:(id)sender
{
    if (![self isLogin]) return;
}
- (void)MyPersonalCell:(MyPersonalCell *)cell followingButtonClicked:(id)sender
{
    if (![self isLogin]) return;
    NSLog(@"%s",__FUNCTION__);
    UINavigationController *nav = _controller.navigationController;
    SCPFollowingListViewController *ctrl = [[SCPFollowingListViewController alloc] initWithNibName:nil bundle:nil useID:[SCPLoginPridictive currentUserId]];
    [nav pushViewController:ctrl animated:YES];
    [ctrl release];
}
- (void)MyPersonalCell:(MyPersonalCell *)cell followedButtonClicked:(id)sender
{
    if (![self isLogin]) return;
    UINavigationController *nav = _controller.navigationController;
    SCPFollowedListViewController *ctrl = [[SCPFollowedListViewController alloc] initWithNibName:nil bundle:nil useID:[SCPLoginPridictive currentUserId]];
    [nav pushViewController:ctrl animated:YES];
    [ctrl release];
}

@end
