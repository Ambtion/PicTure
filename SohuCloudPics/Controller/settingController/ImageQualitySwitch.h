//
//  ImageQualitySwitch.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-29.
//
//

#import <UIKit/UIKit.h>

@interface ImageQualitySwitch : UIImageView
{
    UIButton * _button;
}
@property(nonatomic,assign)BOOL originalImage;
- (id)initWithFrame:(CGRect)frame WithOriginalImage:(BOOL)isPublic;
@end
