//
//  PhotoDetailManager.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoDetailManager.h"

#import "SCPPhotoDetailViewController.h"
#import "SCPMyHomeViewController.h"
#import "SCPPersonalPageViewController.h"
#import "SCPMenuNavigationController.h"
#import "SCPLoginPridictive.h"
#import "SCPDescriptionEditController.h"

#define N 20
#define MAXIMAGEHEIGTH 320
@implementation PhotoDetailManager

@synthesize controller = _controller;
@synthesize infoFromSuper = _infoFromSuper;
@synthesize photo_ID = _photo_ID;
@synthesize listView =  _listView;
- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_requestManger setDelegate:nil];
    [_requestManger release];
    [_dataSourceArray release];
    [_infoFromSuper release];
    [_photo_ID release];
    [_user_ID release];
    [_listView release];
    [super dealloc];
    
}
- (id)initWithController:(SCPPhotoDetailViewController *)ctrl useId:(NSString*) useId photoId:(NSString*)photoId
{
    if (self = [super init]) {
        _controller = ctrl;
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
        _requestManger = [[SCPRequestManager alloc] init];
        _requestManger.delegate = self;
        _willRefresh = YES;
        _isinit = YES;
        _user_ID = [useId retain];
        _photo_ID = [photoId retain];
    }
    return self;
}

- (id)initWithController:(SCPPhotoDetailViewController *)ctrl info:(NSDictionary*)info
{
    return [self initWithController:ctrl useId:[NSString stringWithFormat:@"%@",[info objectForKey:@"user_id"]] photoId:[NSString stringWithFormat:@"%@",[info objectForKey:@"photo_id"]]];
}
#pragma mark  Request Finished
- (CGFloat)getHeightofImage:(CGFloat)O_height :(CGFloat) O_width
{
    CGFloat finalHeigth = 0.f;
    finalHeigth = O_height * (320.f / O_width);
    if (!finalHeigth) {
        finalHeigth = 320;
    }
    return finalHeigth;
}

- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    
    if (_willRefresh){
        
        [_dataSourceArray removeAllObjects];
        self.infoFromSuper = info;
        FeedCellDataSource *fAdapter = [[FeedCellDataSource alloc] init];
        fAdapter.allInfo = self.infoFromSuper;
        fAdapter.heigth = [self getHeightofImage:[[self.infoFromSuper objectForKey:@"height"] floatValue] :[[self.infoFromSuper   objectForKey:@"width"] floatValue]];
        fAdapter.name = [self.infoFromSuper objectForKey:@"user_nick"];
        fAdapter.portrailImage = [self.infoFromSuper objectForKey:@"user_icon"];
        
        //图像信息
        fAdapter.photoImage = [self.infoFromSuper objectForKey:@"photo_url"];
        fAdapter.isGif = [[self.infoFromSuper objectForKey:@"multi_frames"] intValue];
        fAdapter.update = [self.infoFromSuper objectForKey:@"upload_at_desc"];
        numCount = [[self.infoFromSuper objectForKey:@"view_count"] intValue];
        [_dataSourceArray addObject:fAdapter];
        [fAdapter release];
        
        FeedDescriptionSource * data = [[FeedDescriptionSource alloc] init];
        data.describtion = [self.infoFromSuper objectForKey:@"photo_desc"];
        NSString * str = [NSString stringWithFormat:@"%@",[self.infoFromSuper objectForKey:@"user_id"]];
        BOOL isMe = NO;
        if ([str isEqualToString:[SCPLoginPridictive currentUserId]]) isMe = YES;
        data.isMe = isMe;
        [_dataSourceArray addObject:data];
        [data release];
    }
    if (_isinit) {
        _isinit = NO;
        _isLoading = NO;
        [self.controller.pullingController moreDoneLoadingTableViewData];
        [self.controller.pullingController refreshDoneLoadingTableViewData];
        [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
        return;
    }
    if (_willRefresh) {
        [self refreshDataFinishLoad:nil];
    }
}
#pragma networkFailed
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
    _isLoading = NO;
    _willRefresh = YES;
}

