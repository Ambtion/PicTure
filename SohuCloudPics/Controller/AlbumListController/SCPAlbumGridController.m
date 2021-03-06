//
//  SCPAlbumListController.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPAlbumGridController.h"

#import "SCPAlbumGridCell.h"
#import "SCPALbum.h"
#import "SCPAlbumListController.h"
#import "SCPMenuNavigationController.h"
#import "SCPPhotoGridController.h"
#import "AlbumControllerManager.h"

@implementation SCPAlbumGridController

@synthesize photoCount = _photoCount;
@synthesize currlabel;

- (void)dealloc
{
    [self removeObserverOnCenter];
    self.currlabel = nil;
    self.curProgreeeView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil useID: (NSString *)use_ID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.user_id = use_ID;
        _photoCount = 3;
    }
    return self;
}
- (UIButton *)switchButtonView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"header_list.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"header_list_press.png"] forState:UIControlStateHighlighted];
    return button;
}
- (SCPAlbumController *)switchController
{
	return [[[SCPAlbumListController alloc] initWithNibName:nil bundle:nil useID:self.user_id] autorelease];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserVerOnCenter];
}
#pragma mark -
#pragma tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.albumList.count + _photoCount - 1) / _photoCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GRID_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"albumCell";
    SCPAlbumGridCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[SCPAlbumGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier photoCount:_photoCount] autorelease];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.delegate = self;
    }
    [cell hideAllViews];
    int offset = indexPath.row * _photoCount;
    for (int i = offset; i < offset + 3 && i < self.albumList.count; i++) {
        
        int indexInCell = i - offset;
        SCPAlbum * album = [self.albumList objectAtIndex:i];
        [cell updateViewWithAlbum:album position:indexInCell preToDel:(_state == SCPAlbumControllerStateDelete)];
        [cell coverImageViewAt:indexInCell].tag = i;
		[cell deleteViewAt:indexInCell].tag = i; // for delete button
        [cell nameLabelAt:indexInCell].tag  = i;
        //显示 所有任务Progress
        for(SCPAlbumTaskList * tasks in [SCPUploadTaskManager currentManager].taskList)
        {
            if ([[NSString stringWithFormat:@"%@",tasks.albumId] isEqualToString: [NSString stringWithFormat:@"%@",album.albumId]]) {
                UIProgressView * pro = [cell.progressViewList objectAtIndex:indexInCell];
                [pro setHidden:NO];
                pro.progress = 0.f;
            }
            //当前进行的任务
            if ([[NSString stringWithFormat:@"%@",album.albumId] isEqualToString:[NSString stringWithFormat:@"%@",[SCPUploadTaskManager currentManager].curTask.albumId]]) {
                self.curProgreeeView = [cell.progressViewList objectAtIndex:indexInCell];
                self.currlabel = [cell.countLabelList objectAtIndex:indexInCell];
                [self.currlabel setHidden:YES];
            }
        }
    }
	if ( (self.albumList.count + _photoCount - 1) / _photoCount - 5 > 0 && indexPath.row >= (self.albumList.count + _photoCount - 1) / _photoCount - 5 )
		[self loadNextPage];
    return cell;
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
    [self.curProgreeeView setHidden:YES];
    self.curProgreeeView.progress = 0.01;
    self.curProgreeeView = nil;
    [self.currlabel setHidden:NO];
    self.currlabel = nil;
    [self refresh];
}
- (void)albumChange:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    NSInteger total = [[dic objectForKey:@"Total"] intValue];
    NSInteger finish = [[dic objectForKey:@"Finish"] intValue];
    CGFloat pro = (CGFloat)((CGFloat)finish / (CGFloat)total);
    self.curProgreeeView.progress = pro;
}

@end
