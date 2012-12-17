//
//  FitterTabBar.h
//  SohuCloudPics
//
//  Created by sohu on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FitterTabBar;
@protocol FitterDelegate <NSObject>
-(void)fitterAction:(UIButton*)button;
@end
@interface FitterTabBar : UIViewController
{
    id<FitterDelegate> _delegate;
    UIScrollView* _scrollview;
    UIImageView* _boundsview;
    NSMutableArray* _photoArray;
}
-(id)initWithdelegate:(id<FitterDelegate>)delegate;
@end
