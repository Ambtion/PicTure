//
//  FlashButtom.h
//  test
//
//  Created by sohu on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashButton : UIViewController
{
    BOOL _isSegHidden;
    UIImageView* _imageView;
    SEL _action;
    id _controller;
}
@property(assign)NSInteger selection;
-(id)initWithOrinal:(CGPoint)point;
-(void)addtarget:(UIViewController*)controller  action:(SEL)Aaction;
@end
