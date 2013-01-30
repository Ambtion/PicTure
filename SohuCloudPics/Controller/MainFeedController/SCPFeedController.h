//
//  FeedViewController.h
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-17.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "PullingRefreshController.h"
#import "FeedManager.h"
#import "SCPBaseController.h"
#import "SCPBaseNavigationItem.h"
#import "SCPMenuNavigationController.h"
#import "BannerForHeadView.h"


@class FeedManager;
@interface SCPFeedController : SCPBaseController
{
    SCPBaseNavigationItem * _item;
}
@property (strong, nonatomic) PullingRefreshController * pullingController;
@property (strong, nonatomic) FeedManager * manager;
@property (strong, nonatomic) SCPBaseNavigationItem * item;
@end
