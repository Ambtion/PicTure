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

#import "CountLabel.h"


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

    self.coverImageViewList = nil;
    self.frameImageViewList = nil;
    self.progressViewList = nil;
    self.nameLabelList = nil;
    self.countLabelList = nil;
    self.deleteViewList = nil;
	self.albumList = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier photoCount:(int)count
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _coverImageViewList = [[NSMutableArray alloc] initWithCapacity:0];
        _frameImageViewList = [[NSMutableArray alloc] initWithCapacity:0];
        _progressViewList = [[NSMutableArray alloc] initWithCapacity:0];
        _nameLabelList = [[NSMutableArray alloc] initWithCapacity:0];
        _countLabelList = [[NSMutableArray alloc] initWithCapacity:0];
        _deleteViewList = [[NSMutableArray alloc] initWithCapacity:0];
		_albumList = [[NSMutableArray alloc] initWithCapacity:0];
        _photoCount = count;
        
        int frameSize = 320 / count;
        self.frame = CGRectMake(0, 0, 320, GRID_CELL_HEIGHT);
        
        UIImage * background = [UIImage imageNamed:@"150.png"];
        for (int i = 0; i < _photoCount; i++) {
            /* frame image view */
            UIImageView * frameImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(i * frameSize + 5, 0, 95, 95)] autorelease];
            [frameImageView setImage:background];
            [frameImageView setUserInteractionEnabled:YES];
            [_frameImageViewList addObject:frameImageView];
            [self.contentView addSubview:frameImageView];
            
            /* cover image view */
            UIImageView * coverImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10,10, 75, 75)] autorelease];
            coverImageView.userInteractionEnabled = YES;            
            UIGestureRecognizer * gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTapped:)] autorelease];
            [coverImageView addGestureRecognizer:gesture];
            gesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewLongPressed:)] autorelease];
            [coverImageView addGestureRecognizer:gesture];
            [frameImageView addSubview:coverImageView];
            [_coverImageViewList addObject:coverImageView];
                        
            /* name label view */
            UILabel * nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(i * frameSize + 5, 100, frameSize - 10, 20)] autorelease];
            [UIUtils updateNormalLabel:nameLabel title:nil];
            [nameLabel setTextAlignment:UITextAlignmentCenter];
            [nameLabel setUserInteractionEnabled:YES];
            UITapGestureRecognizer * nameTap = [[[UITapGestureRecognizer   alloc] initWithTarget:self action:@selector(onImageViewTapped:)] autorelease];
            [nameLabel addGestureRecognizer:nameTap];
            [_nameLabelList addObject:nameLabel];
            [self.contentView addSubview:nameLabel];
            /* count label view */
            CountLabel *countLabel = [[[CountLabel alloc] initWithFrame:CGRectMake(75 - 30, 75 - 16, 30, 18)] autorelease];
            
            [UIUtils updateAlbumCountLabel:countLabel];
            
            [_countLabelList addObject:countLabel];
            [coverImageView addSubview:countLabel];
            
            /* progress view */
            UIProgressView * progressView = [[[UIProgressView alloc] initWithFrame:CGRectMake(i * frameSize + 20, 73 , 64, 9)] autorelease];
            [progressView setProgressImage:[[UIImage imageNamed:@"prog_done.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.5, 4.5, 4.5, 4.5)]];
            [progressView setTrackImage:[[UIImage imageNamed:@"prog_wait.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.5, 4.5, 4.5, 4.5)]];
            progressView.progress = 0.f;
            
            [_progressViewList addObject:progressView];
            [self.contentView addSubview:progressView];
            
            /* delete ? */
            UIImageView *deleteView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"album_delete.png"]] autorelease];
            deleteView.frame = CGRectMake(i * frameSize + 5, -2, 29, 29);
			deleteView.userInteractionEnabled = YES;
			gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTapped:)] autorelease];
			[deleteView addGestureRecognizer:gesture];
            [_deleteViewList addObject:deleteView];
            [self.contentView addSubview:deleteView];
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
    UIImageView * view = nil;
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
    /* set frame image view */
    
    UIImageView * frameImageView = [self frameImageViewAt:position];
    [frameImageView setHidden:NO];
    
	[_albumList setObject:album atIndexedSubscript:position];
    
    /* set cover image view */
    UIImageView * coverImageView = [self coverImageViewAt:position];
    [coverImageView setHidden:NO];
    NSString *str = [NSString stringWithFormat:@"%@_c150",album.coverURL];
    [coverImageView cancelCurrentImageLoad];
    [coverImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"frame_alubme_default_image.png"] options:0];

    /* set progess view */
    UIProgressView *progressView = [self progressViewAt:position];
    [progressView setHidden:!album.isUploading];
    
    /* set name label */
    UILabel *nameLabel = [self nameLabelAt:position];
    [nameLabel setHidden:NO];
	nameLabel.text = album.name;

    /* set count label */
    CountLabel * countLabel = (CountLabel *)[self countLabelAt:position];
    [countLabel setHidden:album.isUploading];
//    if (album.isUploading) {
//        countLabel.backgroundColor = [UIColor clearColor];
//        countLabel.text = nil;
//    }else{
////        countLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
//        countLabel.backgroundColor = [UIColor clearColor];
//        [countLabel setText:[NSString stringWithFormat:@" %d ", album.photoNum]];
//        [countLabel sizeToFit];
//        countLabel.frame = CGRectMake(75 - countLabel.frame.size.width - 5, 75 - countLabel.frame.size.height - 5,
//                                      countLabel.frame.size.width > 18 ? countLabel.frame.size.width : 18 , 18);
//    }
    [countLabel setText:[NSString stringWithFormat:@" %d ", album.photoNum]];
    [countLabel sizeToFit];
    countLabel.frame = CGRectMake(75 - countLabel.frame.size.width - 5, 75 - countLabel.frame.size.height - 5,
                                  countLabel.frame.size.width > 18 ? countLabel.frame.size.width : 18 , 18);
    
    /* delete ? */
    UIImageView *deleteView = [self deleteViewAt:position];
    deleteView.hidden = !deleting;
}

@end
