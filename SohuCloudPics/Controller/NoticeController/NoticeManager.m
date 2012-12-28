//
//  NoticeManager.m
//  SohuCloudPics
//
//  Created by sohu on 12-11-15.
//
//

#import "NoticeManager.h"
#import "SCPPersonalPageViewController.h"
#import "SCPFollowingListViewController.h"

@implementation NoticeManager
@synthesize controller = _controller;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_dataSource release];
    [_resqust release];
    [super dealloc];
}

- (id)initWithViewController:(NoticeViewController *)ctrl
{
    self = [super init];
    if (self) {
        _isLoading = NO;
        _controller = ctrl;
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        _resqust = [[SCPRequestManager alloc] init];
        _resqust.delegate = self;
//        [self dataSourcewithRefresh:YES];
    }
    return self;
}

- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    [_dataSource removeAllObjects];
    numFollowing = [[info objectForKey:@"followed"] intValue];
    NSLog(@"numFollowing %d",numFollowing);
    [_resqust getUserInfoWithID:[SCPLoginPridictive currentUserId] success:^(NSDictionary *response) {
        if (numFollowing != 0) {
            NoticeDataSource * dataSouce =  [[NoticeDataSource alloc] init];
            dataSouce.name = [response objectForKey:@"user_nick"];
            dataSouce.content = [NSString stringWithFormat:@"有%d个人跟随了我",numFollowing];
            dataSouce.photoUrl = [response objectForKey:@"user_icon"];
            [_dataSource addObject:dataSouce];
            [dataSouce release];
        }
        
        NoticeDataSource * dataSouces =  [[NoticeDataSource alloc] init];
        dataSouces.name = @"系统管理员";
        dataSouces.content = @"最新版本敬请期待";
        dataSouces.image = [UIImage imageNamed:@"systerm.png"];
        [_dataSource addObject:dataSouces];
        [dataSouces release];
        
        [self.controller.pullingController refreshDoneLoadingTableViewData];
        [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
        
    } failure:^(NSString *error) {
        
    }];
  
}
#pragma Network Failed
- (void)requestFailed:(NSString *)error
{
    SCPAlert_CustomeView * alertView = [[[SCPAlert_CustomeView alloc] initWithTitle:error] autorelease];
    [alertView show];
    [self restNetWorkState];
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex != 0) {
//        [self dataSourcewithRefresh:YES];
//    }else{
//        [self restNetWorkState];
//    }
//}
- (void)restNetWorkState
{
    [(PullingRefreshController *)_controller.pullingController refreshDoneLoadingTableViewData];
    _isLoading = NO;
}
#pragma mark -

- (void)dataSourcewithRefresh:(BOOL)isRefresh
{
    _isLoading = YES;
    [_resqust getNotificationUser];
}
#pragma mark - dataChange
#pragma mark refresh
//1 点击 2 下拉 3 结束
- (void)refreshData:(id)sender
{
    if (_isLoading) {
        return;
    }
    [self dataSourcewithRefresh:YES];
}

- (void)PullingreloadTableViewDataSource:(EGORefreshTableHeaderView *)refreshView
{
    [self refreshData:nil];
}

- (void)followedRefreshDataFinishLoad
{
    _isLoading = NO;
    [(PullingRefreshController *)_controller.pullingController refreshDoneLoadingTableViewData];
    [self.controller.pullingController reloadDataSourceWithAniamtion:YES];
}
#pragma mark more
//1:下拉刷新 2:刷新结束
- (void)pullingreloadTableViewDataSource:(id)sender
{
    [self dataSourcewithRefresh:NO];
}
- (void)followedMoreDataFinishLoad
{
    _isLoading = NO;
    [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
    [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
}
#pragma mark - action
- (BOOL)isLogin
{
    if (![SCPLoginPridictive isLogin]) {
        UIAlertView * ale = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [ale show];
        [ale release];
        
    }
    return [SCPLoginPridictive isLogin];
}
-(void)NoticeViewCell:(NoticeViewCell *)cell portraitClick:(id)sender
{
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1 || _dataSource.count == 1) {
        return;
    }
    if (![self isLogin]) {
        return;
    }
    [_resqust destoryNotificationAndsuccess:^(NSString *response) {
        NSLog(@"%s",__FUNCTION__);
        UINavigationController *nav = _controller.navigationController;
        SCPFollowingListViewController *ctrl = [[SCPFollowingListViewController alloc] initWithNibName:nil bundle:nil useID:[NSString stringWithFormat:@"%@",[SCPLoginPridictive currentUserId]]];
        [nav pushViewController:ctrl animated:YES];
        [ctrl release];
    } failure:^(NSString *error) {
        [self requestFailed:error];
    }];
}
#pragma mark - dataSouce
- (NSString *)bannerDataSouceLeftLabel
{
    return @"我有新的提醒";
}
- (NSString *)bannerDataSouceRightLabel
{
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str = @"CELL";
    NoticeViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NoticeViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.delegate = self;
    }
//    NSLog(@"%@",((NoticeDataSource *)[_dataSource objectAtIndex:1]).name);
    cell.dataSource = [_dataSource objectAtIndex:indexPath.row];
  
    return cell;
}

@end
