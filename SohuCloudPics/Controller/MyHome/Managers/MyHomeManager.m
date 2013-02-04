//
//  MyHomeManager.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import "MyHomeManager.h"

#import "SCPMyHomeController.h"

#import "SCPAlbumGridController.h"
#import "SCPPhotoDetailController.h"
#import "SCPFollowingListViewController.h"
#import "SCPFollowedListViewController.h"
#import "SCPSetttingController.h"
#import "SCPAlbumListController.h"
#import "SCPPerfrenceStoreManager.h"
#import "SCPAlertView_LoginTip.h"

#define MAXIMAGEHEIGTH 320
#define MAXPICTURE 80

static float OFFSET = 0.f;
@implementation MyHomeManager
@synthesize controller = _controller;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (_wait) {
        [_wait dismissWithClickedButtonIndex:0 animated:YES];
        [_wait release],_wait = nil;
    }
    [_requestManager setDelegate:nil];
    [_requestManager release];
    [_dataArray release];
    [_personalDataSource release];
    [_user_ID release];
    [super dealloc];
}
- (id)initWithController:(SCPMyHomeController *)ctrl useID:(NSString *)useID
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

- (void)refreshUserinfo
{
    if (_isinit || ![SCPLoginPridictive currentUserId]) return;
    [_requestManager getUserInfoWithID:[NSString stringWithFormat:@"%@",[SCPLoginPridictive currentUserId]] asy:YES success:^(NSDictionary *response) {
        _personalDataSource.isInit = NO;
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
        [_wait dismissWithClickedButtonIndex:0 animated:YES];
        [_wait release],_wait = nil;
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
    
    _curPage = [[[info objectForKey:@"feedList"]objectForKey:@"page"] intValue];
    _hasNextpage = [[[info objectForKey:@"feedList"]objectForKey:@"has_next"] boolValue];
    NSArray * photoList = [[info objectForKey:@"feedList"] objectForKey:@"feed"];
    for (int i = 0; i < photoList.count; ++i) {
        FeedCellDataSource *adapter = [[FeedCellDataSource alloc] init];
        NSDictionary * photo = [photoList objectAtIndex:i];
        adapter.allInfo = photo;
//        adapter.heigth = [self getHeightofImage:[[photo objectForKey:@"height"] floatValue] :[[photo objectForKey:@"width"] floatValue]];
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
        [_wait dismissWithClickedButtonIndex:0 animated:YES];
        [_wait release],_wait = nil;
    }
    [self restNetWorkState];
    if ([error isEqualToString:REFRESHFAILTURE]) {
        SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:@"提示信息" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [tip show];
        [tip release];
        return;
    }
    SCPAlert_CustomeView * alertView = [[[SCPAlert_CustomeView alloc] initWithTitle:error] autorelease];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SCPMenuNavigationController * menu = (SCPMenuNavigationController *)self.controller.navigationController;
    [menu.menuManager onPlazeClicked:nil];
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
        _wait = [[SCPAlert_WaitView alloc] initWithImage:[UIImage imageNamed:@"pop_alert.png"] text:@"加载中..." withView:_controller.view];
        [_wait show];
    }
    _isLoading = YES;
    _willRefresh = isRefresh;
    if(_willRefresh | !_dataArray.count){
        [_requestManager getUserInfoWithID:[SCPLoginPridictive currentUserId]];
    }else{
        if (MAXPICTURE <= _dataArray.count|| !_hasNextpage || _isinit) {
            _isLoading = NO;
            UIView *  view = _controller.homeTable.tableFooterView;
            UILabel * label = (UILabel *)[view viewWithTag:100];
            label.text  = @"加载更多...";
            UIActivityIndicatorView * act = (UIActivityIndicatorView *)[view viewWithTag:200];
            [act stopAnimating];
            return;
        }
        [_requestManager getUserInfoFeedWithUserID:[SCPLoginPridictive currentUserId] page:_curPage + 1];
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
    if (MAXPICTURE <= _dataArray.count|| !_hasNextpage || _isinit) {
        [self.controller.footView setHidden:YES];
    }else{
        [self.controller.footView setHidden:NO];
    }
    return _dataArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.row;
    if (i == 0) 
        return [_personalDataSource getheitgth];
    FeedCellDataSource * dataSource = ((FeedCellDataSource *)[_dataArray objectAtIndex:i - 1]);
    return [dataSource getHeight];
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
        }
        if (_dataArray.count > row -1)
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
    SCPPhotoDetailController * controller = [[SCPPhotoDetailController alloc] initWithUserId:
                                             [NSString stringWithFormat:@"%@",[[cell.dataSource allInfo] objectForKey:@"user_id"]] photoId:[NSString stringWithFormat:@"%@",[[cell.dataSource allInfo] objectForKey:@"photo_id"]]];
    [_controller.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)feedCell:(FeedCell *)cell clickedAtPortraitView:(id)object
{
    
}

-(void)feedCell:(FeedCell *)cell clickedAtFavorButton:(id)object
{
    
}

-(void)feedCell:(FeedCell *)cell clickedAtCommentButton:(id)objectx
{
    
}

#pragma mark CELL - Method
- (void)MyPersonalCell:(MyPersonalCell *)cell settingClick:(id)sender
{
    SCPSetttingController * setting = [[[SCPSetttingController alloc] initWithcontroller:_controller.navigationController] autorelease];
    [_controller.navigationController presentModalViewController:setting animated:YES];
}
- (void)MyPersonalCell:(MyPersonalCell *)cell photoBookClicked:(id)sender
{
    NSNumber * isShowingGrid = [SCPPerfrenceStoreManager isShowingGridView];
    if (!isShowingGrid || [isShowingGrid boolValue]) {
        SCPAlbumGridController * grid = [[[SCPAlbumGridController alloc] initWithNibName:nil bundle:nil useID:[NSString stringWithFormat:@"%@",[SCPLoginPridictive currentUserId]]] autorelease];
        [grid refresh];
        [_controller.navigationController pushViewController:grid animated:YES];
    }else{
        SCPAlbumListController *alb = [[[SCPAlbumListController  alloc] initWithNibName:nil bundle:nil useID:[NSString stringWithFormat:@"%@",[SCPLoginPridictive currentUserId]]] autorelease];
        [alb refresh];
        [_controller.navigationController pushViewController:alb animated:YES];
    }
}
- (void)MyPersonalCell:(MyPersonalCell *)cell favoriteClicked:(id)sender
{
    
}
- (void)MyPersonalCell:(MyPersonalCell *)cell followingButtonClicked:(id)sender
{
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
