//
//  SCPAlbumCell.h
//  SohuCloudPics
//
//  Created by Chen Chong on 12-11-14.
//
//

#import <UIKit/UIKit.h>


@protocol SCPAlbumCellDelegate <NSObject>
@optional
- (void)onImageViewClicked:(UIView *)imageView;
- (void)onImageViewLongPressed:(UIView *)imageView;
@end


@interface SCPAlbumCell : UITableViewCell

@property (assign, nonatomic) id <SCPAlbumCellDelegate> delegate;

- (void)onImageViewTapped:(UIGestureRecognizer *)gesture;
- (void)onImageViewLongPressed:(UILongPressGestureRecognizer *)gesture;

- (UIImage *)getEmptyFolderCoverImage;

@end
