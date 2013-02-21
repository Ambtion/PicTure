//
//  SCPAlbumListController.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPAlbumListController.h"

#import "SCPAlbumListCell.h"
#import "SCPAlbumGridController.h"
#import "SCPAlbum.h"
#import "SCPMenuNavigationController.h"
#import "SCPPhotoGridController.h"
#import "AlbumControllerManager.h"


@implementation SCPAlbumListController
- (void)dealloc
{
    [self removeObserverOnCenter];
    self.curProgreeeView = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil useID: (NSString *)use_ID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.user_id = use_ID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserVerOnCenter];
}

#pragma mark -
#pragma NavigationItem
- (UIButton *)switchButtonView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"header_grid.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"header_grid_press.png"] forState:UIControlStateHighlighted];
    return button;
}

- (SCPAlbumController *)switchController
{
    return [[[SCPAlbumGridController alloc] initWithNibName:nil bundle:nil useID:self.user_id] autorelease];
}

#pragma mark -
#pragma tableView delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"albumListCell";
    SCPAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[SCPAlbumListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if (indexPath.row >= self.albumList.count) {
        return cell;
    }
    
    SCPAlbum * album = [self.albumList objectAtIndex:indexPath.row];
    [cell updateViewWithAlbum:album preToDel:(_state == SCPAlbumControllerStateDelete)];
	cell.photoImageView.tag = indexPath.row;
    cell.nameLabel.tag = indexPath.row;
	cell.deleteView.tag = indexPath.row;

    //显示 所有任务Progress
    for(SCPAlbumTaskList * tasks in [SCPUploadTaskManager currentManager].taskList)
    {
        if ([tasks.albumId isEqualToString: album.albumId]) {
            UIProgressView * pro = cell.progressView;
            [pro setHidden:NO];
            pro.progress = 0.f;

        }
        //当前进行的任务
        if ([album.albumId isEqualToString:[SCPUploadTaskManager currentManager].curTask.albumId]) {
            self.curProgreeeView = cell.progressView;
        }
    }
    //    cell.contentView.backgroundColor = [UIColor redColor];
    if (self.albumList.count - 5 > 0 && indexPath.row >= self.albumList.count - 5)
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
    self.curProgreeeView = nil;
    self.curProgreeeView.progress = 0.01;
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
