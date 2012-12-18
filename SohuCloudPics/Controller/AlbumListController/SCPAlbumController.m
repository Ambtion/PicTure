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


#define PIC @"http://10.10.68.104:8080/cloudpics/pic?"



@implementation SCPAlbumController

@synthesize user_id = _user_id;
@synthesize albumList = _albumList;
@synthesize bannerLeftString = _bannerLeftString;
@synthesize bannerRightString = _bannerRightString;
@synthesize curProgreeeView = _curProgreeeView;

@synthesize pullingController = _pullingController;

- (void)dealloc
{
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
	[_request release];
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
        _albumList = [[NSMutableArray alloc] init];
		_request = [[SCPRequestManager alloc] init];
		_request.delegate = self;
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
    [self.view addSubview:_pullingController.view];
    
	[self updateBanner];
    [self initNavigationItem];

	if (_albumList.count == 0) {
		[self refresh];
	} else {
		[_pullingController.tableView reloadData];
	}
}

- (void)updateBanner
{
	[self.pullingController.headView BannerreloadDataSource];
}

- (void)updateBannerWithAlbumCount:(int)count andAuthorName:(NSString *)name
{
	if (count < 0) {
		count = 0;
	}
    self.bannerLeftString = [NSString stringWithFormat:@"有%d个相册", count];
	
	if (!name || [name isKindOfClass:[NSNull class]] || name.length == 0) {
		name = @"";
	}
    self.bannerRightString = [NSString stringWithFormat:@"作者：%@", name];
	
    [self.pullingController.headView BannerreloadDataSource];
}

