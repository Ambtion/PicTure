//
//  SCPFollowedListViewController.h
//  SohuCloudPics
//
//  Created by Zhong Sheng on 12-9-6.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullingRefreshController.h"
#import "SCPFollowedListManager.h"
#import "SCPMenuNavigationController.h"
#import "SCPSecondController.h"
#import "RefreshButton.h"

@interface SCPFollowedListViewController : SCPSecondController
{
    RefreshButton* _refreshButton;
}
@property (strong, nonatomic) PullingRefreshController *pullingController;
@property (strong, nonatomic) SCPFollowedListManager *manager;
@property (strong, nonatomic) RefreshButton* refreshButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil useID:(NSString *) use_ID;
@end
