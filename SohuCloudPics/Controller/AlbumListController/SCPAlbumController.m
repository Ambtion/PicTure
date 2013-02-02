//
//  SCPAlbumController.m
//  SohuCloudPics
//
//  Created by Chen Chong on 12-11-14.
//
//

#import "SCPAlbumController.h"

#import "SCPAlbum.h"
#import "AlbumControllerManager.h"
#import "SCPMenuNavigationController.h"
#import "SCPPhotoGridController.h"
#import "SCPAlertView_LoginTip.h"
#import "SCPLoginPridictive.h"
#import "SCPPerfrenceStoreManager.h"
#import "SCPAlbumGridController.h"

@implementation SCPAlbumController

@synthesize user_id = _user_id;
@synthesize albumList = _albumList;
@synthesize bannerLeftString = _bannerLeftString;
@synthesize bannerRightString = _bannerRightString;
@synthesize curProgreeeView = _curProgreeeView;
@synthesize pullingController = _pullingController;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_request setDelegate:nil];
    [_request release];
	self.user_id = nil;
    self.albumList = nil;
    self.bannerLeftString = nil;
    self.bannerRightString = nil;
    self.pullingController = nil;
    self.curProgreeeView = nil;
    [_backButton release];
    [_rightBarView release];
    [_switchButton release];
    [_uploadButton release];
    [_okButton release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _state = SCPAlbumControllerStateNormal;
        _hasNextPage = NO;
		_currentPage = 0;
		_loadedPage = 0;
        isLoading = NO;
        _albumList = [[NSMutableArray alloc] init];
		_request = [[SCPRequestManager alloc] init];
		_request.delegate = self;
        isSwitch = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _pullingController = [[PullingRefreshController alloc] initWithImageName:[UIImage imageNamed:@"title_album.png"] frame:self.view.bounds];
    _pullingController.tableView.tableFooterView = nil;
    _pullingController.delegate = self;
    _pullingController.tableView.dataSource = self;
    _pullingController.headView.datasouce = self;
    _pullingController.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_pullingController.view];
	[self updateBanner];
    [self initNavigationItem];
    
    [_pullingController refreshDoneLoadingTableViewData];
    [_pullingController reloadDataSourceWithAniamtion:NO];
}
- (void)updateBanner
{
	[self.pullingController.headView BannerreloadDataSource];
}
- (void)updateBannerWithAlbumCount:(int)count andAuthorName:(NSString *)name photoNum:(NSInteger)photo_num
{
	if (count < 0) {
		count = 0;
	}
    self.bannerLeftString = [NSString stringWithFormat:@"有%d个专辑", count];
    self.bannerRightString = [NSString stringWithFormat:@"有%d张图片",photo_num];
    [self.pullingController.headView BannerreloadDataSource];
}
- (void)pullingreloadMoreTableViewData:(id)sender
{
    [self.pullingController moreDoneLoadingTableViewData];
}
- (void)initNavigationItem
{
    int rightBarWidth = 250;
    _rightBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightBarWidth, 35)];
    _rightBarView.backgroundColor = [UIColor clearColor];
    
    if ([self loginPridecate]) {
        /* switch button */
        _switchButton = [[self switchButtonView] retain];
        _switchButton.frame = CGRectMake(rightBarWidth - 70, 0, 35, 35);
        [_switchButton addTarget:self action:@selector(onSwitchClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBarView addSubview:_switchButton];
        
        /* upload button */
        _uploadButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _uploadButton.frame = CGRectMake(rightBarWidth - 35, 0, 35, 35);
        [_uploadButton setImage:[UIImage imageNamed:@"header_upload.png"] forState:UIControlStateNormal];
        [_uploadButton setImage:[UIImage imageNamed:@"header_upload_press.png"] forState:UIControlStateHighlighted];
        [_uploadButton addTarget:self action:@selector(onUploadClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBarView addSubview:_uploadButton];
        /* ok button, not added first */
        _okButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _okButton.frame = CGRectMake(rightBarWidth - 35, 0, 35, 35);
        [_okButton setImage:[UIImage imageNamed:@"header_OK.png"] forState:UIControlStateNormal];
        [_okButton setImage:[UIImage imageNamed:@"header_OK_press.png"] forState:UIControlStateHighlighted];
        [_okButton addTarget:self action:@selector(onOKClicked:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _switchButton = [[self switchButtonView] retain];
        _switchButton.frame = CGRectMake(rightBarWidth - 35, 0, 35, 35);
        [_switchButton addTarget:self action:@selector(onSwitchClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBarView addSubview:_switchButton];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_rightBarView];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    /* customize backButtonIteam */
    _backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _backButton.frame = CGRectMake(0, 0, 35, 35);
    [_backButton setImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(barButtonBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
}

- (void)refresh
{
	_hasNextPage = NO;
	_currentPage = 0;
	_loadedPage = 0;
    if (isLoading) return;
    [_request getFoldersinfoWithID:_user_id];
}

- (void)loadNextPage
{
    if (isLoading) return;
	if (_hasNextPage) {
		if (_currentPage == _loadedPage) {
            isLoading = YES;
            [_request getFoldersWithID:_user_id page:_currentPage + 1];
		}
	}
}
- (void)barButtonBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIButton *)switchButtonView
{
    /* subclasses should override this method */
    return nil;
}
- (SCPAlbumController *)switchController
{
    /* subclasses should override this method */
    return nil;
}
- (void)onSwitchClicked:(id)sender
{
    
    isSwitch = YES;
    SCPAlbumController *ctrl = [self switchController];
    if ([ctrl isKindOfClass:[SCPAlbumGridController class]]) {
        [SCPPerfrenceStoreManager setIsShowingGridView:YES];
    }else{
        [SCPPerfrenceStoreManager setIsShowingGridView:NO];
    }
	ctrl.user_id = self.user_id;
    ctrl.albumList = [NSMutableArray arrayWithArray:self.albumList];
	ctrl.bannerLeftString = self.bannerLeftString;
	ctrl.bannerRightString = self.bannerRightString;
    UINavigationController *nav = self.navigationController;
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    [nav.navigationBar.layer addAnimation:animation forKey:nil];
    [nav.view.layer addAnimation:animation forKey:nil];
    [nav popViewControllerAnimated:NO];
    [nav pushViewController:ctrl animated:NO];
    
}

- (void)onUploadClicked:(id)sender
{
    AlbumControllerManager *manager = [[AlbumControllerManager alloc] initWithpresentController:self.navigationController];
    [self.navigationController presentModalViewController:manager animated:YES];
    [manager release];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    tempRibbon = ((SCPMenuNavigationController *) self.navigationController).ribbonView;
    [((SCPMenuNavigationController *) self.navigationController).menuView setHidden:YES];
    [((SCPMenuNavigationController *) self.navigationController).ribbonView setHidden:YES];   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    //pop 则还原,qie不是switch;
    if (!self.navigationController && !isSwitch)
        [tempRibbon setHidden:NO];
}
#pragma mark -
#pragma mark SCPRequestManagerDelegate

- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
//    NSLog(@"%@",info);
    isLoading = NO;
    NSDictionary * folderinfo = [info objectForKey:@"folderinfo"];
	_currentPage = [[folderinfo objectForKey:@"page"] intValue];
	_hasNextPage = [[folderinfo objectForKey:@"has_next"] boolValue];
    _loadedPage = _currentPage;
	if (_currentPage == 1) {
		NSDictionary * creator = [info objectForKey:@"userInfo"];
		int albumCount = [[creator objectForKey:@"public_folders"] intValue];
		if ([SCPLoginPridictive currentUserId] && [[SCPLoginPridictive currentUserId] isEqualToString:_user_id]) {
			albumCount += [[creator objectForKey:@"private_folders"] intValue];
		}
		NSString * nickname = [creator objectForKey:@"user_nick"];
		[self updateBannerWithAlbumCount:albumCount andAuthorName:nickname photoNum:[[creator objectForKey:@"photo_num"] intValue]];
        if (_albumList.count)
            [_albumList removeAllObjects];
    }
    
	NSArray *folderList = [folderinfo  objectForKey:@"folders"];
	for (int i = 0; i < folderList.count; ++i) {
		NSDictionary *Afolder = [folderList objectAtIndex:i];
		SCPAlbum *album = [[SCPAlbum alloc] init];
		album.creatorId = _user_id;
		album.albumId = [NSString stringWithFormat:@"%@",[Afolder objectForKey:@"folder_id"]];
        album.coverURL = [NSString stringWithFormat:@"%@",[Afolder objectForKey:@"cover_url"]];
        album.name = [Afolder objectForKey:@"folder_name"];
        album.permission = [[Afolder objectForKey:@"is_public"] intValue];
		album.updatedAtDesc = [Afolder objectForKey:@"update_at_desc"];
		album.photoNum = [[Afolder objectForKey:@"photo_num"] intValue];
		album.viewCount = [[Afolder objectForKey:@"view_count"] intValue];
		[_albumList addObject:album];
		[album release];
	}
    
    [_pullingController refreshDoneLoadingTableViewData];
	[_pullingController reloadDataSourceWithAniamtion:NO];
    
}
- (void)requestFailed:(NSString *)error
{
    
    [self.pullingController refreshDoneLoadingTableViewData];
    [self.pullingController moreDoneLoadingTableViewData];
    
    if ([error isEqualToString:REFRESHFAILTURE]) {
        SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:@"提示信息" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [tip show];
        [tip release];
        return;
    }
    SCPAlert_CustomeView * alertView = [[[SCPAlert_CustomeView alloc] initWithTitle:error] autorelease];
    [alertView show];
}

#pragma mark -
#pragma mark BannerDataSource
- (NSString *)bannerDataSouceLeftLabel
{
    return self.bannerLeftString;
}

- (NSString *)bannerDataSouceRightLabel
{
    return self.bannerRightString;
}

#pragma mark - SCPAlbumCellDelegate
- (BOOL)loginPridecate
{
    if (![SCPLoginPridictive isLogin] || ![self.user_id isEqualToString:[NSString stringWithFormat:@"%@",[SCPLoginPridictive currentUserId]]]) {
        return NO;
    }
    return YES;
}
- (void)onImageViewClicked:(UIView *)imageView
{
    switch (_state) {
        case SCPAlbumControllerStateNormal:
        {
            /* go into the album */
            SCPAlbum *album = [_albumList objectAtIndex:imageView.tag];
            SCPPhotoGridController *ctrl = [[[SCPPhotoGridController alloc] initWithNibName:nil bundle:nil] autorelease];
            ctrl.albumData = album;
            [self.navigationController pushViewController:ctrl animated:YES];
            break;
        }
            
        case SCPAlbumControllerStateDelete:
        {
            SCPAlertView_LoginTip * loginTip = [[[SCPAlertView_LoginTip alloc] initWithTitle:@"确定要删除吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease];
            loginTip.tag = imageView.tag;
            [loginTip show];
            /* delete */
            break;
        }
        default:
            break;
    }
}
- (void)onImageViewLongPressed:(UIView *)imageView
{
    
    if (![self loginPridecate]) return;
    switch (_state) {
        case SCPAlbumControllerStateNormal:
        {
            _state = SCPAlbumControllerStateDelete;
            
            CATransition *animation = [CATransition animation];
            animation.type = kCATransitionReveal;
            animation.subtype = kCATransitionFromRight;
            animation.endProgress = 0.7;
            animation.duration = 0.2;
            [_rightBarView.layer addAnimation:animation forKey:nil];
            [_switchButton removeFromSuperview];
            [_uploadButton removeFromSuperview];
            [_rightBarView addSubview:_okButton];
            _backButton.hidden = YES;
            [_pullingController.tableView reloadData];
            
            break;
        }
        default:
            break;
    }
}

- (void)onOKClicked:(id)sender
{
    
    _state = SCPAlbumControllerStateNormal;
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    animation.startProgress = 0.3;
    animation.duration = 0.2;
    [_rightBarView.layer addAnimation:animation forKey:nil];
    [_okButton removeFromSuperview];
    [_rightBarView addSubview:_switchButton];
    [_rightBarView addSubview:_uploadButton];
    _backButton.hidden = NO;
    [_pullingController.tableView reloadData];
    
}
#pragma mark -
#pragma mark SCPAlertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView message] && [alertView.message isEqualToString:REFRESHFAILTURE]) {
        SCPMenuNavigationController * menu = (SCPMenuNavigationController *)self.navigationController;
        [menu.menuManager onExplorerClicked:nil];
        return;
    }
    if (buttonIndex == 0) return;
    SCPAlbum *album = [[_albumList objectAtIndex:alertView.tag] retain];
    [_albumList removeObjectAtIndex:alertView.tag];
    // TODO
    [[SCPUploadTaskManager currentManager] cancelOperationWithAlbumID:album.albumId];
    // delete album
    [_request deleteFolderWithUserId:_user_id folderId:album.albumId success:^(NSString *response) {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        [_pullingController.tableView.layer addAnimation:animation forKey:nil];
        [album release];
        [self refresh];
    } failure:^(NSString *error) {
        [self requestFailed:error];
        [album release];
    }];
}

#pragma mark -
#pragma mark PullingRefreshDelegate
- (void)pullingreloadPushToTop:(id)sender
{
    [self showNavigationBar];
}
- (void)pullingreloadTableViewDataSource:(id)sender
{
	[self refresh];
}

@end
