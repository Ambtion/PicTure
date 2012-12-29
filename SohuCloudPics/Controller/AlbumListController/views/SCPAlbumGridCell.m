//
//  SCPAlbumCell.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPAlbumGridCell.h"

#import <QuartzCore/QuartzCore.h>

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

#import "UIUtils.h"
#import "SCPALbum.h"


@implementation SCPAlbumGridCell

@synthesize coverImageViewList = _coverImageViewList;   // 相册封面
@synthesize frameImageViewList = _frameImageViewList;   // 相框
@synthesize progressViewList = _progressViewList;       // 上传进度条
@synthesize nameLabelList = _nameLabelList;             // 相册名
@synthesize countLabelList = _countLabelList;           // 相册图片数量
@synthesize deleteViewList = _deleteViewList;           // 删除按钮

@synthesize albumList = _albumList;	// 不是AlbumController的albumList

@synthesize photoCount = _photoCount;

- (void)dealloc
{
    self.frameImageViewList = nil;
    self.progressViewList = nil;
    self.nameLabelList = nil;
    self.countLabelList = nil;
    self.deleteViewList = nil;
    self.coverImageViewList = nil;
	self.albumList = nil;
    
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier photoCount:(int)count
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _coverImageViewList = [[NSMutableArray alloc] init];
        _frameImageViewList = [[NSMutableArray alloc] init];
        _progressViewList = [[NSMutableArray alloc] init];
        _nameLabelList = [[NSMutableArray alloc] init];
        _countLabelList = [[NSMutableArray alloc] init];
        _deleteViewList = [[NSMutableArray alloc] init];
		_albumList = [[NSMutableArray alloc] initWithCapacity:count];
		
        _photoCount = count;
        int frameSize = 320 / count;
        self.frame = CGRectMake(0, 0, 320, GRID_CELL_HEIGHT);
        
        UIImage *background = [UIImage imageNamed:@"150.png"];
        
        for (int i = 0; i < _photoCount; i++) {
            /* cover image view */
            UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * frameSize + 15, 5, 75, 75)];
            coverImageView.userInteractionEnabled = YES;

            UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTapped:)];
            [coverImageView addGestureRecognizer:gesture];
            [gesture release];
            gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewLongPressed:)];
            [coverImageView addGestureRecognizer:gesture];
            [gesture release];
            gesture = nil;
            
            [_coverImageViewList addObject:coverImageView];
            [self addSubview:coverImageView];
            [coverImageView release];
            
            /* frame image view */
            UIImageView *frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * frameSize + 5, -5, 95, 95)];
            [frameImageView setImage:background];
            
            [_frameImageViewList addObject:frameImageView];
            [self addSubview:frameImageView];
            [frameImageView release];
            
                       
            /* name label view */
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * frameSize + 5, 93, frameSize - 10, 20)];
            [UIUtils updateNormalLabel:nameLabel title:nil];
            [nameLabel setTextAlignment:UITextAlignmentCenter];
            
            [_nameLabelList addObject:nameLabel];
            [self addSubview:nameLabel];
            [nameLabel release];
            
            /* count label view */
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * frameSize + 56, 60, 30, 16)];
            [UIUtils updateAlbumCountLabel:countLabel];
            [countLabel setTextAlignment:UITextAlignmentCenter];
            
            [_countLabelList addObject:countLabel];
            [self addSubview:countLabel];
            [countLabel release];
            
            /* progress view */
            UIProgressView * progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(i * frameSize + 20, 63, 64, 8)];
            [progressView setProgressImage:[UIImage imageNamed:@"prog_done.png"]];
    
            [progressView setTrackImage:[[UIImage imageNamed:@"prog_wait.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0]];
            progressView.progress = 0.f;
            
            [_progressViewList addObject:progressView];
            [self addSubview:progressView];
            [progressView release];

            /* delete ? */
            UIImageView *deleteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"album_delete.png"]];
            deleteView.frame = CGRectMake(i * frameSize + 5, -2, 29, 29);
            
            [_deleteViewList addObject:deleteView];
            [self addSubview:deleteView];
            [deleteView release];
        }
    }
    return self;
}
- (UILabel *)getLabelInSuperView:(id)object
{
    for (id ob in [[object superview] subviews]) {
        if ([ob isKindOfClass:[UILabel class]]) {
            return ob;
        }
    }
    return nil;
}

- (UIImageView *)coverImageViewAt:(int)position
{
    UIImageView *view = nil;
    if (position < _coverImageViewList.count) {
        view = [_coverImageViewList objectAtIndex:position];
    }
    return view;
}

- (UIImageView *)frameImageViewAt:(int)position
{
    UIImageView *view = nil;
    if (position < _frameImageViewList.count) {
        view = [_frameImageViewList objectAtIndex:position];
    }
    return view;
}

- (UIProgressView *)progressViewAt:(int)position
{
    UIProgressView *view = nil;
    if (position < _progressViewList.count) {
        view = [_progressViewList objectAtIndex:position];
    }
    return view;
}

- (UILabel *)nameLabelAt:(int)position
{
    UILabel *view = nil;
    if (position < _nameLabelList.count) {
        view = [_nameLabelList objectAtIndex:position];
    }
    return view;
}

- (UILabel *)countLabelAt:(int)position
{
    UILabel *view = nil;
    if (position < _countLabelList.count) {
        view = [_countLabelList objectAtIndex:position];
    }
    return view;
}

- (UIImageView *)deleteViewAt:(int)position
{
    UIImageView *view = nil;
    if (position < _deleteViewList.count) {
        view = [_deleteViewList objectAtIndex:position];
    }
    return view;
}

- (void)hideAllViews
{
    for (UIView *view in _coverImageViewList) {
        [view setHidden:YES];
    }
    for (UIView *view in _frameImageViewList) {
        [view setHidden:YES];
    }
    for (UIView *view in _progressViewList) {
        [view setHidden:YES];
    }
    for (UIView *view in _nameLabelList) {
        [view setHidden:YES];
    }
    for (UIView *view in _countLabelList) {
        [view setHidden:YES];
    }
    for (UIView *view in _deleteViewList) {
        [view setHidden:YES];
    }
}

- (void)updateViewWithAlbum:(SCPAlbum *)album position:(int)position preToDel:(BOOL)deleting
{
    
	[_albumList setObject:album atIndexedSubscript:position];
    /* set cover image view */
    UIImageView *coverImageView = [self coverImageViewAt:position];
    [coverImageView setHidden:NO];
	if (album.coverURL != nil && ![album.coverURL isKindOfClass:[NSNull class]] && album.coverURL.length != 0) {
        NSString *str = [NSString stringWithFormat:@"%@_c150",album.coverURL];
		[coverImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:0];
	} else {
		[coverImageView setImage:[self getEmptyFolderCoverImage]];
	}
    /* set frame image view */
    UIImageView *frameImageView = [self frameImageViewAt:position];
    [frameImageView setHidden:NO];
    
    /* set progess view */
    UIProgressView *progressView = [self progressViewAt:position];
    [progressView setHidden:!album.isUploading];
    
    /* set name label */
    UILabel *nameLabel = [self nameLabelAt:position];
    [nameLabel setHidden:NO];
	nameLabel.text = album.name;
    
    /* set count label */
    UILabel *countLabel = [self countLabelAt:position];
    [countLabel setHidden:album.isUploading];
    [countLabel setText:[NSString stringWithFormat:@"%d", album.photoNum]];
    
    /* delete ? */
    UIImageView *deleteView = [self deleteViewAt:position];
    deleteView.hidden = !deleting;
}

@end
