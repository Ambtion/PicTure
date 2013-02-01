//
//  FunctionguideScroll.h
//  SohuCloudPics
//
//  Created by sohu on 12-11-15.
//
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"

#define FUNCTIONSHOWED @"__FUNCTIONSHOWED__"

@class FunctionGuideController;

@protocol FunctionGuideControllerDelegate <NSObject>
- (void)functionGuideController:(FunctionGuideController * )anController clickUserButton:(UIButton *)button;
@end

@interface FunctionGuideController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    SMPageControl * _pageControll;
}
@property(nonatomic,assign)id<FunctionGuideControllerDelegate> delegate;
@end
