//
//  SCPBaseNavigationIteam.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPBaseNavigationItem.h"

@implementation SCPBaseNavigationItem
@synthesize refreshButton = _refreshButton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        nav = nil;
        _refreshButton = nil;
    }
    return self;
}

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
        
        nav = navigation;
        [self addsubViews];
    }
    return self;
}

- (void)addsubViews
{
    _refreshButton = [[RefreshButton alloc] initWithFrame:CGRectMake(9, 9, 26, 26)];
    [self addSubview:_refreshButton];
}

- (void)addRefreshtarget:(id)target action:(SEL)action
{
    [_refreshButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
