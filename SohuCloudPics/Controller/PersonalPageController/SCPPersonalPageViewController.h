//
//  PersonalPageViewController.h
//  sohu_yuntu
//
//  Created by Qu on 12-8-29.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCPSecondLayerController.h"
#import "PersonalPageManager.h"

@interface SCPPersonalPageViewController : SCPSecondLayerController
{
    UIView *_footView;
}
@property (strong, nonatomic) PersonalPageManager *manager;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView * footView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil useID:(NSString *) use_ID;

@end
