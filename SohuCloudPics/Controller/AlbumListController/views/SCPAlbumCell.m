//
//  SCPAlbumCell.m
//  SohuCloudPics
//
//  Created by Chen Chong on 12-11-14.
//
//

#import "SCPAlbumCell.h"


static UIImage *emptyFolderCoverImage = nil;


@implementation SCPAlbumCell

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


#pragma mark - inner call
- (void)onImageViewTapped:(UIGestureRecognizer *)gesture
{
    if ([_delegate respondsToSelector:@selector(onImageViewClicked:)]) {
        [_delegate onImageViewClicked:(UIImageView *) gesture.view];
    }
}

- (void)onImageViewLongPressed:(UILongPressGestureRecognizer *)gesture
{
    if ([_delegate respondsToSelector:@selector(onImageViewLongPressed:)]) {
        [_delegate onImageViewLongPressed:(UIImageView *) gesture.view];
    }
}

#pragma mark - PlaceHolderImage
- (UIImage *)getEmptyFolderCoverImage
{
	if (emptyFolderCoverImage == nil) {
		@synchronized (self) {
			if (emptyFolderCoverImage == nil) {
				emptyFolderCoverImage = [UIImage imageNamed:@"11.png"];
			}
		}
	}
	return emptyFolderCoverImage;
}

@end
