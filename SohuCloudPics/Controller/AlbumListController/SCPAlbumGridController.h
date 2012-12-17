//
//  SCPAlbumListController.h
//  SohuCloudPics
//
//  Created by mysohu on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPAlbumController.h"


@interface SCPAlbumGridController : SCPAlbumController

@property (assign, nonatomic) int photoCount;
@property (retain, nonatomic) UILabel * currlabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil useID: (NSString *)use_ID;
@end
