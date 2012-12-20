//
//  SCPPhotoGridController.m
//  SohuCloudPics
//
//  Created by Yingxue Peng on 12-9-24.
//  Copyright (c) 2012年 Sohu.com. All rights reserved.
//

#import "SCPPhotoGridController.h"

#import <QuartzCore/QuartzCore.h>

#import "SCPMenuNavigationController.h"
#import "SCPPhotoGridCell.h"
#import "SCPPhoto.h"
#import "SCPPhotoDetailViewController.h"

#import "SCPUploadTaskManager.h"

@implementation SCPPhotoGridController

@synthesize albumData = _albumData;
@synthesize photoList = _photoList;
@synthesize uploadTaskList = _uploadTaskList;
@synthesize thumbnailArray = _thumbnailArray;

@synthesize bannerLeftString = _bannerLeftString;
@synthesize bannerRightString = _bannerRightString;
@synthesize pullingController = _pullingController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _tasksToDel = [[NSMutableSet alloc] init];
        _imagesToDel = [[NSMutableSet alloc] init];
		_request = [[SCPRequestManager alloc] init];
        _thumbnailArray = [[NSMutableArray arrayWithCapacity:0] retain];
		_request.delegate = self;
    }
    return self;
}
- (void)dealloc
{
    self.albumData = nil;
    self.photoList = nil;
    self.thumbnailArray = nil;
    self.bannerLeftString = nil;
    self.bannerRightString = nil;
    self.pullingController = nil;
    [_tasksToDel release];
    [_imagesToDel release];
    [_backButton release];
    [_rightBarView release];
    [_iMarkButton release];
    [_trashButton release];
    [_penButton release];
    [_okButton release];
    [_cancelButton release];
	[_request release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_pullingController = [[PullingRefreshController alloc] initWithLabelName:_albumData.name frame:self.view.bounds];
	_pullingController.tableView.tableFooterView = nil;
    _pullingController.delegate = self;
    _pullingController.tableView.dataSource = self;
    _pullingController.headView.datasouce = self;
    [self.view addSubview:_pullingController.view];
    [self initNavigationItem];
    
}

- (void)initNavigationItem
{
    /* customize backButtonItem */
    _backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _backButton.frame = CGRectMake(0, 0, 28, 28);
    [_backButton setImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(barButtonBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    
    /* customize rightBarItems */
    int rightBarWidth = 250;
    _rightBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightBarWidth, 28)];
    _rightBarView.backgroundColor = [UIColor clearColor];
    /* iMark button */
    _iMarkButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _iMarkButton.frame = CGRectMake(rightBarWidth - 94 - 10, 0, 28, 28);
    [_iMarkButton setImage:[UIImage imageNamed:@"header_info.png"] forState:UIControlStateNormal];
    [_iMarkButton setImage:[UIImage imageNamed:@"header_info_press.png"] forState:UIControlStateHighlighted];
    [_iMarkButton addTarget:self action:@selector(oniMarkClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarView addSubview:_iMarkButton];
    /* trash button */
    _trashButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _trashButton.frame = CGRectMake(rightBarWidth - 62 - 5, 0, 28, 28);
    [_trashButton setImage:[UIImage imageNamed:@"header_delete.png"] forState:UIControlStateNormal];
    [_trashButton setImage:[UIImage imageNamed:@"header_delete_press.png"] forState:UIControlStateHighlighted];
    [_trashButton addTarget:self action:@selector(onTrashClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarView addSubview:_trashButton];
    /* pen button */
    _penButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _penButton.frame = CGRectMake(rightBarWidth - 30, 0, 28, 28);
    [_penButton setImage:[UIImage imageNamed:@"header_edit.png"] forState:UIControlStateNormal];
    [_penButton setImage:[UIImage imageNamed:@"header_edit_press.png"] forState:UIControlStateHighlighted];
    [_penButton addTarget:self action:@selector(onPenClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarView addSubview:_penButton];
    /* ok button, not added first */
    _okButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _okButton.frame = CGRectMake(rightBarWidth - 30, 0, 28, 28);
    [_okButton setImage:[UIImage imageNamed:@"header_OK.png"] forState:UIControlStateNormal];
    [_okButton setImage:[UIImage imageNamed:@"header_OK_press.png"] forState:UIControlStateHighlighted];
    [_okButton addTarget:self action:@selector(onDeleteOKClicked:) forControlEvents:UIControlEventTouchUpInside];
    /* cancel button, not added first */
    _cancelButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _cancelButton.frame = CGRectMake(0, 0, 28, 28);
    [_cancelButton setImage:[UIImage imageNamed:@"header_cancel_normal.png"] forState:UIControlStateNormal];
    [_cancelButton setImage:[UIImage imageNamed:@"header_cancel_press.png"] forState:UIControlStateHighlighted];
    [_cancelButton addTarget:self action:@selector(onDeleteCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarView];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [rightBarItem release];
}

- (void)barButtonBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    self.uploadTaskList = nil;
    self.pullingController = nil;
    self.bannerLeftString = nil;
    self.bannerRightString = nil;
    [super viewDidUnload];
}
- (void)refresh
{
    NSLog(@"%s",__FUNCTION__);
	if (_photoList == nil) {
		_photoList = [[NSMutableArray alloc] init];
	}
	[_request getPhotosWithUserID:_albumData.creatorId FolderID:_albumData.albumId page:1];
}

#pragma mark - SCPRequestManagerDelegate
- (void)requestFailed:(ASIHTTPRequest *)mangeger
{
	NSLog(@"RequestFailed");
}

- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    [_photoList removeAllObjects];
    [self updateUploadPhotoList];
	NSArray * photoList = [info objectForKey:@"photoList"];
	for (int i = 0; i < photoList.count; ++i) {
		NSDictionary *photoInfo = [photoList objectAtIndex:i];
		SCPPhoto *photo = [[SCPPhoto alloc] init];
		photo.photoID = [photoInfo objectForKey:@"showId"];
        photo.photoUrl = [photoInfo objectForKey:@"bigUrl"];
        
		[_photoList addObject:photo];
		[photo release];
	}    
	[_pullingController reloadDataSourceWithAniamtion:NO];
	[_pullingController refreshDoneLoadingTableViewData];
}
- (void)updateUploadPhotoList
{
    self.uploadTaskList = [[SCPUploadTaskManager currentManager] getAlbumTaskWithAlbum:self.albumData.albumId];
    taskTotal = self.uploadTaskList.taskList.count;
    for (SCPTaskUnit * unit in self.uploadTaskList.taskList)
        [self.thumbnailArray addObject:unit.thumbnail];
    if (!self.uploadTaskList)      return;
    for (int i = 0; i < self.uploadTaskList.taskList.count; i++) {
        SCPPhoto * photo = [[SCPPhoto alloc] init];
        photo.photoID = nil;
        photo.photoUrl = nil;
        [_photoList addObject:photo];
        [photo release];
    }
}
#pragma mark - inner method

- (BOOL)longinPridecate
{
    if (![SCPLoginPridictive isLogin] ) {
        UIAlertView * alte = [[[UIAlertView alloc] initWithTitle:@"请确认登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alte show];
    }
    if (![self.albumData.creatorId isEqualToString:[SCPLoginPridictive currentUserId]]) {
        UIAlertView * alte = [[[UIAlertView alloc] initWithTitle:@"你无权对该相册进行操作" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alte show];
    }
    return [SCPLoginPridictive isLogin] && [self.albumData.creatorId isEqualToString:[SCPLoginPridictive currentUserId]];
}
#pragma mark Rename album
- (void)onPenClicked:(id)sender
{
    if (![self longinPridecate]) return;
    SCPAlert_Rename * rename = [[[SCPAlert_Rename alloc] initWithDelegate:self name:self.albumData.name] autorelease];
    [rename show];
}
- (void)renameAlertView:(SCPAlert_Rename *)view OKClicked:(UITextField *)textField
{
    NSString * str = textField.text;
    [_request renameAlbumWithUserId:[SCPLoginPridictive currentUserId] folderId:self.albumData.albumId newName:str success:^(NSString *response) {
        self.albumData.name = str;
        self.pullingController.headView.labelName.text = str;
        [self.pullingController reloadDataSourceWithAniamtion:NO];
    }];
}
#pragma mark trash
- (void)onTrashClicked:(id)sender
{
    if (![self longinPridecate]) return;
    _state = PhotoGridStateDelete;
    [self.pullingController shutDataChangeFunction];
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromRight;
    animation.endProgress = 0.7;
    animation.duration = 0.2;
    [_rightBarView.layer addAnimation:animation forKey:nil];
    
    [_iMarkButton removeFromSuperview];
    [_trashButton removeFromSuperview];
    [_penButton removeFromSuperview];
    [_rightBarView addSubview:_okButton];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_cancelButton];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
}

- (void)oniMarkClicked:(id)sender
{
    NSLog(@"oniMarkClicked");
    //    if (![self longinPridecate]) return;
    SCPAlert_DetailView * scp = [[[SCPAlert_DetailView alloc] initWithMessage:self.albumData delegate:self] autorelease];
    [scp show];
}
- (void)alertViewOKClicked:(SCPAlert_LoginView *)view
{
    [self setPhotoGridStateNormal];
}
- (void)setPhotoGridStateNormal
{
    _state = PhotoGridStateNormal;
    [_tasksToDel removeAllObjects];
    
    NSMutableArray * photoArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * uploadArray = [NSMutableArray arrayWithCapacity:0];
    
    for (SCPPhoto * ob in [_imagesToDel allObjects]){
        if (!ob.photoUrl) {
            [uploadArray addObject:ob];
        }else{
            [photoArray addObject:ob];
        }
    }
    [_imagesToDel removeAllObjects];
    [self comeBackToStateNomal];

    if (uploadArray.count)
        [self removeTask:uploadArray];
    if (photoArray.count)
        [self deletePhoto:photoArray];
    
    
}
- (BOOL)removeTask:(NSArray *)array
{
    if ([[SCPUploadTaskManager currentManager] getAlbumTaskWithAlbum:_albumData.albumId].taskList.count == 0) return NO;
    //获得任务unit
    NSMutableArray * unitArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i++) {
        SCPPhoto * photo = [array objectAtIndex:i];
        NSInteger index = [_photoList indexOfObject:photo];
        SCPTaskUnit * unit = [self.uploadTaskList.taskList objectAtIndex:self.uploadTaskList.taskList.count - index - 1];
        [unitArray addObject:unit];
        //删除对应照片
        [self.thumbnailArray removeObject:unit.thumbnail];
    }
    //删除任务unit
    if (unitArray.count){
        [[SCPUploadTaskManager currentManager] cancelupLoadWithAlbumID:_albumData.albumId WithUnit:unitArray];
    }
  
    taskTotal = self.thumbnailArray.count;
    self.uploadTaskList = [[SCPUploadTaskManager currentManager] getAlbumTaskWithAlbum:_albumData.albumId];
    [_photoList removeObjectsInArray:array];
    [self.pullingController reloadDataSourceWithAniamtion:NO];
    return YES;
    
}
- (void)deletePhoto:(NSArray *)photoArray
{
    if (photoArray.count) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        for (SCPPhoto * photo in photoArray)
            [array addObject:photo.photoID];
        [_request deletePhotosWithUserId:[SCPLoginPridictive currentUserId] folderId:self.albumData.albumId photoIds:array success:^(NSString *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                for (SCPPhoto * photo in photoArray){
                    if ([_photoList indexOfObject:photo] < taskTotal){
                        [self.thumbnailArray removeObjectAtIndex:taskTotal -[_photoList indexOfObject:photo] - 1];
                        taskTotal = self.thumbnailArray.count;
                    }
                }
                //删除任务和显示界面窗口
                self.albumData.photoNum -= photoArray.count;
                [_photoList removeObjectsInArray:photoArray];
                UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
                self.navigationItem.leftBarButtonItem = item;
                [item release];
                [self.pullingController reloadDataSourceWithAniamtion:NO];
            });
        }];
    }
}
- (void)comeBackToStateNomal
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    [_pullingController.tableView.layer addAnimation:animation forKey:nil];
    [_pullingController.tableView reloadData];
    
    animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    animation.startProgress = 0.3;
    animation.duration = 0.2;
    [_rightBarView.layer addAnimation:animation forKey:nil];
    [_okButton removeFromSuperview];
    [_rightBarView addSubview:_penButton];
    [_rightBarView addSubview:_trashButton];
    [_rightBarView addSubview:_iMarkButton];
}
- (void)onDeleteOKClicked:(id)sender
{
    if (!_imagesToDel || !_imagesToDel.count) {
        return;
    }
    SCPAlert_DeletView * alterView = [[[SCPAlert_DeletView alloc] initWithMessage:DELETE delegate:self] autorelease];
    [alterView show];
    [self.pullingController openDataChangeFunction];
    return;
}

