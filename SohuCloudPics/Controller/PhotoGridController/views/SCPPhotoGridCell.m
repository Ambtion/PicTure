//
//  SCPPhotoGridCell.m
//  SohuCloudPics
//
//  Created by Yingxue Peng on 12-9-24.
//  Copyright (c) 2012年 Sohu.com. All rights reserved.
//

#import "SCPPhotoGridController.h"
#import "SCPPhotoGridCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

#import "SCPPhoto.h"

@implementation SCPPhotoGridCell

//@synthesize imageIdList = _imageIdList;

@synthesize imageViewList = _imageViewList;
@synthesize progViewList = _progViewList;
@synthesize deleteViewList = _deleteViewList;

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 80);
        
        self.imageViewList = [NSMutableArray arrayWithCapacity:0];
        self.progViewList = [NSMutableArray arrayWithCapacity:0];
        self.deleteViewList = [NSMutableArray arrayWithCapacity:0];
        
        int photoCount = 4;
        for (int i = 0; i < photoCount;  i++) {
            /* imageView */
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4 + i * 79, 5, 75, 75)];
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTap:)];
            [imageView addGestureRecognizer:gesture];
            [gesture release];
            imageView.userInteractionEnabled = YES;
            [imageView setBackgroundColor:[UIColor whiteColor]];
            [_imageViewList addObject:imageView];
            [self addSubview:imageView];
            [imageView release];
            
            /* progressView */
            UIProgressView *prog = [[UIProgressView alloc] initWithFrame:CGRectMake(i * 79 + 8, 60 + 5, 64, 9)];
            [prog setProgressImage:[[UIImage imageNamed:@"prog_done.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.5, 4.5, 4.5, 4.5)]];
            [prog setTrackImage:[[UIImage imageNamed:@"prog_wait.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.5, 4.5, 4.5, 4.5)]];
            prog.progress = 0;
            [_progViewList addObject:prog];
            [self addSubview:prog];
            [prog release];
            
            /* deleteView */
            UIImageView * deleteFrameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_box_select_image.png"]];
            deleteFrameImageView.frame = imageView.frame;
            [_deleteViewList addObject:deleteFrameImageView];
            // not added first
            // [self addSubview:deleteFrameImageView];
            [deleteFrameImageView release];
        }
    }
    return self;
}
- (void)dealloc
{
    self.imageViewList = nil;
    self.progViewList = nil;
    self.delegate = nil;
    [super dealloc];
}


#pragma mark - public method
- (UIImageView *)imageViewAt:(int)position
{
    UIImageView *view = nil;
    if (position < _imageViewList.count) {
        view = [_imageViewList objectAtIndex:position];
    }
    return view;
}

- (UIProgressView *)progressViewAt:(int)position
{
    UIProgressView *view = nil;
    if (position < _progViewList.count) {
        view = [_progViewList objectAtIndex:position];
    }
    return view;
}

- (UIImageView *)deleteFrameImageViewAt:(int)position
{
    UIImageView *view = nil;
    if (position < _deleteViewList.count) {
        view = [_deleteViewList objectAtIndex:position];
    }
    return view;
}

- (void)updateViewWithTask:(SCPPhoto*)data Position:(int)position PreToDel:(BOOL)pre
{
    UIImageView *view = [self imageViewAt:position];
    [view setHidden:NO];
    
    UIImageView *deleteFrameView = [self deleteFrameImageViewAt:position];
    if (pre) {
        [self addSubview:deleteFrameView];
    } else {
        [deleteFrameView removeFromSuperview];
    }
}

- (void)updateViewWithPhoto:(SCPPhoto *)photo Position:(int)position PreToDel:(BOOL)pre
{
    
    if (photo.photoUrl) {
        
        UIImageView *view = [self imageViewAt:position];
        [view setHidden:NO];
        NSString *url = [NSString stringWithFormat:@"%@_c150", photo.photoUrl];
        [view cancelCurrentImageLoad];
        [view setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:0];
        UIProgressView *progView = [self progressViewAt:position];
        [progView setHidden:YES];
    }
    
    UIImageView *deleteFrame = [self deleteFrameImageViewAt:position];
    if (pre) {
        [deleteFrame setHidden:NO];
        [self addSubview:deleteFrame];
    } else {
        [deleteFrame removeFromSuperview];
    }
}

- (void)hideViewWithPosition:(int)position
{
    [[self imageViewAt:position] setHidden:YES];
    [[self progressViewAt:position] setHidden:YES];
    [[self deleteFrameImageViewAt:position] setHidden:YES];
}

#pragma mark - inner method
- (void)onImageViewTap:(UIGestureRecognizer *)gesture
{
    if ([delegate respondsToSelector:@selector(onImageViewClicked:)]) {
        [delegate onImageViewClicked:(UIImageView *)gesture.view];
    }
}

@end
