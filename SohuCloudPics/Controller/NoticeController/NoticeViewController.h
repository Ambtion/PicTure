//
//  NoticeViewController.h
//  SohuCloudPics
//
//  Created by sohu on 12-11-15.
//
//

#import <UIKit/UIKit.h>

#import "PullingRefreshController.h"
#import "SCPMenuNavigationController.h"
#import "SCPSecondController.h"

#import "NoticeManager.h"

@class NoticeManager;
@interface NoticeViewController : SCPSecondController

@property (strong, nonatomic) PullingRefreshController *pullingController;
@property (strong, nonatomic) NoticeManager * manager;
@end
