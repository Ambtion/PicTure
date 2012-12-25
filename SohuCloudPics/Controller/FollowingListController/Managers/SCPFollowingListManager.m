//
//  SCPFollowingListManager.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPFollowingListManager.h"
#import "SCPFollowingListViewController.h"

#import "SCPPersonalPageViewController.h"

@implementation SCPFollowingListManager

@synthesize controller = _controller;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_dataSource release];
    [super dealloc];
}

- (id)initWithViewController:(SCPFollowingListViewController *)ctrl useID:(NSString *)useID
{
    self = [super init];
    if (self) {
        _user_ID = [useID retain];
        _maxNum = 0;
        _isLoading = NO;
        _isinit = YES;
        _willRefresh = YES;
        hasNext = YES;
        curPage = 1;
        _controller = ctrl;
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        _requestManger  = [[SCPRequestManager alloc] init];
        _requestManger.delegate = self;
    }
    return self;
}

#pragma mark -
#pragma mark
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    
    NSDictionary * userinfo = [info objectForKey:@"userInfo"];
    if (userinfo)
        _maxNum = [[userinfo objectForKey:@"followings"] intValue];
    NSDictionary  * followings = [info objectForKey:@"Followings"];
    hasNext = [[followings  objectForKey:@"has_next"] boolValue];
    curPage = [[followings  objectForKey:@"page"] intValue];
    NSArray * followingsArray = [followings objectForKey:@"followings"];
    if (_willRefresh)
        [_dataSource removeAllObjects];
    for (int i = 0; i < followingsArray.count; i++) {
        SCPFollowCommonCellDataSource * dataSource = [[SCPFollowCommonCellDataSource alloc] init];
        NSDictionary * dic = [followingsArray objectAtIndex:i];
        dataSource.user_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]];
        dataSource.title = [dic objectForKey:@"user_nick"];
        dataSource.coverImage = [dic objectForKey:@"user_icon"];
        dataSource.pictureCount = [[dic objectForKey:@"photo_num"] intValue];
        dataSource.albumCount = [[dic objectForKey:@"public_folders"] intValue];
        dataSource.following = [[dic objectForKey:@"is_following"] boolValue];
        if ([SCPLoginPridictive currentUserId]) {
            dataSource.isMe = [dataSource.user_id isEqualToString:[SCPLoginPridictive currentUserId]];
        }else{
            dataSource.isMe = NO;
        }
        [_dataSource addObject:dataSource];
        [dataSource release];
    }
    if (_isinit) {
        _isinit = NO;
        _isLoading = NO;
        [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
    }
    if (_willRefresh) {
        [self followedRefreshDataFinishLoad];
    }else{
        [self followedMoreDataFinishLoad];
    }
}
#pragma mark - networkFailed
- (void)requestFailed:(NSString *)error
{
    UIAlertView * alterView = [[[UIAlertView alloc] initWithTitle:error message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"重试", nil] autorelease];
    [alterView show];
    [self.controller.pullingController refreshDoneLoadingTableViewData];
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
        [self followedRefreshDataFinishLoad];
    }else{
        [self followedMoreDataFinishLoad];
    }
    _willRefresh = YES;
}
#pragma mark - refresh Data
- (void)dataSourcewithRefresh:(BOOL)isRefresh
{
    _isLoading = YES;
    _willRefresh = isRefresh;
    if(_willRefresh | !_dataSource.count){
        [_requestManger getFollowingInfoWithUserID:_user_ID];
    }else{
        if (!hasNext) {
            UIAlertView * alterView = [[[UIAlertView alloc] initWithTitle:@"已达到最大" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
            [alterView show];
            [self followedMoreDataFinishLoad];
            return;
        }
        [_requestManger getfollowingsWihtUseId:_user_ID page:curPage + 1];
    }
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

- (void)pullingreloadTableViewDataSource:(id)sender
{
    [self.controller.refreshButton rotateButton];
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

- (void)pullingreloadMoreTableViewData:(id)sender
{
    [self dataSourcewithRefresh:NO];
}
- (void)followedMoreDataFinishLoad
{
    _isLoading = NO;
    [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
    [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
}

#pragma mark -
#pragma mark bannerDataSource
- (NSString*)bannerDataSouceLeftLabel
{
    return [NSString stringWithFormat:@"跟随了%d人",_maxNum];
}

- (NSString*)bannerDataSouceRightLabel
{
    return nil;
}
#pragma mark -
#pragma tableviewdataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!hasNext && !_isinit ) {
        self.controller.pullingController.footView.hidden = YES;
    }else{
        self.controller.pullingController.footView.hidden = NO;
    }
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SCPFollowCommonCell * commoncell = [tableView dequeueReusableCellWithIdentifier:@"COMMONCELL"];
    if (commoncell == nil) {
        commoncell = [[[SCPFollowCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"COMMONCELL"] autorelease];
        commoncell.delegate = self;
    }
    commoncell.dataSource = [_dataSource objectAtIndex:indexPath.row];
    return commoncell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1];
}
#pragma mark -
#pragma mark delegate For commonCell
-(void)follweCommonCell:(SCPFollowCommonCell *)cell followButton:(UIButton *)button
{
    if (![SCPLoginPridictive isLogin]) {
        SCPAlert_LoginView  * loginView = [[[SCPAlert_LoginView alloc] initWithMessage:LOGIN_HINT delegate:self] autorelease];
        [loginView show];
        return;
    }
    
    if (cell.dataSource.following) {
        [_requestManger destoryFollowing:cell.dataSource.user_id success:^(NSString *response) {
            [self dataSourcewithRefresh:YES];
            
        } failure:^(NSString *error) {
            UIAlertView * alterView = [[[UIAlertView alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alterView show];
        }];
    }else{
        [_requestManger friendshipsFollowing:cell.dataSource.user_id success:^(NSString *response) {
            [self dataSourcewithRefresh:YES];
        } failure:^(NSString *error) {
            UIAlertView * alterView = [[[UIAlertView alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alterView show];
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


-(void)follweCommonCell:(SCPFollowCommonCell *)cell followImage:(id)image
{
    SCPPersonalPageViewController * scp = [[[SCPPersonalPageViewController alloc] initWithNibName:Nil bundle:Nil useID:cell.dataSource.user_id] autorelease];    [_controller.navigationController pushViewController:scp animated:YES];
}

@end
