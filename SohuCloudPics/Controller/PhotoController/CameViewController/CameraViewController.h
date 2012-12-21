//
//  CameraViewController.h
//  SohuCloudPics
//
//  Created by sohu on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+ExternScale.h"

#import "PhotoSwitch.h"
#import "FlashButton.h"
#import "Time.h"

#import "CameraImageBox.h"

@class CameraViewController;

@interface CameraViewController : UIViewController<phothswitchDelegate,UIAlertViewDelegate>
{
    CameraImageBox * camerBox;
    UIImageView * _preview;
    UIImageView * _tampview;
    UIImageView * _focusView;
    FlashButton * _flashButton;
    UIButton* _secenSwitch;
    
    UIImageView * _tabBarView;
    UIButton* _backButton;
    PhotoSwitch* _photoSwitch;
    UIButton* _photoBook;
    
    AVAssetImageGenerator * _imageGenerator;
    NSMutableArray* _gifArray;
    UIActivityIndicatorView * _alview;
    Time * _timeLabel;
    NSTimer * _timer;
    Float64 durationSeconds;
    
    BOOL isBack;
    BOOL isForwardImage;
    BOOL isForwardGif;
    BOOL isForwardPhoto;
    BOOL outPutImage;
}
@property(retain,nonatomic)UIImageView* preview;
@property(retain,nonatomic)UIImage * imageForTemp;
@property(retain,nonatomic)AVAssetImageGenerator * imageGenerator;
@end
