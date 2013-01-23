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
#import "SCPAlbumListController.h"


#define MAXIMAGEHEIGTH 320
#define MAXPICTURE 200

static float OFFSET = 0.f;
@implementation MyhomeManager
@synthesize controller = _controller;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (wait) {
        [wait dismissWithClickedButtonIndex:0 animated:YES];
        [wait release],wait = nil;
    }
    [_requestManager setDelegate:nil];
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
    
    if (_isinit || ![SCPLoginPridictive currentUserId]) return;
    [_requestManager getUserInfoWithID:[NSString stringWithFormat:@"%@",[SCPLoginPridictive currentUserId]] asy:YES success:^(NSDictionary *response) {
        _personalDataSource.portrait = [response objectForKey:@"user_icon"];
        _personalDataSource.name = [response objectForKey:@"user_nick"];
        _personalDataSource.desc = [response objectForKey:@"user_desc"];
        _personalDataSource.albumAmount = [[response objectForKey:@"public_folders"] intValue] + [[response objectForKey:@"private_folders"] intValue];
        _personalDataSource.followedAmount = [[response objectForKey:@"followers"] intValue];
        _personalDataSource.followingAmount = [[response objectForKey:@"followings"] intValue];
        [self.controller.homeTable reloadData];
    } failure:^(NSString *error) {
        [self requestFailed:error];
    }];
}
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    
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
        _personalDataSource.albumAmount = [[userInfo objectForKey:@"public_folders"] intValue] + [[userInfo objectForKey:@"private_folders"] intValue];
        _personalDataSource.followedAmount = [[userInfo objectForKey:@"followers"] intValue];
        _personalDataSource.followingAmount = [[userInfo objectForKey:@"followings"] intValue];
        
    }
    curPage = [[[info objectForKey:@"feedList"]objectForKey:@"page"] intValue];
    hasNextpage = [[[info objectForKey:@"feedList"]objectForKey:@"has_next"] boolValue];
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
        [self.controller.homeTable reloadData];
    }
    if (_willRefresh) {
        [self refreshFinished];
    }else{
        [self loadingMoreFinished];
    }
}

#pragma mark - networkFailed
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
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + 44 && scrollView.contentOffset.y >= 44 && !self.controller.footView.hidden && !_isLoading) {
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
}

- (void)showLoadingMore
{
    
    UIView * view  = _controller.homeTable.tableFooterView;
    UILabel * label = (UILabel *)[view viewWithTag:100];
    UIActivityIndicatorView * acv  = (UIActivityIndicatorView *)[view viewWithTag:200];
    label.text = @"加载中...";
    [acv startAnimating];
}
- (void)loadingMore:(id)sender
{
    if (_isLoading) {
        return;
    }
    [self showLoadingMore];
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
    if (_isinit) {
        wait = [[SCPAlert_WaitView alloc] initWithImage:[UIImage imageNamed:@"pop_alert.png"] text:@"加载中..." withView:_controller.view];
        [wait show];
    }
    _isLoading = YES;
    _willRefresh = isRefresh;
    if(_willRefresh | !_dataArray.count){
        [_requestManager getUserInfoWithID:[SCPLoginPridictive currentUserId]];
    }else{
        if (MAXPICTURE <= _dataArray.count|| !hasNextpage || _isinit) {
            _isLoading = NO;
            UIView *  view = _controller.homeTable.tableFooterView;
            UILabel * label = (UILabel *)[view viewWithTag:100];
            label.text  = @"加载更多...";
            UIActivityIndicatorView * act = (UIActivityIndicatorView *)[view viewWithTag:200];
            [act stopAnimating];
            return;
        }
        [_requestManager getUserInfoFeedWithUserID:[SCPLoginPridictive currentUserId] page:curPage + 1];
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
    if (MAXPICTURE <= _dataArray.count|| !hasNextpage || _isinit) {
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
        if (_dataArray.count - 1 == indexPath.row)
            [self loadingMore:nil];
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
    UINavigationController * nav = _controller.navigationController;
    SCPPhotoDetailViewController *ctrl = [[SCPPhotoDetailViewController alloc] initWithinfo:cell.dataSource.allInfo];
    [nav pushViewController:ctrl animated:YES];
    [ctrl release];
}

-(void)feedCell:(FeedCell *)cell clickedAtPortraitView:(id)object
{
    // do nothing, cause it's personal page
//    NSLog(@"clickedAtPortraitView");
    
}

-(void)feedCell:(FeedCell *)cell clickedAtFavorButton:(id)object
{
    // do something
//    NSLog(@"clickedAtFavorButton");
}

-(void)feedCell:(FeedCell *)cell clickedAtCommentButton:(id)objectx
{
    //    UINavigationController * nav = _controller.navigationController;
    //    SCPPhotoDetailViewController *ctrl = [[SCPPhotoDetailViewController alloc] init];
    //    [nav pushViewController:ctrl animated:YES];
    //
    //    [ctrl release];
}

#pragma mark CELL - Method
- (void)MyPersonalCell:(MyPersonalCell *)cell settingClick:(id)sender
{
    SCPSetttingController * setting = [[[SCPSetttingController alloc] initWithcontroller:_controller.navigationController] autorelease];
    [_controller.navigationController presentModalViewController:setting animated:YES];
}
- (void)MyPersonalCell:(MyPersonalCell *)cell photoBookClicked:(id)sender
{
    SCPAlbumListController *alb = [[SCPAlbumListController  alloc] initWithNibName:nil bundle:nil useID:[NSString stringWithFormat:@"%@",[SCPLoginPridictive currentUserId]]];
    [alb refresh];

    [_controller.navigationController pushViewController:alb animated:YES];
    [alb release];
}
- (void)MyPersonalCell:(MyPersonalCell *)cell favoriteClicked:(id)sender
{
    
}
- (void)MyPersonalCell:(MyPersonalCell *)cell followingButtonClicked:(id)sender
{
//    NSLog(@"%s",__FUNCTION__);
    UINavigationController *nav = _controller.navigationController;
    SCPFollowingListViewController *ctrl = [[SCPFollowingListViewController alloc] initWithNibName:nil bundle:nil useID:[NSString stringWithFormat:@"%@",[SCPLoginPridictive currentUserId]]];
    [nav pushViewController:ctrl animated:YES];
    [ctrl release];
}
- (void)MyPersonalCell:(MyPersonalCell *)cell followedButtonClicked:(id)sender
{
    UINavigationController *nav = _controller.navigationController;
    SCPFollowedListViewController *ctrl = [[SCPFollowedListViewController alloc] initWithNibName:nil bundle:nil useID:[NSString stringWithFormat:@"%@",[SCPLoginPridictive currentUserId]]];
    [nav pushViewController:ctrl animated:YES];
    [ctrl release];
}

@end
