//
//  PhotoDetailManager.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoDetailManager.h"

#import "SCPPhotoDetailController.h"
#import "SCPMyHomeController.h"
#import "SCPPersonalHomeController.h"
#import "SCPMenuNavigationController.h"
#import "SCPLoginPridictive.h"
#import "PhotoDesEditController.h"

@implementation PhotoDetailManager
@synthesize controller = _controller;
@synthesize imageInfo = _imageInfo;
@synthesize photo_ID = _photo_ID;
@synthesize listView =  _listView;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_requestManger setDelegate:nil];
    [_requestManger release];
    [_dataSourceArray release];
    [_imageInfo release];
    [_photo_ID release];
    [_user_ID release];
    [_listView release];
    [super dealloc];
}

- (id)initWithController:(SCPPhotoDetailController *)ctrl UserId:(NSString*) userId PhotoId:(NSString*)photoId
{
    if (self = [super init]) {
        _controller = ctrl;
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
        _requestManger = [[SCPRequestManager alloc] init];
        _requestManger.delegate = self;
        _isRefeshing = YES;
        _isinit = YES;
        _user_ID = [userId retain];
        _photo_ID = [photoId retain];
    }
    return self;
}

#pragma mark  Request Finished
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    if (_isRefeshing){
        [_dataSourceArray removeAllObjects];
        self.imageInfo = info;
        FeedCellDataSource *fAdapter = [[FeedCellDataSource alloc] init];
        fAdapter.allInfo = self.imageInfo;
        fAdapter.offset = 0;
        fAdapter.name = [self.imageInfo objectForKey:@"user_nick"];
        fAdapter.portrailImage = [self.imageInfo objectForKey:@"user_icon"];
        
        //图像信息
        fAdapter.photoImage = [self.imageInfo objectForKey:@"photo_url"];
        fAdapter.isGif = [[self.imageInfo objectForKey:@"multi_frames"] intValue];
        fAdapter.update = [self.imageInfo objectForKey:@"upload_at_desc"];
        numCount = [[self.imageInfo objectForKey:@"view_count"] intValue];
        [_dataSourceArray addObject:fAdapter];
        [fAdapter release];
        
        FeedDescriptionSource * data = [[FeedDescriptionSource alloc] init];
        data.describtion = [self.imageInfo objectForKey:@"photo_desc"];
        NSString * str = [NSString stringWithFormat:@"%@",[self.imageInfo objectForKey:@"user_id"]];
        BOOL isMe = NO;
        if ([str isEqualToString:[SCPLoginPridictive currentUserId]]) isMe = YES;
        data.isMe = isMe;
        [_dataSourceArray addObject:data];
        [data release];
    }
    [self refreshDataFinishLoad:nil];
}

#pragma Request failed
- (void)requestFailed:(NSString *)error
{
    SCPAlert_CustomeView * alertView = [[[SCPAlert_CustomeView alloc] initWithTitle:error] autorelease];
    [alertView show];
    [self restNetWorkState];
}

- (void)restNetWorkState
{
    if (_isRefeshing) {
        [(PullingRefreshController *)_controller.pullingController refreshDoneLoadingTableViewData];
    }else{
        [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
    }
    _isLoading = NO;
    _isRefeshing = YES;
}

- (void)dataSourcewithRefresh:(BOOL)isRefresh
{
    _isLoading = YES;
    _isRefeshing = isRefresh | _dataSourceArray.count;
    if (isRefresh || _dataSourceArray.count == 0)
        [_requestManger getPhotoDetailinfoWithUserID:_user_ID photoID:_photo_ID];
}

#pragma mark - PullingDelegate
- (void)pullingreloadPushToTop:(id)sender
{
    [self.controller showNavigationBar];
}

#pragma mark Refresh Action
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
    [self refreshData:nil];
}

- (void)refreshDataFinishLoad:(id)sender
{
    _isLoading = NO;
    [self.controller.pullingController reloadDataSourceWithAniamtion:YES];
    [(PullingRefreshController *)_controller.pullingController refreshDoneLoadingTableViewData];
}

#pragma mark More Action
- (void)pullingreloadMoreTableViewData:(id)sender
{
    [self dataSourcewithRefresh:NO];
}

