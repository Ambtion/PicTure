//
//  ImageEdtingController.m
//  SohuCloudPics
//
//  Created by sohu on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ImageEdtingController.h"
#import "ImageUtil.h"
#import "UIImage+ExternScale.h"
#import "SCPMenuNavigationController.h"
#import "Filterlibrary.h"
#import "SCPUploadController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageToolBox.h"
#import "SCPLoginPridictive.h"
#import "SCPAlertView_LoginTip.h"


#define IMAGE_OUTPATH [[[NSString alloc] initWithFormat:@"%@/Documents/%@",NSHomeDirectory(), @"originalImage.jpeg"]autorelease]

@implementation UIImage (fixOrientation)

- (UIImage *)fixOrientation {
    
//    NSLog(@"imageOrientation::%d",self.imageOrientation);
    
    // No-op if the orientation is already correct
    
    if (self.imageOrientation == UIImageOrientationUp) return self;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            
            //            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            //            transform = CGAffineTransformRotate(transform, - M_PI_2);/*还原*/
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, - M_PI_2);
            
            //            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            //            transform = CGAffineTransformRotate(transform, M_PI_2);/*还原*/
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            //            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

@implementation ImageEdtingController
@synthesize delegate;
@synthesize originalImage = _originalImage,originalThumbImage = _originalThumbImage,filterImage = _filterImage,assetURL = _assetURL;
@synthesize groupName = _groupName;
- (void)dealloc
{
    [self stopWait];
    self.filterImage = nil;
    [_originalImage release];
    [_originalThumbImage release];
    [_imageview release];
    [_topBar release];
    [_tabBar release];
    [_clipview release];
    [_fitteBar release];
    [_library release];
    [_shadowView release];
    self.assetURL = nil;
    self.groupName = nil;
    [Filterlibrary removeCachedAllImageData];
    [super dealloc];
}

#pragma customize NavigationBar
-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setHidden:YES];
    if ([self.navigationController isKindOfClass:[SCPMenuNavigationController class]])
        [(SCPMenuNavigationController *)self.navigationController setDisableRibbon:NO];
    [Filterlibrary removeCachedAllImageData];
    
}
#pragma mark -
#pragma mark initData
-(id)initWithUIImage:(UIImage *)image controller: (id)Acontroller
{
    self = [super init];
    if (self) {
        controller = Acontroller;
        [self initdataContainer];
        [self compressImage:image];
        self.originalImage = [image fixOrientation];
        [self addSubViews];
    }
    return self;
}
-(id)initWithAsset:(NSURL *)url info:(id)info :(NSInteger)num
{
    self = [super init];
    if (self) {
        self.originalImage = nil;
        infoNum = num;
        _info = info;
        self.assetURL = url;
        [self initdataContainer];
        [_library assetForURL:self.assetURL resultBlock:^(ALAsset *asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage * image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                [self compressImage:image];
                [self addSubViews];
            });
        } failureBlock:^(NSError *error) {
//            NSLog(@"initWithAsset : %@",error);
        }];
    }
    return self;
}
-(void)initdataContainer
{
    if (_library == nil) {
        _library = [[ALAssetsLibrary alloc] init];
    }
     _isBlured = NO;
    _filternum = -1;
    _angleNum = 0;
    _roationScale = 1.f;
    _scale_compress = 0.f;
    _clearPoint = CGPointMake(160, 200);
}
-(void)compressImage:(UIImage*)image
{
    
    CGFloat scaleX = 0;
    CGFloat scaleY = 0;
    if (image.size.width >= 600 | image.size.height >= 800) {
        scaleX = image.size.width / 600;
        scaleY = image.size.height / 800;
    }
    _scale_compress = MAX(scaleX, scaleY);
    if (_scale_compress && _scale_compress != 1 ) {
        self.originalThumbImage = [ImageToolBox image:image ByScaling:_scale_compress]; // 4:3 - > 4:2.9
        
    }else{
        self.originalThumbImage = [ImageToolBox image:image ByScaling:1];
        _scale_compress = 1;
    }
    self.filterImage = self.originalThumbImage;
}

