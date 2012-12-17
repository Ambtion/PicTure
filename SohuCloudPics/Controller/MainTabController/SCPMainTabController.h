//
//  SCPMainTabController.h
//  SohuCloudPics
//
//  Created by mysohu on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPBaseController.h"

#import "SCPHorizontalGestureRecognizer.h"

@interface SCPMainTabController : UITabBarController <UITabBarControllerDelegate>

@property (strong, nonatomic) SCPHorizontalGestureRecognizer *slideRecognizerL2R;

- (void)switchToindex:(NSInteger)index;

@end
