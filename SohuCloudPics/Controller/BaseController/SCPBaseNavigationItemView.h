//
//  SCPBaseNavigationIteam.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.



#import <UIKit/UIKit.h>

#import "RefreshButton.h"

@interface SCPBaseNavigationItemView : UIView
{
    UINavigationController * _navControleler;
    RefreshButton * _refreshButton;
}
@property(nonatomic,readonly) RefreshButton * refreshButton;

- (id)initWithNavigationController:(UINavigationController*)anNavController;
- (void)refreshButtonAddtarget:(id)target action:(SEL)action;
@end
