//
//  NoticeManager.m
//  SohuCloudPics
//
//  Created by sohu on 12-11-15.
//
//

#import "NoticeManager.h"
#import "SCPPersonalPageViewController.h"
#import "SCPFollowedListViewController.h"
#import "SCPAlertView_LoginTip.h"

@implementation NoticeManager
@synthesize controller = _controller;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_resqust setDelegate:nil];
    [_resqust release];
    [_dataSource release];
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
    }
    return self;
}
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
//    NSLog(@"notication:info %@",info);
    [_dataSource removeAllObjects];
    numFollowing = [[info objectForKey:@"followed"] intValue];
    _isLoading = NO;
    NoticeDataSource * dataSouce =  [[NoticeDataSource alloc] init];
    dataSouce.name = @"新增粉丝提醒";
    dataSouce.content = [NSString stringWithFormat:@"有%d个人关注了我",numFollowing];
    [_dataSource addObject:dataSouce];
    [dataSouce release];
    [self.controller.pullingController refreshDoneLoadingTableViewData];
    [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
}
#pragma Network Failed
- (void)requestFailed:(NSString *)error
{
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
-(void)NoticeViewCell:(NoticeViewCell *)cell portraitClick:(id)sender
{
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_resqust destoryNotificationAndsuccess:^(NSString *response) {
        UINavigationController *nav = _controller.navigationController;
        SCPFollowedListViewController *ctrl = [[SCPFollowedListViewController alloc] initWithNibName:nil bundle:nil useID:[NSString stringWithFormat:@"%@",[SCPLoginPridictive currentUserId]]];
        [nav pushViewController:ctrl animated:YES];
        [ctrl release];
    } failure:^(NSString *error) {
        [self requestFailed:error];
    }];
}
#pragma mark - dataSouce
- (NSString *)bannerDataSouceLeftLabel
{
    if (numFollowing)
        return [NSString stringWithFormat:@"有%d条提醒",numFollowing];
    return @"暂无提醒";
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
    if (!numFollowing) return 0;
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
    cell.dataSource = [_dataSource objectAtIndex:indexPath.row];
  
    return cell;
}

@end
