//
//  SCPFinishRegisterViewController.h
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPSecondLayerController.h"

@interface SCPFinishRegisterViewController : UIViewController

@property (strong, nonatomic) NSString *emailAddr;

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UILabel *emailLabel;
@property (strong, nonatomic) UIButton *emailButton;

- (id)initWithEmail:(NSString *)email;

@end
