//
//  SCPAlertView.h
//  testModalView
//
//  Created by Chen Chong on 12-9-27.
//  Copyright (c) 2012年 Chen Chong. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString *LOGIN_HINT = @"欢迎使用Sohu云图，您还没有登录，请您登录。登录后会记录您所喜欢的照片，可以分享您的照片给好友。";

@class SCPAlert_LoginView;

@protocol SCPAlertLoginViewDelegate <NSObject>
- (void)alertViewOKClicked:(SCPAlert_LoginView *)view;
@end

@interface SCPAlert_LoginView : UIView
{
    UIImageView *_backgroundImageView;
    UIImageView *_alertboxImageView;
    UILabel *_descLabel;
    UIButton *_cancelButton;
    UIButton *_okButton;
    
    id<SCPAlertLoginViewDelegate> _delegate;
}
- (id)initWithMessage:(NSString *)msg delegate:(id<SCPAlertLoginViewDelegate>)delegate;
- (void)show;

@end