- (void)onDeleteCancelClicked:(id)sender
{
    _state = PhotoGridStateNormal;
    [self.pullingController openDataChangeFunction];
    [_tasksToDel removeAllObjects];
    [_imagesToDel removeAllObjects];
    [self.pullingController reloadDataSourceWithAniamtion:NO];
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    animation.startProgress = 0.3;
    animation.duration = 0.2;
    [_rightBarView.layer addAnimation:animation forKey:nil];
    [_okButton removeFromSuperview];
    [_rightBarView addSubview:_penButton];
    [_rightBarView addSubview:_trashButton];
    [_rightBarView addSubview:_iMarkButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
}

#pragma mark -
#pragma tableView delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (_photoList.count + 3) / 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (int) 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"albumListCell";
    SCPPhotoGridCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[SCPPhotoGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    static int photoCount = 4;
    int offset = photoCount * [indexPath row];
    
    for (int i = 0; i < 4; i++) {
        NSNumber * tag = [NSNumber numberWithInt:i + offset];
        if (tag.integerValue < taskTotal) {
            if (self.uploadTaskList.taskList.count == taskTotal) {//初始化任务
                //显示所有的任务进度
                for (UIProgressView * pro in cell.progViewList) [pro setHidden:NO];
                [[cell imageViewAt:i] setAlpha:0.5];
            }
            //设置图片
            [[cell imageViewAt:i] setImage:[self.thumbnailArray objectAtIndex:taskTotal - tag.integerValue - 1]];
            //当前任务 设置进度条
            if (tag.integerValue == _uploadTaskList.taskList.count - 1) {
                [self.uploadTaskList.currentTask.request setUploadProgressDelegate:[cell.progViewList objectAtIndex:i]];
            }
            //完成的任务
            if (tag.integerValue >= _uploadTaskList.taskList.count) {
                [[cell.progViewList objectAtIndex:i] setHidden:YES];
                [[cell imageViewAt:i] setAlpha:1.f];
            }
            SCPPhoto *photoData = [_photoList objectAtIndex:tag.intValue];
            [cell updateViewWithTask:photoData Position:i PreToDel:[_imagesToDel containsObject:photoData]];
            
            //设置tag
            [[cell imageViewAt:i] setTag:tag.intValue];

        } else if (tag.intValue < _photoList.count) {
            SCPPhoto *photoData = [_photoList objectAtIndex:tag.intValue];
            [cell updateViewWithPhoto:photoData Position:i PreToDel:[_imagesToDel containsObject:photoData]];
            [[cell imageViewAt:i] setTag:tag.intValue];
            [[cell imageViewAt:i] setAlpha:1.f];
        } else {
            [cell hideViewWithPosition:i];
        }
    }
    return cell;
}

#pragma mark -
#pragma mark SCPPhotoGridCellDelegate
- (void)onImageViewClicked:(UIImageView *)imageView
{
	NSNumber *tag = [NSNumber numberWithInt:imageView.tag];
    switch (_state) {
            
        case PhotoGridStateNormal:
		{
			if (tag.intValue < _uploadTaskList.taskList.count) {
				UIAlertView * alterView = [[[UIAlertView alloc] initWithTitle:@"图片正在上传中,是否删除任务" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease];
                alterView.tag = tag.intValue;
                [alterView show];
                
			} else if (tag.intValue < _photoList.count) {
				SCPPhoto *photo = [self.photoList objectAtIndex:tag.intValue];
				NSString * photoId = photo.photoID;
				NSString * user_id = self.albumData.creatorId;
                SCPPhotoDetailViewController * spd = [[[SCPPhotoDetailViewController alloc] initWithuseId:user_id photoId:photoId] autorelease];
                [self.navigationController pushViewController:spd animated:YES];
			}
            break;
		}
            
        case PhotoGridStateDelete:
        {
            if (tag.intValue < _uploadTaskList.taskList.count) {
                
                SCPPhoto * photo = [self.photoList objectAtIndex:tag.intValue];
                if ([_imagesToDel containsObject:photo]) {
                    [_imagesToDel removeObject:photo];
                } else {
                    [_imagesToDel addObject:photo];
                }
            } else if (tag.intValue <  _photoList.count) {
                
                SCPPhoto *photo = [self.photoList objectAtIndex:tag.intValue];
                if ([_imagesToDel containsObject:photo]) {
                    [_imagesToDel removeObject:photo];
                } else {
                    [_imagesToDel addObject:photo];
                }
            }
            break;
        }
        default:
            break;
    }
    
    [_pullingController.tableView reloadData];
}
#pragma mark - AlterViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        if ([[SCPUploadTaskManager currentManager] getAlbumTaskWithAlbum:_albumData.albumId].taskList.count == 0) return;
        SCPTaskUnit * unit = [self.uploadTaskList.taskList objectAtIndex:self.uploadTaskList.taskList.count - alertView.tag - 1];
        [[SCPUploadTaskManager currentManager] cancelupLoadWithAlbumID:_albumData.albumId WithUnit:[NSArray arrayWithObject:unit]];
        [self.photoList removeObjectAtIndex:alertView.tag];
        [self.thumbnailArray removeObjectAtIndex:taskTotal - alertView.tag - 1];
        taskTotal--;
        self.uploadTaskList = [[SCPUploadTaskManager currentManager] getAlbumTaskWithAlbum:_albumData.albumId];
        [self.pullingController reloadDataSourceWithAniamtion:NO];
    }
}
#pragma mark -
#pragma mark BannerDataSource
- (NSString *)bannerDataSouceLeftLabel
{
    return [NSString stringWithFormat:@"共有%d张图片", self.albumData.photoNum];
}
- (NSString *)bannerDataSouceRightLabel
{
    return [NSString stringWithFormat:@"%d次浏览", self.albumData.viewCount];
}

