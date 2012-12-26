//
//  SCPAlert_FeedBack.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-26.
//
//

#import <UIKit/UIKit.h>

@interface SCPAlert_FeedBack : UIView
{
    UIImageView *_backgroundImageView;
    UIImageView * _alertboxImageView;
    UITextView * desView;
    UITextField * textFiled;
    UIButton *_okButton;
    UIButton * _cancelbutton;
}
- (id)init;
- (void)show;
@end
