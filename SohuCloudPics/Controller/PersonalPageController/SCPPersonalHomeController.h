//
//  PersonalPageViewController.h
//  sohu_yuntu
//
//  Created by Qu on 12-8-29.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCPSecondController.h"
#import "PersonalHomeManager.h"

@interface SCPPersonalHomeController : SCPSecondController
{
    UIView *_footView;
}
@property (strong, nonatomic) PersonalHomeManager *manager;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView * footView;
@property (strong, nonatomic) UIButton * topButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil useID:(NSString *) use_ID;

@end