- (void)dataSourcewithRefresh:(BOOL)isRefresh
{
    _isLoading = YES;
    _willRefresh = isRefresh | _dataSourceArray.count;
    if (isRefresh || _dataSourceArray.count == 0){
        [_requestManger getPhotoDetailinfoWithUserID:_user_ID photoID:_photo_ID];
    }
}
#pragma mark Top
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
    NSLog(@"dataSourcewithRefresh");
    [self refreshData:nil];
}
- (void)refreshDataFinishLoad:(id)sender
{
    _isLoading = NO;
    [self.controller.pullingController reloadDataSourceWithAniamtion:YES];
    [(PullingRefreshController *)_controller.pullingController refreshDoneLoadingTableViewData];
}
#pragma mark More Action
//1:下拉刷新 2:刷新结束
- (void)pullingreloadMoreTableViewData:(id)sender
{
    //目前仅仅是为了初始化时候的圈圈
    [self dataSourcewithRefresh:NO];
}
- (void)moreDataFinishLoad:(id)sender
{
    _isLoading = NO;
    [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
    [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
}

#pragma mark -
#pragma mark Banner Datasouce
- (BOOL)isNULL:(id)str
{
    return !str || [str isKindOfClass:[NSNull class]] || [str isEqual:@""];
}
- (NSString*)bannerDataSouceLeftLabel
{
    if ([self isNULL:[self.infoFromSuper objectForKey:@"folder_name"]])
        return [NSString stringWithFormat:@"来自未命名专辑"];
    return [NSString stringWithFormat:@"来自%@专辑",[self.infoFromSuper objectForKey:@"folder_name"]];
}
- (NSString*)bannerDataSouceRightLabel
{
    //    return [self.controller getTimeString];
    return [NSString stringWithFormat:@"浏览数:%d",numCount];
}
#pragma mark -
#pragma mark Tableview DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isinit) {
        [self.controller.pullingController.footView setHidden:NO];
    }else{
        [self.controller.pullingController.footView setHidden:YES];
    }
    return _dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int i = indexPath.row;
    if (i == 0) {
        CGFloat height = ((FeedCellDataSource *)[_dataSourceArray objectAtIndex:0]).heigth;
        if (height < 320) {
            return 320 + 70;
        }else if(height > MAXIMAGEHEIGTH){
            return MAXIMAGEHEIGTH + 70;
        }else{
            return height + 70;
        }
    }
    if (i == 1){
        FeedDescriptionSource * data = [_dataSourceArray objectAtIndex:1];
        NSString * str = data.describtion;
        CGSize size = CGSizeZero;
        if (data.isMe) {
            size = [str sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:UILineBreakModeWordWrap];
        }else{
            size = [str sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeWordWrap];
        }
        CGFloat heigth = MAX((size.height  + 10), 30);
        return heigth;//for desc
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row == 0) {
        //./ -> View ->FeedCell(Myfavorite)
        FeedCell * picture = [tableView dequeueReusableCellWithIdentifier:@"Picture"];
        if (picture == nil){
            picture = [[[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Picture"] autorelease];
            picture.delegate = self;
            picture.maxImageHeigth = MAXIMAGEHEIGTH;
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

#pragma mark -
#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
}
#pragma mark -
#pragma mark FeedCell Method
- (void)feedCell:(FeedCell *)cell clickedAtPhoto:(id)object
{
    if ((!self.controller.navigationController.navigationBarHidden))
        [self.controller.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.listView = [[[SCPPhotoListController alloc] initWithUseInfo:self.infoFromSuper :self] autorelease];
    self.listView.delegate = self;
    
    CGRect rect = cell.frame;
    CGFloat Y = ((SCPPhotoDetailViewController *)self.controller).pullingController.tableView.contentOffset.y;
    cell.photoImageView.image = nil;
    
    if (cell.gifPlayButton.superview)
        [cell.gifPlayButton removeFromSuperview];
    rect.origin.y -= Y;
    rect.size.height -= 70;
    [self.listView showWithPushController:self.controller.navigationController fromRect:rect image:cell.photoImageView.image ImgaeRect:cell.photoImageView.frame];
}
- (void)whenViewRemveFromSuperview
{
    NSLog(@"%s %d",__FUNCTION__,[_listView retainCount]);
    self.listView  = nil;
}

#pragma mark - FeedDesDelegate
- (void)feedDescription:(FeedDescription *)feed_des DesEditClick:(id)sender
{
    [self.controller.navigationController pushViewController:[[[SCPDescriptionEditController alloc]initphoto:_photo_ID withDes:[self.infoFromSuper objectForKey:@"photo_desc"]] autorelease] animated:YES];
}
#pragma mark -
- (void)feedCell:(FeedCell *)cell clickedAtPortraitView:(id)object
{
    UINavigationController * nav = _controller.navigationController;
    if ([SCPLoginPridictive currentUserId] &&
        [_user_ID isEqualToString:[NSString stringWithFormat:@"%@",[SCPLoginPridictive currentUserId]]]) {
        SCPMyHomeViewController * myhome = [[[SCPMyHomeViewController alloc]initWithNibName:nil bundle:nil useID:[SCPLoginPridictive currentUserId]]autorelease];
        [nav pushViewController:myhome animated:YES];
        
    }else{
        SCPPersonalPageViewController *ctrl = [[SCPPersonalPageViewController alloc] initWithNibName:nil bundle:NULL useID:[NSString stringWithFormat:@"%@",[self.infoFromSuper objectForKey:@"user_id"]]];
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

- (void)feedCell:(FeedCell *)cell clickedAtCommentButton:(id)objectx
{
    
}

#pragma mark Comment Method
- (void)commentCell:(CommentCell *)cell portraitViewClickedWith:(id)object
{
    
}

#pragma mark SCPAlertView Delegate
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
    [self feedCell:nil clickedAtFavorButton:nil];
}

@end
