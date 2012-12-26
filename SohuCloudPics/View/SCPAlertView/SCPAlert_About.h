//
//  SCPAlert_About.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-26.
//
//

#import <UIKit/UIKit.h>

@interface SCPAlert_About : UIView
{
    UIImageView *_backgroundImageView;
    UIImageView * _alertboxImageView;
    UILabel *_descLabel;
    UIButton *_okButton;
}
- (id)initWithTitle:(NSString *)title;
- (void)show;
@end
