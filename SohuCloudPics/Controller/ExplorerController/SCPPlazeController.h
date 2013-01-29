//
//  ExploreViewController.h
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-21.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullingRefreshController.h"
#import "SCPBaseController.h"
#import "SCPBaseNavigationItem.h"
#import "SCPMenuNavigationController.h"

#import "PlazeManager.h"

@interface SCPPlazeController : SCPBaseController
{
    SCPBaseNavigationItem * _item;
}

@property (strong, nonatomic) PullingRefreshController* pullingController;
@property (strong, nonatomic) PlazeManager* manager;
@property (strong, nonatomic) SCPBaseNavigationItem*  item;
@end