#pragma mark -
#pragma mark initView
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"camera_bg.png"]];
    //reload gesture
    UISwipeGestureRecognizer * right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:nil];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
    [right release];
    
}
-(void)addSubViews
{
    [self addImageview];
    [self addGusture:_imageview];
    [self addViewBar];
    [self addTabbar];
    
}
-(void)addImageview
{
//    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    CGRect rect = CGRectMake(0, 0, self.originalThumbImage.size.width /2, self.originalThumbImage.size.height /2);
    _imageview = [[UIImageView alloc] initWithFrame:rect];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [_imageview.layer addAnimation:transition forKey:nil];
    
    _imageview.center = CGPointMake(160, (self.view.bounds.size.height - 49) / 2.f);
    [self.view addSubview:_imageview];
    [_imageview setUserInteractionEnabled:YES];
    
    _imageview.image = self.originalThumbImage;
    
    //设置投影
    _imageview.layer.shadowColor = [UIColor blackColor].CGColor;
    _imageview.layer.shadowOffset = CGSizeMake(0, 2);
    _imageview.layer.shadowOpacity = 0.5;
    _imageview.layer.shadowRadius = 1;
    _imageview.layer.masksToBounds = NO;
    _imageview.layer.shouldRasterize  = YES;
    
    _shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EdtingShadow.png"]];
    CGFloat scale = rect.size.width / 300;
    _shadowView.backgroundColor = [UIColor clearColor];
    _shadowView.frame = CGRectMake(- 5 * scale , - 2 * scale , rect.size.width + 10 * scale, rect.size.height + 10 * scale);
    [_imageview addSubview:_shadowView];
    
}

#pragma mark-
#pragma mark UIViewTopBar
-(void)addViewBar
{
    _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
    _topBar.backgroundColor = [UIColor clearColor];
    UIButton* backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame = CGRectMake(15, 15, 70, 40);
    [backbutton setBackgroundImage:[UIImage imageNamed:@"camera_cancel.png"] forState:UIControlStateNormal];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"camera_cancel_2.png"] forState:UIControlStateHighlighted];
    [backbutton addTarget:self action:@selector(backTop:) forControlEvents:UIControlEventTouchUpInside];
    [_topBar addSubview:backbutton];
    
    UIButton* nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(235, 15, 70, 40);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"camera_next_normal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"camera_next_press.png"] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(buttonSave:) forControlEvents:UIControlEventTouchUpInside];
    
    [_topBar addSubview:nextButton];
    [self.view addSubview:_topBar];
    
}
#pragma mark -
#pragma mark UIViewTobBar
-(void)addTabbar
{
    _tabBar = [[EdtingTabbar alloc] initWithDeleggate:self];
}
#pragma mark -
#pragma mark tabButtonClick
-(void)EdtingTabbar:(EdtingTabbar *)tarBar cutButton:(UIButton *)button
{
    
    if (_clipview == nil) {
        
//        NSLog(@"%d %@",button.tag,_clipview);
        _clipview = [[UICliper alloc] initWithImageView:_imageview];
        [button setBackgroundImage:[UIImage imageNamed:@"crop_2.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"crop_2.png"] forState:UIControlStateHighlighted];
        
    }else {
        
        [button setBackgroundImage:[UIImage imageNamed:@"crop.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"crop.png"] forState:UIControlStateHighlighted];
        [_clipview removeFromSuperview];
        [_clipview release];
        _clipview = nil;
    }
}

-(void)EdtingTabbar:(EdtingTabbar *)tarBar translateButton:(UIButton *)button
{
    [self setRotation:1 animated:YES];
}
-(void)EdtingTabbar:(EdtingTabbar *)tarBar blurredButton:(UIButton *)button
{
    if (_isBlured == NO) {
        
        [button setBackgroundImage:[UIImage imageNamed:@"模糊-2.png"] forState:UIControlStateNormal];
        _clearPoint = CGPointMake(_imageview.frame.origin.x + _imageview.bounds.size.width / 2.f, _imageview.frame.origin.y +
                                  _imageview.bounds.size.height/2.f);
        
        _imageview.image = [ImageToolBox image:self.filterImage addRadiuOnBlurimage:_clearPoint scale:1];
        
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"模糊.png"] forState:UIControlStateNormal];
        _imageview.image = self.filterImage;
        _clearPoint = CGPointMake(160, 200);
    }
    _isBlured = !_isBlured;
    
}
-(void)EdtingTabbar:(EdtingTabbar *)tarBar fitterButton:(UIButton *)button
{
    if (_fitteBar == nil) {
        _fitteBar = [[FitterTabBar alloc] initWithdelegate:self];
    }
    if (_fitteBar.view.superview == nil) {
        _fitteBar.view.frame = CGRectMake(0, self.view.frame.size.height - 144, 320, 100);
        [self.view addSubview:_fitteBar.view];
    }else {
        [_fitteBar.view removeFromSuperview];
    }
}
#pragma mark -
#pragma mark Blur
-(void)addGusture:(UIImageView*)view
{
    UITapGestureRecognizer* tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressGuesture:)] autorelease];
    [view addGestureRecognizer:tap];
}
-(void)tapPressGuesture:(UILongPressGestureRecognizer*)gesture
{
//    NSLog(@"tapGuesture");
    if (_isBlured == NO) {
        return;
    }
    if (gesture.state != UIGestureRecognizerStateBegan) {
//        NSLog(@"touchesBegan");
        //first get current image
        CGPoint  point = [gesture locationInView:_imageview];
        _clearPoint = point;
        _imageview.image = [ImageToolBox image:self.filterImage addRadiuOnBlurimage:_clearPoint scale:1];
//        NSLog(@"%@",NSStringFromCGPoint(point));
    }
}

