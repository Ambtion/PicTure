//
//  SCPBaseNavigationIteam.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.

//  自定义NavigationIteam
//  ...
//  左边添加一个带旋转的刷新按钮

#import <UIKit/UIKit.h>
#import "RefreshButton.h"


@interface SCPBaseNavigationItem : UIView
{
    UINavigationController *nav;
    RefreshButton *_refreshButton;
    
}
- (id)initWithNavigationController:(UINavigationController*)navigation;
- (void)addRefreshtarget:(id)target action:(SEL)action;
@property(nonatomic,readonly) RefreshButton * refreshButton;
@end
