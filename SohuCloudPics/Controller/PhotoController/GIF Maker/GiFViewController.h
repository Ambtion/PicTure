//
//  GiFViewController.h
//  SohuCloudPics
//
//  Created by sohu on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "UIImage+ExternScale.h"
#import "FitterTabBar.h"
#import "GifDetail.h"
#import "FreeGifMaker.h"

@interface GiFViewController : UIViewController<GifDetailDelegate,FitterDelegate,UIGestureRecognizerDelegate>
{
    NSArray *_imageArray;
    UIView* _boundsView;
    UIImageView *_imageview;
    Float64 _durationTime;
    
    GifDetail * _gifResize;
    GifDetail * _gifDuration;
    
    FitterTabBar * _gifFitterBar;
    
    NSInteger _rotate;
    BOOL isHiddenFitter;
    
    UIButton* _playButton;
    UIActivityIndicatorView* _activity;
    UIAlertView* _waitView;
    UIButton* _saveButton;
    id _controller;
}
-(id)initWithImages:(NSArray*) array andDurationTimer:(Float64)time :(id)controller;
@property(retain, nonatomic)NSArray * imageArray;
@end