#pragma mark-
#pragma mark Rotaion
- (void)setRotation:(NSInteger)theRotation animated:(BOOL)animated
{
    _angleNum +=  theRotation;
    if (_angleNum % 4 == 0) {
        [self setimageViewTransformIdentity];
        _angleNum = 0;
        _roationScale = 1.f;
        return;
    }
    if (_angleNum == M_PI * 2 ||_angleNum == -2 * M_PI ) {
        _angleNum = 0.0f;
    }
    CGAffineTransform translate = CGAffineTransformRotate(_imageview.transform,M_PI_2 * theRotation);
    if (translate.a == 0) {
        //横放
        _roationScale = 320 / _imageview.frame.size.height;
    }else {
        _roationScale = 1 / _roationScale;
    }
    
    CGAffineTransform finalTranslate = CGAffineTransformScale(translate, _roationScale, _roationScale);
    
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        _imageview.transform = finalTranslate;
        [UIView commitAnimations];
    }else {
        _imageview.transform = finalTranslate;
    }
    
}
-(void)setimageViewTransformIdentity
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    _imageview.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark fitterbatDelegate

-(void)fitterAction:(UIButton *)button
{
    if (button.tag == 500) {
        //originalImage
        _filternum = -1;
        self.filterImage = self.originalThumbImage;
        if (_isBlured) {
            _imageview.image = [ImageUtil image:self.originalThumbImage stackBlur:15];
            _imageview.image = [ImageToolBox image:self.filterImage addRadiuOnBlurimage:_clearPoint scale:1];
        }else{
            _imageview.image = self.originalThumbImage;
        }
        return;
    }
    _filternum = button.tag - 1000;
    [self outputImageWithfilter:button :_filternum];
}
-(void)outputImageWithfilter:(UIButton*)button :(NSInteger)number
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage * image = [Filterlibrary cachedDataForName:number];
        if (image) {
            self.filterImage = image;
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageview.image = self.filterImage;
                if (_isBlured)
                    _imageview.image = [ImageToolBox image:self.filterImage addRadiuOnBlurimage:_clearPoint scale:1];
                
                [self stopWait];
            });
        }else{
            self.filterImage = [ImageUtil imageWithImage:self.originalThumbImage withMatrixNum:number];
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageview.image = self.filterImage;
                if (_isBlured)
                    _imageview.image = [ImageToolBox image:self.filterImage addRadiuOnBlurimage:_clearPoint scale:1];
                [self stopWait];
                [Filterlibrary storeCachedOAuthData:self.filterImage forName:number];
            });
        }
    });
    
}
#pragma mark -
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.filterImage = nil;
    [Filterlibrary removeCachedAllImageData];
    [_originalImage release];
    [_originalThumbImage release];
    [_imageview release];
    [_topBar release];
    [_tabBar release];
    [_clipview release];
    [_fitteBar release];
}
#pragma mark -
#pragma mark TopbuttonClick
-(void)backTop:(UIButton*)button
{
    if ([delegate respondsToSelector:@selector(imageEdtingDidBack:)]) {
        [delegate imageEdtingDidBack:self];
        return;
    }
    [controller dismissModalViewControllerAnimated:YES];
}
-(void)buttonSave:(UIButton*)button
{
    [self renderDefaultImage];
}
- (void)dismissController
{
    [self stopWait];
    [controller dismissModalViewControllerAnimated:YES];
}
-(void)renderDefaultImage
{
    if (self.originalImage) {
        [self waitForMomentsWithTitle:@"保存到本地"];
        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self modifImage];
        });
        return;
    }
    [self waitForMomentsWithTitle:@"保存到本地"];
    [_library assetForURL:self.assetURL resultBlock:^(ALAsset *asset) {
        self.originalImage = [UIImage imageWithCGImage:[asset defaultRepresentation].fullResolutionImage];
        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self modifImage];
        });
    } failureBlock:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
    
}
- (void)modifImage
{
    
    if (_filternum != -1)
        self.originalImage = [ImageUtil imageWithImage:self.originalImage withMatrixNum:_filternum];
    if (_isBlured)
        self.originalImage = [ImageToolBox image:self.originalImage addRadiuOnBlurimage:_clearPoint scale:_scale_compress];
    if (_clipview.superview)
        self.originalImage = [ImageToolBox image:self.originalImage clipinRect:[_clipview getclipRect] scale:_scale_compress];
    if (_angleNum)
        self.originalImage = [ImageToolBox image:self.originalImage afterRotate:_angleNum];
    
    [self fixImageView];
    [self writeToAlbum];
    [self initdataContainer];
}

