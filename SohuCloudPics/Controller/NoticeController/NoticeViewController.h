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
#import "SCPSecondLayerController.h"

#import "NoticeManager.h"

@class NoticeManager;
@interface NoticeViewController : SCPSecondLayerController

@property (strong, nonatomic) PullingRefreshController *pullingController;
@property (strong, nonatomic) NoticeManager * manager;
@end
