//
//  FeedListManager.m
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-29.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "FeedListManager.h"


#import "SCPMainFeedController.h"
#import "SCPPersonalPageViewController.h"
#import "SCPPhotoDetailViewController.h"


#define MAXIMAGEHEIGTH 320

#define MAXPICTURE 200
@implementation FeedListManager

@synthesize controller = _controller;
@synthesize isLoading = _isLoading;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_requestManager setDelegate:nil];
    [_requestManager release];
    [_dataArray release];
    [_LoginTip release];
    [super dealloc];
}
-(id)initWithController:(SCPMainFeedController *)controller
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        _requestManager = [[SCPRequestManager alloc] init];
        _requestManager.delegate = self;
        _willRefresh = YES;
        _isInit = YES;
        hasNextPage = YES;
        curpage = 1;
        self.controller = controller;
    }
    return self;
}

#pragma mark - requestFinished
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
    NSLog(@"%s",__FUNCTION__);
    if (_isInit || ![SCPLoginPridictive currentUserId]) return;
    [_requestManager getUserInfoWithID:[NSString stringWithFormat:@"%@",[SCPLoginPridictive currentUserId]] asy:YES success:^(NSDictionary *response) {
        NSLog(@"%@",response);
        allFollowed = [[response objectForKey:@"followings"] intValue];
        [self.controller.pullingController.headView BannerreloadDataSource];
    } failure:^(NSString *error) {
        [self requestFailed:error];
    }];
}
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    if (_willRefresh)
        [_dataArray removeAllObjects];
    
    NSDictionary * creator = [info objectForKey:@"userInfo"];
    if (creator) {
        allFollowed = [[creator objectForKey:@"followings"] intValue];
    }
    NSArray * photoList = [[info objectForKey:@"feedList"] objectForKey:@"feed"];
    hasNextPage = [[[info objectForKey:@"feedList"] objectForKey:@"has_next"] boolValue];
    curpage = [[[info objectForKey:@"feedList"] objectForKey:@"page"] intValue];
    
    for (int i = 0; i < photoList.count; ++i) {
        FeedCellDataSource *adapter = [[FeedCellDataSource alloc] init];
        NSDictionary * photo = [photoList objectAtIndex:i];
        adapter.allInfo = photo;
        adapter.heigth = [self getHeightofImage:[[photo objectForKey:@"height"] floatValue] :[[photo objectForKey:@"width"] floatValue]];
        adapter.name = [photo objectForKey:@"user_nick"];
        adapter.update = [photo objectForKey:@"upload_at_desc"];
        adapter.portrailImage = [photo objectForKey:@"user_icon"];
        adapter.photoImage  = [photo objectForKey:@"photo_url"];
        [_dataArray addObject:adapter];
        [adapter release];
    }
    if (_isInit) {
        _isInit = NO;
        _isLoading = NO;
        [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
        [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
        [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
        return;
    }
    if (_willRefresh) {
        [self feedRefreshDataFinishLoad];
    }else{
        [self feedMoreDataFinishLoad];
    }    
}

#pragma Network Failed
- (void)requestFailed:(NSString *)error
{
    SCPAlert_CustomeView * alertView = [[[SCPAlert_CustomeView alloc] initWithTitle:error] autorelease];
    [alertView show];
    [self restNetWorkState];
}
- (void)restNetWorkState
{
    if (_willRefresh) {
        [(PullingRefreshController *)_controller.pullingController refreshDoneLoadingTableViewData];
    }else{
        [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
    }
    _willRefresh = YES;
    _isLoading = NO;
}
#pragma mark -

- (void)dataSourcewithRefresh:(BOOL)isRefresh
{
    if (![SCPLoginPridictive isLogin]) {
        if (isRefresh) {
            [self feedRefreshDataFinishLoad];
        }else{
            [self feedMoreDataFinishLoad];
        }
        [self showViewForNoLogin];
        return;
    }
    _isLoading = YES;
    _willRefresh = isRefresh;
    if(isRefresh || !_dataArray.count){
        [_requestManager getFeedMineInfo];
    }else{
        if ((MAXPICTURE < _dataArray.count || !hasNextPage)&&  !_isInit){
            _isLoading = NO;
            [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
            return;
        }
        [_requestManager getFeedMineWithPage:curpage + 1];
    }
}
#pragma mark Top
- (void)pullingreloadPushToTop:(id)sender
{
    [self.controller showNavigationBar];
}
#pragma mark Refresh Action
//1:下拉刷新 2:刷新结束
- (void)refreshData:(id)sender
{
    if (_isLoading)  return;
    [self dataSourcewithRefresh:YES];
}
- (void)pullingreloadTableViewDataSource:(id)sender
{
    
    SCPBaseNavigationItem * item = self.controller.item;
    [item.refreshButton rotateButton];
    [self refreshData:nil];
}
- (void)feedRefreshDataFinishLoad
{
    _isLoading = NO;
    [(PullingRefreshController *)_controller.pullingController refreshDoneLoadingTableViewData];
    [self.controller.pullingController reloadDataSourceWithAniamtion:YES];
    
}

#pragma mark More Action
//更多
- (void)pullingreloadMoreTableViewData:(id)sender
{
    [self dataSourcewithRefresh:NO];
}
- (void)feedMoreDataFinishLoad
{
    _isLoading = NO;
    [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
    [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
}
#pragma mark -
#pragma mark No LoginView
- (void)showViewForNoLogin
{
    if (_LoginTip == nil) {
        _LoginTip = [[LoginTipView alloc] initWithFrame:_controller.pullingController.view.bounds];
        [_LoginTip addtarget:self action:@selector(tipForLogin:)];
    }
    if (_LoginTip.superview == nil) {
        [_controller.pullingController.view addSubview: _LoginTip];
        [self.controller.pullingController.tableView.tableFooterView setHidden:YES];
    }
}
- (void)dismissLogin
{
    if (_LoginTip.superview) {
        [_LoginTip removeFromSuperview];
        [self.controller.pullingController.tableView.tableFooterView setHidden:NO];
    }
}
- (void)tipForLogin:(UIButton*)button
{
    SCPLoginViewController * lvc = [[[SCPLoginViewController alloc] init] autorelease];
    lvc.delegate = self;
    UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:lvc] autorelease];
    [_controller presentModalViewController:nav animated:YES];
}
- (void)SCPLogin:(SCPLoginViewController *)LoginController doLogin:(UIButton *)button
{
    
    [self dismissLogin];
    //for temp  remove data
    [_controller dismissModalViewControllerAnimated:YES];
}

- (void)SCPLogin:(SCPLoginViewController *)LoginController cancelLogin:(UIButton *)button
{
    [_controller dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Banner Datasouce

- (NSString*)bannerDataSouceLeftLabel
{
    if (![SCPLoginPridictive isLogin]) {
        return nil;
    }
    return [NSString stringWithFormat:@"跟随了%d人",allFollowed];
}
- (NSString*)bannerDataSouceRightLabel
{
//    return [self.controller getTimeString];
    return nil;
}
#pragma mark -

#pragma mark Table Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ((MAXPICTURE < _dataArray.count || !hasNextPage)&&  !_isInit) {
        [self.controller.pullingController.footView setHidden:YES];
    }else{
        [self.controller.pullingController.footView setHidden:NO];
    }
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.row;
    CGFloat height = ((FeedCellDataSource *)[_dataArray objectAtIndex:i]).heigth;
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
    
    FeedCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FeedListCell"];
    if (!cell) {
        cell = [[[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FeedListCell"] autorelease];
        cell.delegate = self;
        cell.maxImageHeigth = MAXIMAGEHEIGTH;
    }
    cell.dataSource = [_dataArray objectAtIndex:indexPath.row];

    if (_dataArray.count - 1 == indexPath.row )
        [self.controller.pullingController realLoadingMore:nil];
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1];
}

#pragma mark -
#pragma mark Cell Do Action

- (void)feedCell:(FeedCell *)cell clickedAtPhoto:(id)object
{
    NSLog(@"feedCell: %@",cell.dataSource.allInfo);
    SCPPhotoDetailViewController *controller = [[SCPPhotoDetailViewController alloc] initWithinfo:cell.dataSource.allInfo];
    [_controller.navigationController pushViewController:controller animated:YES];
    [controller release];
}
- (void)feedCell:(FeedCell *)cell clickedAtPortraitView:(id)object
{
    // do nothing for it mainfeedPage
    NSString * user_id = [NSString stringWithFormat:@"%@",[cell.dataSource.allInfo objectForKey:@"user_id"]];
    SCPPersonalPageViewController *controller = [[SCPPersonalPageViewController alloc] initWithNibName:nil bundle:nil useID:user_id];
    [_controller.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

-(void)feedCell:(FeedCell *)cell clickedAtFavorButton:(id)object
{
    // do something
}

-(void)feedCell:(FeedCell *)cell clickedAtCommentButton:(id)objectx
{
//    SCPPhotoDetailViewController *controller = [[SCPPhotoDetailViewController alloc] initWithinfo:cell.dataSource.allInfo];
//    [_controller.navigationController pushViewController:controller animated:YES];
//    [controller release];
}

@end
