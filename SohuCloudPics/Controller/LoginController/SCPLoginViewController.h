//
//  SCPLoginViewController.h
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EmailTextField.h"

#import "SCPAuthorizeViewController.h"

@class SCPLoginViewController;

@protocol SCPLoginViewDelegate <NSObject>

-(void)SCPLogin:(SCPLoginViewController * )LoginController cancelLogin:(UIButton*)button;
-(void)SCPLogin:(SCPLoginViewController * )LoginController doLogin:(UIButton*)button;

@end

@interface SCPLoginViewController : UIViewController<SCPAuthorizeViewControllerDelegate>

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIControl *backgroundControl;
@property (strong, nonatomic) EmailTextField *usernameTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *registerButton;
@property (strong, nonatomic) UIButton *loginButton;
@property (assign,nonatomic) id<SCPLoginViewDelegate> delegate;
@end
