//
//  PullingRefreshTableView.h
//  TableTry
//
//  Created by Zhong Sheng on 12-9-4.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGORefreshTableHeaderView.h"

@protocol PullingRefreshTableViewDelegate <NSObject, UITableViewDelegate>
@optional
@end

@class EGOManager;
@interface PullingRefreshTableView : UITableView
{
    EGORefreshTableHeaderView *_headerView;
    EGOManager *_egoManager;
}

@property (assign, nonatomic) NSObject<PullingRefreshTableViewDelegate> *pDelegate;
- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor style:(UITableViewStyle)style;
@end
