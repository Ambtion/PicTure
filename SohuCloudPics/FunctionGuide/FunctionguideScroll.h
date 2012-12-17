//
//  FunctionguideScroll.h
//  SohuCloudPics
//
//  Created by sohu on 12-11-15.
//
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"


@interface FunctionguideScroll : UIViewController<UIScrollViewDelegate>
{
    UIScrollView * _scrollview;
    SMPageControl * _pagecontroll;
}
@end
