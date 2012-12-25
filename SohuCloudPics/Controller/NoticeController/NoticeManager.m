//
//  NoticeManager.m
//  SohuCloudPics
//
//  Created by sohu on 12-11-15.
//
//

#import "NoticeManager.h"
#import "SCPPersonalPageViewController.h"

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
        [_resqust getNotificationUser];
        [self initDataSource];
    }
    return self;
}
- (void)initDataSource
{
    _isLoading = YES;
    for (int i = 0; i < 20; i++) {
        NoticeDataSource * dataSource = [[NoticeDataSource alloc] init];
        dataSource.name = @"小白的驴";
        dataSource.content = @"跟随了我";
        dataSource.upTime = [NSString stringWithFormat:@"%d小时前",rand() % 3];
        dataSource.photoUrl = @"http://10.10.68.104:8080/cloudpics/pic";
        [_dataSource addObject:dataSource];
        [dataSource release];
    }
    [self.controller.pullingController reloadDataSourceWithAniamtion:YES];
    _isLoading = NO;
}
- (void)dataSourcewithRefresh:(BOOL)isRefresh
{
    if (isRefresh)
        [_dataSource removeAllObjects];
    _isLoading = YES;
    for (int i = 0; i < 20; i++) {
    
        NoticeDataSource * dataSource = [[NoticeDataSource alloc] init];
        dataSource.name = @"小白的驴";
        dataSource.content = @"跟随了我";
        dataSource.upTime = [NSString stringWithFormat:@"%d小时前",rand() % 3];
        dataSource.photoUrl = [NSString stringWithFormat:@"http://10.10.68.104:8080/cloudpics/pic?id=%d",rand()];
        [_dataSource addObject:dataSource];
        [dataSource release];

    }
    //假设3s后刷新完成
    if (isRefresh) {
        [self performSelector:@selector(followedRefreshDataFinishLoad) withObject:nil afterDelay:1.f];
    }else{
        [self performSelector:@selector(followedMoreDataFinishLoad) withObject:nil afterDelay:1.f];
    }
}
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    NSLog(@"%@",info);
}
- (void)requestFailed:(NSString *)error
{
    NSLog(@"%@",error);
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

- (void)PullingreloadMoreTableViewData:(id)sender
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
    NSLog(@"%s",__FUNCTION__);
    [_controller.navigationController pushViewController:[[[SCPPersonalPageViewController alloc] init] autorelease] animated:YES];

}

#pragma mark - dataSouce
- (NSString *)bannerDataSouceLeftLabel
{
    return @"有20条评论";
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
    cell.dataSource = [_dataSource objectAtIndex:indexPath.row];
    return cell;
}

@end
