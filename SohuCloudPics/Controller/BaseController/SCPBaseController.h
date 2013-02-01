//
//  SCPBaseController.h
//  SohuCloudPics
//
//  Created by mysohu on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
// 定义手势,定义彩带行为:总是出现(viewDidAppear)
#import <UIKit/UIKit.h>
#import "SCPLoginPridictive.h"
#import "SCPAlert_CustomeView.h" //all view show totas
#import "SCPHorizontalGestureRecognizer.h"
#import "SCPBaseNavigationItemView.h"

@interface SCPBaseController : UIViewController <UIGestureRecognizerDelegate>
{
    float _lastOffset;
}
@property (strong, nonatomic) UISwipeGestureRecognizer *naviRecognizerDown;
@property (strong, nonatomic) UISwipeGestureRecognizer *naviRecognizerUp;
@property (strong, nonatomic) SCPHorizontalGestureRecognizer *slideRecognizerR2L;

- (void)showNavigationBar;
- (void)hideNavigationBar;
- (void)showCamera:(id)gesture;

//for banner string
- (NSString *)timeString;
@end
