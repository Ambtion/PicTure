//
//  ImageEdtingController.h
//  SohuCloudPics
//
//  Created by sohu on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EdtingTabbar.h"
#import "FitterTabBar.h"
#import "UICliper.h"

#import "SCPAlert_WaitView.h"

@class ALAssetsLibrary;
@class ALAsset;
@class ImageEdtingController;
@protocol ImageEdtingDelegate <NSObject>
-(void)imageEdtingDidBack:(ImageEdtingController*)imageEdting;
-(void)imageEdtingDidSave:(ImageEdtingController *)imageEdting imageinfo:(NSURL *)assetURL info:(id)info num:(NSInteger)tag;
@end
@interface ImageEdtingController : UIViewController<EdtingTabbarDelegate,FitterDelegate>
{
    id controller;
    UIImageView* _imageview;
    UIImageView* _shadowView;
    UIImage* _originalImage;
    UIImage* _originalThumbImage;
    UIImage* _filterImage;
    
    UIView * _topBar;
    EdtingTabbar* _tabBar;
    UICliper * _clipview;
    FitterTabBar* _fitteBar;
    CGFloat _roationScale;

    
    CGFloat _scale_compress;
    NSInteger   _angleNum;
    CGPoint _clearPoint;
    NSInteger _filternum;
    
    ALAssetsLibrary * _library;
    BOOL _isBlured;
    BOOL _writeEnd;
    SCPAlert_WaitView * _alterView;
    id _info;
    NSInteger infoNum;
}
@property(nonatomic,retain)UIImage* originalImage;
@property(nonatomic,retain)UIImage* originalThumbImage;
@property(nonatomic,retain)UIImage* filterImage;
@property(nonatomic,retain)NSURL * assetURL;
@property(nonatomic,retain)NSString * groupName;
@property(nonatomic,assign)id<ImageEdtingDelegate> delegate;
-(id)initWithUIImage:(UIImage *)image controller: (id)Acontroller;
-(id)initWithAsset:(NSURL *)url info:(id)info :(NSInteger)num;
@end
