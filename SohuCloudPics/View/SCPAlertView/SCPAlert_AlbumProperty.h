//
//  SCPAlert_AlbumProperty.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-10.
//
//

#import <UIKit/UIKit.h>
#import "ImageQualitySwitch.h"

@class SCPAlert_AlbumProperty;


@protocol SCPAlert_AlbumPropertyDelegate <NSObject>
- (void)albumProperty:(SCPAlert_AlbumProperty *)view OKClicked:(UITextField *)textField ispublic:(BOOL)isPublic;
@end

@interface SCPAlert_AlbumProperty : UIView
{
    UIImageView *_backgroundImageView;
    UIImageView *_alertboxImageView;
    UITextField *_renameField;
    ImageQualitySwitch * _public;
    id<SCPAlert_AlbumPropertyDelegate> _delegate;
    BOOL shouldRemove;
}
- (id)initWithDelegate:(id<SCPAlert_AlbumPropertyDelegate>)delegate name:(NSString *)name isPublic:(BOOL)isPublic;
- (void)show;
@end
