//
//  EdtingTabbar.h
//  SohuCloudPics
//
//  Created by sohu on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EdtingTabbar;
@protocol EdtingTabbarDelegate <NSObject>
@required;
-(void)EdtingTabbar:(EdtingTabbar*)tarBar cutButton:(UIButton*)button;
-(void)EdtingTabbar:(EdtingTabbar*)tarBar translateButton:(UIButton*)button;
-(void)EdtingTabbar:(EdtingTabbar*)tarBar blurredButton:(UIButton*)button;
-(void)EdtingTabbar:(EdtingTabbar*)tarBar fitterButton:(UIButton*)button;
@end
@interface EdtingTabbar : UIViewController
{
    UIImageView* _bgview;
    id<EdtingTabbarDelegate> _delegate;
    BOOL isHiddenFitter;
}
-(id)initWithDeleggate:(id<EdtingTabbarDelegate>)delegete;
@end
