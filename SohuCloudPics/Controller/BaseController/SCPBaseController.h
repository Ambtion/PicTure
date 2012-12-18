//
//  SCPBaseController.h
//  SohuCloudPics
//
//  Created by mysohu on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
// 定义手势,定义彩带总是出现(viewDidAppear)
#import <UIKit/UIKit.h>

#import "SCPLoginPridictive.h"
#import "SCPHorizontalGestureRecognizer.h"

@interface SCPBaseController : UIViewController <UIGestureRecognizerDelegate>
{
    float lastOffset;
    BOOL needHideNavigationBar;
}

@property (strong, nonatomic) UISwipeGestureRecognizer *naviRecognizerDown;
@property (strong, nonatomic) UISwipeGestureRecognizer *naviRecognizerUp;
@property (strong, nonatomic) SCPHorizontalGestureRecognizer *slideRecognizerR2L;

- (void)switchNavigationBar:(float)yOffset scrollView:(UIScrollView *)scrollView;
- (void)showNavigationBar;
- (void)hideNavigationBar;
- (NSString *)getTimeString;
@end