-(void)fixImageView
{
    _imageview.transform = CGAffineTransformIdentity;
    if (_clipview.superview)
        _imageview.image = [ImageToolBox image:_imageview.image clipinRect:[_clipview getclipRect] scale:1];
    if (_angleNum)
        _imageview.image = [ImageToolBox image:_imageview.image afterRotate:_angleNum];
    CGPoint center = _imageview.center;
    _imageview.frame = CGRectMake(0, 0, _imageview.image.size.width /2.f, _imageview.image.size.height / 2.f);
    _imageview.center = center;
}
-(void)writeToAlbum
{
    [_library writeImageToSavedPhotosAlbum:self.originalImage.CGImage orientation:(ALAssetOrientation)[self.originalImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            [self showTipForSecretImageSetting];
            return ;
        }
        if (![SCPLoginPridictive isLogin]) {
            [controller dismissModalViewControllerAnimated:YES];
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(imageEdtingDidSave:imageinfo:info:num:)]) {
                [delegate imageEdtingDidSave:self imageinfo:assetURL info:_info num:infoNum];
                return;
            }
            [_library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                if (!asset) return ;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableDictionary * workingDictionary = [[NSMutableDictionary alloc] init];
                    [workingDictionary setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
                    [workingDictionary setObject:asset.defaultRepresentation.url forKey:@"UIImagePickerControllerRepresentationURL"];
                    [workingDictionary setObject:[UIImage imageWithCGImage:[asset aspectRatioThumbnail] ]forKey:@"UIImagePickerControllerThumbnail"];
                    [self stopWait];
                    SCPUploadController * ctrl = [[[SCPUploadController alloc] initWithImageToUpload:[NSArray arrayWithObject:workingDictionary] :controller] autorelease];
                    [self.navigationController pushViewController:ctrl animated:YES];
                    [workingDictionary release];
                });
            } failureBlock:^(NSError *error) {
//                NSLog(@"%@",error);
            }];
        });
    }];
}
- (void)showTipForSecretImageSetting
{
    [self stopWait];
    SCPAlertView_LoginTip * tip = [[[SCPAlertView_LoginTip alloc] initWithTitle:@"提示信息" message:@"请确认已在设置->隐私->照片中打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
    [tip show];
}
#pragma mark-

-(void)waitForMomentsWithTitle:(NSString*)str
{
    _alterView = [[SCPAlert_WaitView alloc] initWithImage:[UIImage imageNamed:@"pop_alert.png"] text:str withView:self.view];
    [_alterView show];
}

-(void)stopWait
{
    if(_alterView){
        [_alterView dismissWithClickedButtonIndex:0 animated:YES];
        [_alterView release],_alterView = nil;
    }
}


@end
