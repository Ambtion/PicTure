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
#import "SCPAppDelegate.h"

#define N 20
#define MAXIMAGEHEIGTH 320
@implementation PhotoDetailManager

@synthesize controller = _controller;
@synthesize infoFromSuper = _infoFromSuper;
@synthesize photo_ID = _photo_ID;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_dataSourceArray release];
    [_infoFromSuper release];
    [_requestManger release];
    [_photo_ID release];
    [_user_ID release];
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
    return [self initWithController:ctrl useId:[NSString stringWithFormat:@"%@",[info objectForKey:@"user_id"]] photoId:[info objectForKey:@"photo_id"]];
}

#pragma mark  Request Finished
- (CGFloat)getHeightofImage:(CGFloat)O_height :(CGFloat) O_width
{
    CGFloat finalHeigth = 0.f;
    finalHeigth = O_height * (320.f / O_width);
    //    NSLog(@"finalHeigth %f",finalHeigth);
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
        NSLog(@"%@",info);
        FeedCellDataSource *fAdapter = [[FeedCellDataSource alloc] init];
        fAdapter.allInfo = self.infoFromSuper;
        fAdapter.heigth = [self getHeightofImage:[[self.infoFromSuper objectForKey:@"height"] floatValue] :[[self.infoFromSuper   objectForKey:@"width"] floatValue]];
        fAdapter.name = [self.infoFromSuper objectForKey:@"user_nick"];
        fAdapter.portrailImage = [self.infoFromSuper objectForKey:@"user_icon"];
        //图像信息
        fAdapter.photoImage = [self.infoFromSuper objectForKey:@"photo_url"];
        fAdapter.isGif = [[self.infoFromSuper objectForKey:@"multi_frames"] intValue];
        fAdapter.update = [self.infoFromSuper objectForKey:@"upload_at_desc"];
        [_dataSourceArray addObject:fAdapter];
        [fAdapter release];
        
        FeedDescriptionSource * data = [[FeedDescriptionSource alloc] init];
        data.describtion = @"该图片无描述";
        data.bookMark = nil;
        [_dataSourceArray addObject:data];
        [data release];
    }
    if (_isinit) {
        _isinit = NO;
        _isLoading = NO;
        [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
        [self refreshDataFinishLoad:nil];
        return;
    }
    if (_willRefresh) {
        [self refreshDataFinishLoad:nil];
    }else{
        
    }
}
#pragma networkFailed
- (void)requestFailed:(ASIHTTPRequest *)mangeger
{
    UIAlertView * alterView = [[[UIAlertView alloc] initWithTitle:@"访问失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"重试", nil] autorelease];
    [alterView show];
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
    }else{
        ///.....temp
        //        for (int i = 0; i < N; ++i) {
        //            CommentCellDataSource *cAdapter = [[CommentCellDataSource alloc] init];
        //            cAdapter.name = [NSString stringWithFormat:@"冒险岛%d号", i];
        //            cAdapter.portraitImage = [UIImage imageNamed:@"portrait.png"];
        //            cAdapter.time = @"N小时前";
        //            cAdapter.content = @"我是评论 我是评论我是评论我是评论我 是评论我是评论我是评论 我是评论我是评论我是 评论我是评论我是 评论我是评论我是评论";
        //            [_dataSourceArray addObject:cAdapter];
        //        }
        //        [self performSelector:@selector(moreDataFinishLoad:) withObject:self afterDelay:1.f];
    }
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
    //    [self dataSourcewithRefresh:NO];
    [self moreDataFinishLoad:nil];
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
    return [self.controller getTimeString];
}
#pragma mark -
#pragma mark Tableview DataSource
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
        
        FeedDescriptionSource * data = [_dataSourceArray objectAtIndex: 1];
        NSString * str = data.describtion;
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(270, 1000) lineBreakMode:UILineBreakModeWordWrap];
        //        CGFloat heigth = (size.height  + 55) > 90 ? (size.height  + 55) : 90;
        CGFloat heigth = (size.height  + 10);
        return heigth;//for desc
    }
    //    CommentCellDataSource * adpter = [_dataSourceArray objectAtIndex: i];
    //    NSString * str = adpter.content;
    //    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(235, 1000) lineBreakMode:UILineBreakModeWordWrap];
    //    return size.height + 30 < 60 ? 60 : size.height + 30 + 10;
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
    if (row == 1) {
        FeedDescription* des = [tableView dequeueReusableCellWithIdentifier:@"FeedDescribtion"];
        if (des == nil)
            des = [[[FeedDescription alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FeedDescribtion"] autorelease];
        
        des.dataScoure = [_dataSourceArray objectAtIndex:row];
        return des;
    }
    CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment"];
        cell.delegate = self;
    }
    cell.dataSource = [_dataSourceArray objectAtIndex:row];
    return cell;
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
    SCPPhotoListController * listView = [[[SCPPhotoListController alloc] initWithUseInfo:self.infoFromSuper : self] autorelease];
    CGRect rect = cell.frame;
    CGFloat Y = ((SCPPhotoDetailViewController *)self.controller).pullingController.tableView.contentOffset.y;
    rect.origin.y -= Y;
    rect.size.height -= 70;
    [listView showWithPushController:self.controller.navigationController fromRect:rect image:cell.photoImageView.image ImgaeRect:cell.photoImageView.frame];
}
- (void)feedCell:(FeedCell *)cell clickedAtPortraitView:(id)object
{
    UINavigationController *nav = _controller.navigationController;
    SCPPersonalPageViewController *ctrl = [[SCPPersonalPageViewController alloc] initWithNibName:nil bundle:NULL useID:[NSString stringWithFormat:@"%@",[self.infoFromSuper objectForKey:@"user_id"]]];
    [nav pushViewController:ctrl animated:YES];
    [ctrl release];
    
}

- (void)feedCell:(FeedCell *)cell clickedAtFavorButton:(id)object
{
    
    if (![SCPLoginPridictive isLogin]) {
        SCPAlert_LoginView *alert = [[[SCPAlert_LoginView alloc] initWithMessage:LOGIN_HINT delegate:self] autorelease];
        [alert show];
        return;
    }
//    if (!cell.dataSource.ismyLike){
//        
//        [_requestManger makeUser:[SCPLoginPridictive currentUserId] likephotoWith:_user_ID :_photo_ID success:^(NSString *response) {
//            NSLog(@"%@",response);
//        }];
//    }else{
//        [_requestManger makeUser:[SCPLoginPridictive currentUserId] unLikephotoWith:_user_ID :_photo_ID success:^(NSString *response) {
//            NSLog(@"%@",response);
//        }];
//    }
}

- (void)feedCell:(FeedCell *)cell clickedAtCommentButton:(id)objectx
{
    //    if (![SCPLoginPridictive isLogin]) {
    //        SCPAlertView *alert = [[[SCPAlertView alloc] initWithMessage:LOGIN_HINT delegate:self] autorelease];
    //        [alert show];
    //        return;
    //    }
    //    [_controller displayCommentPostBar];
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
