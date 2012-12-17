//
//  SCPPhotoDetailViewController.h
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullingRefreshController.h"
#import "PhotoDetailManager.h"
#import "CommentPostBar.h"
#import "SCPSecondLayerController.h"

@class PhotoDetailManager;
@interface SCPPhotoDetailViewController : SCPSecondLayerController <CommentPostBarDelegate>

@property (strong, nonatomic) PhotoDetailManager *manager;
@property (strong, nonatomic) PullingRefreshController *pullingController;
@property (strong, nonatomic) CommentPostBar *commentPostBar;

- (id)initWithinfo:(NSDictionary *)dic;
- (id)initWithuseId:(NSString*) useId photoId:(NSString*)photoId;

- (void)displayCommentPostBar;
- (void)dismissCommentPostBar;

@end
