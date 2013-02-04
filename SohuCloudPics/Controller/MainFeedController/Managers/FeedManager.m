//
//  FeedListManager.m
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-29.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "FeedManager.h"


#import "SCPFeedController.h"
#import "SCPPersonalHomeController.h"
#import "SCPPhotoDetailController.h"
#import "SCPAlertView_LoginTip.h"
#import "SCPAlert_CustomeView.h"

#define MAXPICTURE 80

@implementation FeedManager


@synthesize controller = _controller;
@synthesize isLoading = _isLoading;
@synthesize dataArray = _dataArray;
- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_requestManager setDelegate:nil];
    [_requestManager release];
    [_dataArray release];
    [_LoginTip release];
    [super dealloc];
}
-(id)initWithController:(SCPFeedController *)controller
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

- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    if (_willRefresh)
        [_dataArray removeAllObjects];
    
    NSDictionary * creator = [info objectForKey:@"userInfo"];
    if (creator) {
        _allFollowed = [[creator objectForKey:@"followings"] intValue];
    }
    NSArray * photoList = [[info objectForKey:@"feedList"] objectForKey:@"feed"];
    hasNextPage = [[[info objectForKey:@"feedList"] objectForKey:@"has_next"] boolValue];
    curpage = [[[info objectForKey:@"feedList"] objectForKey:@"page"] intValue];
    
    for (int i = 0; i < photoList.count; ++i) {
        FeedCellDataSource *adapter = [[FeedCellDataSource alloc] init];
        NSDictionary * photo = [photoList objectAtIndex:i];
        adapter.allInfo = photo;
        adapter.name = [photo objectForKey:@"user_nick"];
        adapter.update = [photo objectForKey:@"upload_at_desc"];
        adapter.portrailImage = [photo objectForKey:@"user_icon"];
        adapter.photoImage  = [photo objectForKey:@"photo_url"];
        [_dataArray addObject:adapter];
        [adapter release];
    }
    if (_isInit) {
        [self reloadWhenInit];
        return;
    }
    if (_willRefresh ) {
        [self feedRefreshDataFinishLoad];
    }else{
        [self feedMoreDataFinishLoad];
    }
}
- (void)reloadWhenInit
{
    _isInit = NO;
    _isLoading = NO;
    [(PullingRefreshController *)_controller.pullingController refreshDoneLoadingTableViewData];
    [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
    [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
}
#pragma Network Failed
- (void)requestFailed:(NSString *)error
{
    [self restNetWorkState];
    if ([error isEqualToString:REFRESHFAILTURE]) {
        SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:@"提示信息" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [tip show];
        [tip release];
        return;
    }
    if (![SCPLoginPridictive isLogin]) return;
    SCPAlert_CustomeView * alertView = [[[SCPAlert_CustomeView alloc] initWithTitle:error] autorelease];
    [alertView show];
}
- (void)restNetWorkState
{
    [(PullingRefreshController *)_controller.pullingController refreshDoneLoadingTableViewData];
    [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
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
        if ((MAXPICTURE <= _dataArray.count || !hasNextPage)&&  !_isInit){
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
    
    SCPBaseNavigationItemView * item = self.controller.item;
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
    if (![SCPLoginPridictive isLogin]) return nil;
    return [NSString stringWithFormat:@"关注了%d人",_allFollowed];
}
#pragma mark -

#pragma mark Table Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ((MAXPICTURE <= _dataArray.count || !hasNextPage)&&  !_isInit) {
        [self.controller.pullingController.footView setHidden:YES];
    }else{
        [self.controller.pullingController.footView setHidden:NO];
    }
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.row;
    FeedCellDataSource * dataSource = ((FeedCellDataSource *)[_dataArray objectAtIndex:i]);
    return [dataSource getHeight];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FeedCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FeedListCell"];
    if (!cell) {
        cell = [[[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FeedListCell"] autorelease];
        cell.delegate = self;
    }
    
    if (_dataArray.count > indexPath.row)
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
    SCPPhotoDetailController * controller = [[SCPPhotoDetailController alloc] initWithUserId:
                                            [NSString stringWithFormat:@"%@",[[cell.dataSource allInfo] objectForKey:@"user_id"]] photoId:[NSString stringWithFormat:@"%@",[[cell.dataSource allInfo] objectForKey:@"photo_id"]]];
    [_controller.navigationController pushViewController:controller animated:YES];
    [controller release];
}
- (void)feedCell:(FeedCell *)cell clickedAtPortraitView:(id)object
{
    // do nothing for it mainfeedPage
    NSString * user_id = [NSString stringWithFormat:@"%@",[cell.dataSource.allInfo objectForKey:@"user_id"]];
    SCPPersonalHomeController *controller = [[SCPPersonalHomeController alloc] initWithNibName:nil bundle:nil useID:user_id];
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
