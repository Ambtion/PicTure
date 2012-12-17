//
//  SCPFirstIntroController.h
//  SohuCloudPics
//
//  Created by mysohu on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCPFirstIntroController : UIViewController <UIScrollViewDelegate>{
    BOOL pageControlUsed;
    int kNumberOfPages;
}
@property (strong,nonatomic) UIViewController *parent;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIPageControl *pageControl;
@end
