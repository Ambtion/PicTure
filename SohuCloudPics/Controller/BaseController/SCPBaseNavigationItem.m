//
//  SCPBaseNavigationIteam.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//  自定义NavigationIteam
//  左边添加一个自带旋转的刷新按钮

#import "SCPBaseNavigationItem.h"

@implementation SCPBaseNavigationItem
@synthesize refreshButton = _refreshButton;

- (void)dealloc
{
    if (_refreshButton) {
        [_refreshButton release];
    }
    [super dealloc];
}

- (id)initWithNavigationController:(UINavigationController *)navigation
{
    self = [self initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _nav = navigation;
        [self addsubViews];
    }
    return self;
}

- (void)addsubViews
{
    _refreshButton = [[RefreshButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    [self addSubview:_refreshButton];
}

- (void)addRefreshtarget:(id)target action:(SEL)action
{
    [_refreshButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
