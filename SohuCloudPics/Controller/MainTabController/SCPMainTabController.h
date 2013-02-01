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

//return tabContoller with childContollers: PlazeController and FeedController
- (id)initAndSetAllChildContrllers;
//switch section with animation
- (void)switchToindex:(NSInteger)index;
@end