#pragma mark -
#pragma mark PullingRefreshDelegate
- (void)pullingreloadTableViewDataSource:(id)sender
{
	[self refresh];
}

- (void)pullingreloadMoreTableViewData:(id)sender
{
	[_pullingController moreDoneLoadingTableViewData];
}
#pragma mark -
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [((SCPMenuNavigationController *) self.navigationController).menuView setHidden:YES];
    [((SCPMenuNavigationController *) self.navigationController).ribbonView setHidden:YES];
    [self addObserVerOnCenter];
    [self refresh];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [((SCPMenuNavigationController *) self.navigationController).menuView setHidden:NO];
    [((SCPMenuNavigationController *) self.navigationController).ribbonView setHidden:NO];
    [self removeObserverOnCenter];
}
#pragma mark -
#pragma mark Notification

- (void)addObserVerOnCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumChange:) name:ALBUMTASKCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumTaskOver:) name:ALBUMUPLOADOVER object:nil];
}

- (void)removeObserverOnCenter
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALBUMTASKCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALBUMUPLOADOVER  object:nil];
}
- (void)albumTaskOver:(NSNotification *)notification
{
//    [self refresh];
}
- (void)albumChange:(NSNotification *)notification
{
    
    if (!taskTotal )  return;
    NSDictionary * requsetInfo = [[[notification userInfo] objectForKey:@"RequsetInfo"] objectForKey:@"data"];
    if (requsetInfo) self.albumData.photoNum++;
    SCPPhoto * photo = [_photoList objectAtIndex:self.uploadTaskList.taskList.count];
    photo.photoID = [requsetInfo objectForKey:@"id"];
    photo.photoUrl = [requsetInfo objectForKey:@"big_url"];
    self.uploadTaskList = [[SCPUploadTaskManager currentManager] getAlbumTaskWithAlbum:self.albumData.albumId];
    [self.pullingController reloadDataSourceWithAniamtion:NO];
}

@end
