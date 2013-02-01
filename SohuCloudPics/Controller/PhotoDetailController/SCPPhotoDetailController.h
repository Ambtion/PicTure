//
//  SCPPhotoDetailViewController.h
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullingRefreshController.h"
#import "SCPSecondController.h"
#import "PhotoDetailManager.h"

@class PhotoDetailManager;
@interface SCPPhotoDetailController : SCPSecondController

@property (strong, nonatomic) PhotoDetailManager *manager;
@property (strong, nonatomic) PullingRefreshController *pullingController;

- (id)initWithuseId:(NSString*) useId photoId:(NSString*)photoId;
@end
