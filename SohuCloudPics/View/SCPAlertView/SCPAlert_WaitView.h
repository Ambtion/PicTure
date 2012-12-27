//
//  SCPWatiAlterView.h
//  SohuCloudPics
//
//  Created by sohu on 12-10-26.
//
//

#import <UIKit/UIKit.h>
#define ALERT 0

#ifdef ALERT
@interface SCPAlert_WaitView : UIView
{
    
    UILabel *alertTextLabel;
    UIImageView *backgroundView;
    UIActivityIndicatorView * activity;
    UIView * _superView;
}
- (id) initWithImage:(UIImage *)backgroundImage text:(NSString *)text withView:(UIView *)superView;
- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end
#else
@interface SCPAlert_WaitView : UIAlertView
{
    
    UILabel *alertTextLabel;
    UIImageView *backgroundView;
    UIActivityIndicatorView * activity;
}

@property(readwrite, retain) UIImage *backgroundImage;
@property(readwrite, retain) NSString *alertText;

- (id) initWithImage:(UIImage *)backgroundImage text:(NSString *)text withView:(UIView *)superView;
@end
#endif