- (void)moreDataFinishLoad:(id)sender
{
    _isLoading = NO;
    [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
    [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
}

#pragma mark - Banner Datasouce
- (NSString*)bannerDataSouceLeftLabel
{
    if (self.imageInfo) {
        return [NSString stringWithFormat:@"%@",[self.imageInfo objectForKey:@"folder_name"]];
    }else{
        return nil;
    }
}

- (NSString*)bannerDataSouceRightLabel
{
    return [NSString stringWithFormat:@"浏览数:%d",numCount];
}

#pragma mark - Tableview DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int i = indexPath.row;
    if (i == 0) {
        FeedCellDataSource * dataSource = ((FeedCellDataSource *)[_dataSourceArray objectAtIndex:0]);
        return [dataSource getHeight];
    }
    if (i == 1){
        FeedDescriptionSource * data = [_dataSourceArray objectAtIndex:1];
        return [data getHeigth];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row == 0) {
        FeedCell * picture = [tableView dequeueReusableCellWithIdentifier:@"Picture"];
        if (picture == nil){
            picture = [[[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Picture"] autorelease];
            picture.delegate = self;
        }
        picture.dataSource = [_dataSourceArray objectAtIndex:row];
        return picture;
    }
    
    FeedDescription* des = [tableView dequeueReusableCellWithIdentifier:@"FeedDescribtion"];
    if (des == nil){
        des = [[[FeedDescription alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FeedDescribtion"] autorelease];
        des.delegate = self;
    }
    des.dataScoure = [_dataSourceArray objectAtIndex:row];
    return des;
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
}

#pragma mark - FeedCell Method
- (void)feedCell:(FeedCell *)cell clickedAtPhoto:(id)object
{
    if ((!self.controller.navigationController.navigationBarHidden))
        [self.controller.navigationController setNavigationBarHidden:YES animated:YES];
    self.listView = [[[SCPPhotoListController alloc] initWithUseInfo:self.imageInfo :self] autorelease];
    self.listView.delegate = self;    
    CGRect rect = cell.frame;
    CGFloat Y = ((SCPPhotoDetailController *)self.controller).pullingController.tableView.contentOffset.y;
    cell.photoImageView.image = nil;
    if (cell.gifPlayButton.superview)
        [cell.gifPlayButton removeFromSuperview];
    rect.origin.y -= Y;
    rect.size.height -= 70;
    [self.listView showPhotoListScreen];
}

- (void)photoListController:(SCPPhotoListController *)listController viewdidRemoveFromSuperView:(UIView *)view
{
    //when list remove from supview
    self.listView  = nil;
}

#pragma mark - FeedDesDelegate
- (void)feedDescription:(FeedDescription *)feed_des DesEditClick:(id)sender
{
    PhotoDesEditController * des  = [[[PhotoDesEditController alloc] initphoto:_photo_ID withDes:[self.imageInfo objectForKey:@"photo_desc"]] autorelease];
    [self.controller.navigationController pushViewController:des animated:YES];
}

#pragma mark - FeedClick
- (void)feedCell:(FeedCell *)cell clickedAtPortraitView:(id)object
{
    UINavigationController * nav = _controller.navigationController;
    if ([SCPLoginPridictive currentUserId] &&
        [_user_ID isEqualToString:[NSString stringWithFormat:@"%@",[SCPLoginPridictive currentUserId]]]) {
        SCPMyHomeController * myhome = [[[SCPMyHomeController alloc]initWithNibName:nil bundle:nil useID:[SCPLoginPridictive currentUserId]]autorelease];
        [nav pushViewController:myhome animated:YES];
    }else{
        SCPPersonalHomeController *ctrl = [[SCPPersonalHomeController alloc] initWithNibName:nil bundle:NULL useID:[NSString stringWithFormat:@"%@",[self.imageInfo objectForKey:@"user_id"]]];
        [nav pushViewController:ctrl animated:YES];
        [ctrl release];
    }
}

- (void)feedCell:(FeedCell *)cell clickedAtFavorButton:(id)object
{
    if (![SCPLoginPridictive isLogin]) {
        SCPAlert_LoginView *alert = [[[SCPAlert_LoginView alloc] initWithMessage:LOGIN_HINT delegate:self] autorelease];
        [alert show];
        return;
    }
}

#pragma mark -  SCPAlertView Delegate
- (void)alertViewOKClicked:(SCPAlert_LoginView *)view
{
    SCPLoginViewController *loginCtrl = [[SCPLoginViewController alloc] init];
    loginCtrl.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginCtrl];
    [self.controller presentModalViewController:nav animated:YES];
    [loginCtrl release];
    [nav release];
}

- (void)login:(SCPLoginViewController *)LoginController cancelLogin:(UIButton *)button
{
    [self.controller dismissModalViewControllerAnimated:YES];
}

- (void)login:(SCPLoginViewController *)LoginController doLogin:(UIButton *)button
{
    [self.controller dismissModalViewControllerAnimated:YES];
    [self feedCell:nil clickedAtFavorButton:nil];
}
@end
