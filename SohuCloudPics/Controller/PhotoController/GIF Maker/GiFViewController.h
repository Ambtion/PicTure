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

@class GiFViewController;
@protocol GifViewDelegate <NSObject>
-(void)GiFViewController:(GiFViewController *)Gifview saveGif:(NSData *)data;
@end
@interface GiFViewController : UIViewController<GifDetailDelegate,FitterDelegate>
{
    NSArray *_imageArray;
    UIView* _boundsView;
    UIImageView *_imageview;
    Float64 _durationTime;
    
    GifDetail * _gifResize;
    GifDetail * _gifDuration;
    
    FitterTabBar * _gifFitterBar;
    
    NSInteger _rotate;
    id<GifViewDelegate> _delegate;
    BOOL isHiddenFitter;
    
    UIButton* _playButton;
    UIActivityIndicatorView* _activity;
    UIAlertView* _waitView;
    UIButton* _saveButton;
}
-(id)initWithImages:(NSArray*) array andDurationTimer:(Float64)time;
@property(retain)NSArray * imageArray;
@property(retain)id<GifViewDelegate> delegate;
@end
