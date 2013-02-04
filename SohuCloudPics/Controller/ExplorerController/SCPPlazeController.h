//
//  PlazeViewController.h
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-21.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshController.h"
#import "PlazeManager.h"
#import "SCPBaseController.h"
#import "SCPBaseNavigationItemView.h"
#import "SCPMenuNavigationController.h"

@interface SCPPlazeController : SCPBaseController
{
    SCPBaseNavigationItemView * _refreshItem;
}

@property (strong, nonatomic) PullingRefreshController* pullingController;
@property (strong, nonatomic) PlazeManager* manager;
@property (strong, nonatomic) SCPBaseNavigationItemView*  refreshItem;
@end