- (void)initNavigationItem
{
    int rightBarWidth = 250;
    _rightBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightBarWidth, 28)];
    _rightBarView.backgroundColor = [UIColor clearColor];
    
    /* switch button */
    _switchButton = [[self switchButtonView] retain];
    _switchButton.frame = CGRectMake(rightBarWidth - 60, 0, 28, 28);
    [_switchButton addTarget:self action:@selector(onSwitchClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarView addSubview:_switchButton];
    
    /* upload button */
    _uploadButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _uploadButton.frame = CGRectMake(rightBarWidth - 30, 0, 28, 28);
    [_uploadButton setImage:[UIImage imageNamed:@"header_upload.png"] forState:UIControlStateNormal];
    [_uploadButton setImage:[UIImage imageNamed:@"header_upload_press.png"] forState:UIControlStateHighlighted];
    [_uploadButton addTarget:self action:@selector(onUploadClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarView addSubview:_uploadButton];
    
    /* ok button, not added first */
    _okButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _okButton.frame = CGRectMake(rightBarWidth - 30, 0, 28, 28);
    [_okButton setImage:[UIImage imageNamed:@"header_OK.png"] forState:UIControlStateNormal];
    [_okButton setImage:[UIImage imageNamed:@"header_OK_press.png"] forState:UIControlStateHighlighted];
    [_okButton addTarget:self action:@selector(onOKClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_rightBarView];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
    /* customize backButtonIteam */
    _backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _backButton.frame = CGRectMake(0, 0, 28, 28);
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
	[_request getFoldersWithID:_user_id page:1 yuntuToken:[SCPLoginPridictive currentUserId]];
}

- (void)loadNextPage
{
	if (_hasNextPage) {

		if (_currentPage == _loadedPage) {
			[_request getFoldersWithID:_user_id page:(_loadedPage = _currentPage + 1) yuntuToken:[SCPLoginPridictive currentUserId]];
			NSLog(@"loading page %d", _currentPage + 1);
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
    SCPAlbumController *ctrl = [self switchController];
	ctrl.user_id = self.user_id;
    ctrl.albumList = self.albumList;
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
    if (![self loginPridecate]) return;
    AlbumControllerManager *manager = [[AlbumControllerManager alloc] initWithpresentController:self.navigationController];
    [self.navigationController presentModalViewController:manager animated:YES];
    [manager release];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [((SCPMenuNavigationController *) self.navigationController).menuView setHidden:YES];
    [((SCPMenuNavigationController *) self.navigationController).ribbonView setHidden:YES];
    [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [((SCPMenuNavigationController *) self.navigationController).menuView setHidden:NO];
    [((SCPMenuNavigationController *) self.navigationController).ribbonView setHidden:NO];
	
}

- (void)viewDidUnload
{
    self.bannerLeftString = nil;
    self.bannerRightString = nil;
    self.pullingController = nil;
	
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark SCPRequestManagerDelegate
- (void)requestFailed:(ASIHTTPRequest*)mangeger
{
	NSLog(@"request Failed");
	// TODO
}

- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
	NSString *extra = [info objectForKey:@"__extra_info__"];
	if (extra && ![extra isKindOfClass:[NSNull class]] && [extra isEqualToString:@"delete"]) {
		return;
	}
	_currentPage = [[info objectForKey:@"currentPage"] intValue];
	_loadedPage = _currentPage;
	_hasNextPage = [[info objectForKey:@"hasNextPage"] boolValue];
	if (_currentPage == 1) {
		NSDictionary *creator = [info objectForKey:@"creator"];
		int albumCount = [[creator objectForKey:@"publicFolders"] intValue];
		NSString *nickname = [creator objectForKey:@"nickname"];
		[self updateBannerWithAlbumCount:albumCount andAuthorName:nickname];
		
		[_albumList removeAllObjects];
	}

	NSArray *folderList = [info objectForKey:@"folderList"];    
	for (int i = 0; i < folderList.count; ++i) {
		NSDictionary *folderInfo = [folderList objectAtIndex:i];
        
		SCPAlbum *album = [[SCPAlbum alloc] init];
		album.creatorId = _user_id;
		album.albumId = [folderInfo objectForKey:@"showId"];
		album.coverShowId = [folderInfo objectForKey:@"coverShowId"];
		NSDictionary *cover = [folderInfo objectForKey:@"cover"];
		if (cover && ![cover isKindOfClass:[NSNull class]]) {
			album.coverURL = [cover objectForKey:@"url"];
		} else {
			album.coverURL = nil;
		}
        
		album.name = [folderInfo objectForKey:@"name"];
        album.permission = [[folderInfo objectForKey:@"permission"] intValue];
		album.updatedAtDesc = [folderInfo objectForKey:@"updatedAtDesc"];
		album.photoNum = [[folderInfo objectForKey:@"photoNum"] intValue];
		album.viewCount = [[folderInfo objectForKey:@"viewCount"] intValue];
		[_albumList addObject:album];
		[album release];
	}
    
	[_pullingController.tableView reloadData];
	[_pullingController refreshDoneLoadingTableViewData];
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
    if (![SCPLoginPridictive isLogin] ) {
        UIAlertView * alte = [[[UIAlertView alloc] initWithTitle:@"请确认登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alte show];
    }
    if (![self.user_id isEqualToString:[SCPLoginPridictive currentUserId]]) {
        UIAlertView * alte = [[[UIAlertView alloc] initWithTitle:@"你无权对该相册进行操作" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alte show];
    }
    return [SCPLoginPridictive isLogin] && [self.user_id isEqualToString:[SCPLoginPridictive currentUserId]];
}
- (void)onImageViewClicked:(UIImageView *)imageView
{
    switch (_state) {
            
        case SCPAlbumControllerStateNormal:
        {
            /* go into the album */
			NSLog(@"imageView.tag = %d", imageView.tag);
            SCPAlbum *album = [_albumList objectAtIndex:imageView.tag];
            SCPPhotoGridController *ctrl = [[[SCPPhotoGridController alloc] initWithNibName:nil bundle:nil] autorelease];
            ctrl.albumData = album;
            [self.navigationController pushViewController:ctrl animated:YES];
            break;
        }
            
        case SCPAlbumControllerStateDelete:
        {
            /* delete */
            SCPAlert_LoginView *alertView = [[[SCPAlert_LoginView alloc] initWithMessage:@"确定要删除吗？" delegate:self] autorelease];
            alertView.tag = imageView.tag;
            [alertView show];
            break;
        }
        default:
            break;
    }
}
- (void)onImageViewLongPressed:(UIImageView *)imageView
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
- (void)alertViewOKClicked:(SCPAlert_LoginView *)view
{
    
    SCPAlbum *album = [[_albumList objectAtIndex:view.tag] retain];
    [_albumList removeObjectAtIndex:view.tag];
    // TODO
    [[SCPUploadTaskManager currentManager] cancelOperationWithAlbumID:album.albumId];
    // delete album
//	[_request deleteFolderWithUserId:_user_id folderId:album.albumId];
    [_request deleteFolderWithUserId:_user_id folderId:album.albumId success:^(NSString *response) {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        [_pullingController.tableView.layer addAnimation:animation forKey:nil];
        [_pullingController.tableView reloadData];
        [album release];
    }];
    
}

#pragma mark -
#pragma mark PullingRefreshDelegate
- (void)pullingreloadTableViewDataSource:(id)sender
{
	[self refresh];
}

- (void)pullingreloadMoreTableViewData:(id)sender
{
	NSLog(@"here");
	[_pullingController moreDoneLoadingTableViewData];
}

@end
