//
//  SCPAlertView.h
//  testModalView
//
//  Created by Chen Chong on 12-9-27.
//  Copyright (c) 2012年 Chen Chong. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString *LOGIN_HINT = @"欢迎使用搜狐云图,留住回忆,分享快乐。登录后即可享受我们为您提供的图片云服务,轻松管理您的图片生活。";

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
