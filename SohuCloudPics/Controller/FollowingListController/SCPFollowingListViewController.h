//
//  SCPFollowingListViewController.h
//  SohuCloudPics
//
//  Created by Zhong Sheng on 12-9-6.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullingRefreshController.h"
#import "SCPFollowingListManager.h"
#import "SCPSecondLayerController.h"
#import "RefreshButton.h"

@interface SCPFollowingListViewController : SCPSecondLayerController
{
    RefreshButton* _refreshButton;
}

@property (strong, nonatomic) PullingRefreshController *pullingController;
@property (strong, nonatomic) SCPFollowingListManager *manager;
@property (strong, nonatomic) RefreshButton * refreshButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil useID:(NSString *) use_ID;
@end
