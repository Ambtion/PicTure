//
//  SCPPhotoListScrollview.m
//  UISCrollView_NetWork
//
//  Created by sohu on 12-11-26.
//  Copyright (c) 2012年 Qu. All rights reserved.
//

#import "SCPPhotoListController.h"
#import "SCPAppDelegate.h"
#import "SCPPhotoDetailViewController.h"
#import "SCPMenuNavigationController.h"

#define OFFSET 20


@class SCPPhotoListController;

@implementation InfoImageView

@synthesize info;
@synthesize actV;
@synthesize webView;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.actV = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        actV.center = CGPointMake(self.frame.size.width/ 2.f, self.frame.size.height/2.f);
        actV.hidesWhenStopped = YES;
        [self addSubview:actV];
    
    }
    return self;
}
- (id)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image]) {
        self.actV = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        actV.center = CGPointMake(self.frame.size.width/ 2.f, self.frame.size.height/2.f);
        actV.hidesWhenStopped = YES;
        [self addSubview:actV];
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    actV.center = CGPointMake(self.frame.size.width/ 2.f, self.frame.size.height/2.f);
}
- (void)playGif:(NSURL *)url
{
//    使用UIWebView播放
    // 设定位置和大小
    CGRect frame = CGRectZero;
    frame = self.bounds;
    // 读取gif图片数据
    
    NSData *gif = [NSData dataWithContentsOfURL:url];
    // view生成
    self.webView = [[[UIWebView alloc] initWithFrame:frame] autorelease];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.userInteractionEnabled = NO;//用户不可交互
    [self.webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [self addSubview:self.webView];
}
- (void)resetGigView
{
    [self.webView removeFromSuperview];
    self.webView = nil;
}
- (void)dealloc
{
    self.info = nil;
    self.actV = nil;
    self.webView = nil;
    [super dealloc];
}

@end

@implementation SCPPhotoListController
@synthesize tempView;
@synthesize info = _info;
@synthesize bgView = _bgView;
@synthesize scrollView = _scrollView;
@synthesize fontScrollview = _fontScrollview;
@synthesize fontImageView = _fontImageView;
@synthesize curscrollView = _curscrollView;
@synthesize currentImageView = _currentImageView;
@synthesize rearImageView = _rearImageView;
@synthesize rearScrollview = _rearScrollview;
- (void)dealloc
{
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [_requestManger setDelegate:nil];
    [_requestManger release];
    self.tempView = nil;
    self.bgView = nil;
    self.scrollView = nil;
    self.fontImageView  = nil;
    self.fontScrollview = nil;
    self.currentImageView = nil;
    self.curscrollView  = nil ;
    self.rearImageView = nil;
    self.rearScrollview = nil;
    [imageArray release];
    [curImages release];
    self.info = nil;
    [super dealloc];
    
}

- (id)initWithUseInfo:(NSDictionary * ) info : (PhotoDetailManager *)dataManager
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.view.backgroundColor = [UIColor redColor];
        _dataManager = dataManager;
        
        imageArray = [[NSMutableArray alloc] initWithCapacity:0];
        curImages = [[NSMutableArray alloc] initWithCapacity:0];
        curPage = 0;
        Pagenum = 1;
        animation = NO;
        hasNextPage = YES;
        self.info = info;
        isInit = YES;
        isLoading = NO;
        _requestManger = [[SCPRequestManager alloc] init];
        _requestManger.delegate = self;
        [self initSubViews];
        [self.view setUserInteractionEnabled:NO];
        [_requestManger getFolderinfoWihtUserID:[NSString stringWithFormat:@"%@",[self.info objectForKey:@"user_id"]] WithFolders:[NSString stringWithFormat:@"%@",[info objectForKey:@"folder_id"]]];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(listOrientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}
#pragma mark Ratation
- (CGAffineTransform )getTransfrom
{
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIInterfaceOrientationIsPortrait(orientation))
        return CGAffineTransformIdentity;
    if (orientation == UIInterfaceOrientationLandscapeLeft)
        return CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI_2);
    if (orientation == UIInterfaceOrientationLandscapeRight)
        return CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
    return CGAffineTransformIdentity;
}

- (void)listOrientationinit
{
    
    if (CGAffineTransformEqualToTransform([self getTransfrom], CGAffineTransformIdentity)) {
        self.view.frame = [UIScreen mainScreen].bounds;
        [self initSubViews];
    }else{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
        [self initSubViews];
        self.view.transform = [self getTransfrom];
    }
}
- (void)listOrientationChanged:(NSNotification *)notification
{
    [self.view setUserInteractionEnabled:NO];
    animation = YES;
    CGFloat scale = 1.0;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if (CGAffineTransformEqualToTransform([self getTransfrom], CGAffineTransformIdentity)) {
        transform = CGAffineTransformInvert(self.view.transform);
        if ([self getCurrentImageView].image.size.height > self.view.frame.size.height ||
            [self getCurrentImageView].image.size.width > self.view.frame.size.width) {
            scale = MIN( 320.f / [self getCurrentImageView].frame.size.width, 480.f / [self getCurrentImageView].frame.size.height);
        }else{
            scale = 1.0f;
        }
    }else{
        if ([self getCurrentImageView].image.size.height > self.view.frame.size.height ||
            [self getCurrentImageView].image.size.width > self.view.frame.size.width) {
            scale = MIN( 480.f / [self getCurrentImageView].frame.size.width, 320.f / [self getCurrentImageView].frame.size.height);
        }else{
            scale = 1.0f;
        }
        transform = [self getTransfrom];
    }
    transform  = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(scale, scale));
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut    animations:^{
        [self getCurrentImageView].transform = transform;
    } completion:^(BOOL finished) {
        self.view.transform = [self getTransfrom];
        if (CGAffineTransformEqualToTransform(self.view.transform, CGAffineTransformIdentity))
            self.view.frame = [UIScreen mainScreen].bounds;
        [self initSubViews];
        [self.view setUserInteractionEnabled:YES];
        animation = NO;
    }];
    
}

#pragma mark - Delegate
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    isLoading = NO;
//    NSLog(@"%@",info);
    NSDictionary * folderinfo = [info objectForKey:@"folderInfo"];
    NSDictionary * photolist = [info objectForKey:@"photoList"];
    if ([folderinfo allKeys]) {
        photoNum = [[folderinfo objectForKey:@"photo_num"] intValue];
    }
    Pagenum = [[photolist objectForKey:@"page"] intValue];
    hasNextPage = [[photolist objectForKey:@"has_next"] boolValue];
    [imageArray addObjectsFromArray:[photolist objectForKey:@"photos"]];
    curPage =  [self getindexofImages];
    [self.view setUserInteractionEnabled:YES];
    NSLog(@"MMMMMMM %d %d",curPage, imageArray.count);
    if (curPage == -1) {
        [self getMoreImage];
    }else{
        [self refreshScrollView];
    }
}
- (void)requestFailed:(NSString *)error
{
    isLoading = NO;
    [self.view setUserInteractionEnabled:YES];
    SCPAlert_CustomeView * alertView = [[[SCPAlert_CustomeView alloc] initWithTitle:error] autorelease];
    [alertView show];
}
- (NSInteger)getindexofImages
{
    BOOL isFound = NO;
    int i = 0;
    for (; i < imageArray.count; i++) {
        NSDictionary * dic = [imageArray objectAtIndex:i];
        if ([[dic objectForKey:@"photo_url"] isEqual:[self.info objectForKey:@"photo_url"]]) {
            isFound = YES;
            break;
        }
    }
    if (isFound){
        return i;
    }
    return -1;
}

- (void)getMoreImage
{
    NSLog(@"%s",__FUNCTION__);
    if (photoNum <= imageArray.count || isLoading || !hasNextPage) {
        NSLog(@" MORE  %s",__FUNCTION__);
        return;
    }
    NSLog(@"%@",self.info);
    isLoading = YES;
    [self.view setUserInteractionEnabled:NO];
    [_requestManger getPhotosWithUserID :[NSString stringWithFormat:@"%@",[self.info objectForKey:@"user_id"]] FolderID:[NSString stringWithFormat:@"%@",[_info objectForKey:@"folder_id"]] page:Pagenum + 1];
    
}
#pragma mark - InitSubView

- (void)initSubViews
{
    CGRect rect = self.view.frame;
    rect.size.width += OFFSET * 2;
    rect.origin.x -= OFFSET;
    
    self.bgView = [[[UIView alloc] initWithFrame:rect] autorelease];
    self.bgView.backgroundColor = [UIColor blackColor];
    [self.view  addSubview:self.bgView];
    
    self.scrollView = [[[UIScrollView alloc] initWithFrame:self.bgView.bounds] autorelease];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor blackColor];
    [self.bgView addSubview:self.scrollView];
    
    [self addFontScrollView];
    [self addCurScrollView];
    [self addrearScrollView];
    [self setScrollViewProperty];
    [self refreshScrollView];
    
}
- (void)addFontScrollView
{
    self.fontScrollview = [[[UIScrollView alloc] initWithFrame:CGRectMake(OFFSET, 0, self.scrollView.frame.size.width - OFFSET * 2, self.scrollView.bounds.size.height)] autorelease];
    self.fontScrollview.delegate = self;
    self.fontScrollview.minimumZoomScale = 1.f;
    self.fontScrollview.backgroundColor = [UIColor clearColor];
    self.fontScrollview.contentMode = UIViewContentModeCenter;
    
    [self.scrollView addSubview:self.fontScrollview];
    self.fontImageView = [[[InfoImageView alloc] initWithFrame:self.fontScrollview.bounds] autorelease];
    self.fontImageView.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizeronView:self.fontScrollview];
    
    [self.fontScrollview  addSubview:self.fontImageView];
    self.curscrollView.showsHorizontalScrollIndicator = NO;
    self.curscrollView.showsVerticalScrollIndicator = NO;
    
}
- (void)addCurScrollView
{
    self.curscrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width + OFFSET, 0, self.scrollView.frame.size.width - OFFSET * 2, self.scrollView.frame.size.height)] autorelease];
    self.curscrollView.delegate = self;
    self.curscrollView.minimumZoomScale  = 1.f;
    self.curscrollView.backgroundColor = [UIColor clearColor];
    self.curscrollView.contentMode = UIViewContentModeCenter;
    [self.scrollView addSubview:self.curscrollView];
    self.currentImageView = [[[InfoImageView alloc] initWithFrame:self.curscrollView.bounds] autorelease];
    self.currentImageView.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizeronView:self.curscrollView];
    [self.curscrollView addSubview:self.currentImageView];
    self.curscrollView.showsHorizontalScrollIndicator = NO;
    self.curscrollView.showsVerticalScrollIndicator = NO;
    self.currentImageView.info =  self.info;
    [self resetImageFrame:self.currentImageView];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
}
- (void)addrearScrollView
{
    
    self.rearScrollview = [[[UIScrollView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * 2 + OFFSET, 0, self.scrollView.frame.size.width - OFFSET * 2, self.scrollView.frame.size.height)] autorelease];
    self.rearScrollview.delegate = self;
    self.rearScrollview.minimumZoomScale = 1.f;
    self.rearScrollview.backgroundColor = [UIColor clearColor];
    self.rearScrollview.contentMode = UIViewContentModeCenter;
    
    self.rearImageView = [[[InfoImageView alloc] initWithFrame:self.rearScrollview.bounds] autorelease];
    self.rearImageView.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizeronView:self.rearScrollview];
    [self.rearScrollview  addSubview:self.rearImageView];
    
    self.curscrollView.showsHorizontalScrollIndicator = NO;
    self.curscrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:self.rearScrollview];
}
- (void)addGestureRecognizeronView:(UIView *)view
{
    [view setUserInteractionEnabled:YES];
    UITapGestureRecognizer * gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)] autorelease];
    gesture.numberOfTapsRequired = 2;
    
    UITapGestureRecognizer * gesture1 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlesignalGesture:)] autorelease];
    gesture1.numberOfTapsRequired = 1;
    
    [gesture1 requireGestureRecognizerToFail:gesture];
    [view addGestureRecognizer:gesture1];
    [view addGestureRecognizer:gesture];
    
}
#pragma mark TapGesture
- (void)setZooming:(UIScrollView *)scrollview
{
    if (scrollview.zoomScale != scrollview.minimumZoomScale)
        [scrollview  setZoomScale:scrollview.minimumZoomScale animated:YES];
}
- (void)handlesignalGesture:(UITapGestureRecognizer *)gesture
{
    [self.view setUserInteractionEnabled:NO];
    animation = YES;
    _dataManager.photo_ID = [NSString stringWithFormat:@"%@",[self.info objectForKey:@"photo_id"]];
    [_dataManager dataSourcewithRefresh:YES];
    [_dataManager.controller showNavigationBar];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.currentImageView setAlpha:0];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self.tempView removeFromSuperview];
        animation = NO;
        [self.view setUserInteractionEnabled:YES];
    }];
    
//    [self setZooming:_fontScrollview];
//    [self setZooming:_curscrollView];
//    [self setZooming:_rearScrollview];
//    [[self currentImageView] resetGigView];
//    
//    UIImageView * imageView = [[[UIImageView alloc] initWithFrame:[self getCurrentImageView].bounds] autorelease];
//    imageView.image = [self getCurrentImageView].image;
//    UIView * boundsView = [[[UIView alloc] initWithFrame:[self getCurrentImageView].frame] autorelease];
//    boundsView.backgroundColor = [UIColor clearColor];
//    boundsView.clipsToBounds = YES;
//    [boundsView addSubview:imageView];
//    
//    CGFloat heigth = [self getHeightofImage:[[self.info objectForKey:@"height"] floatValue] :[[self.info objectForKey:@"width"] floatValue]];
//    CGRect photoRect = CGRectZero;
//    CGRect boundsRect = CGRectZero;
//    [self setTempRect:&boundsRect PhotoRect:&photoRect with:heigth];
//    
//    self.view.alpha = 0;
//    boundsView.transform = [self getTransfrom];
//    boundsView.center = CGPointMake(160, 240);
//    
//    SCPAppDelegate * app = (SCPAppDelegate *)[UIApplication sharedApplication].delegate;
//    UIView * bgview = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
//    bgview.backgroundColor = [UIColor blackColor];
//    
//    [app.window addSubview:bgview];
//    [app.window addSubview:boundsView];
//    
//    [((SCPMenuNavigationController *) (self.navigationController)).menuManager.ribbon setHidden:NO];
//    [self.navigationController popViewControllerAnimated:NO];
//    
//    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        boundsView.transform =CGAffineTransformIdentity;
//        boundsView.frame = boundsRect;
//        imageView.frame = photoRect;
//        bgview.alpha = 0;
//    } completion:^(BOOL finished) {
//        
//        [boundsView removeFromSuperview];
//        [bgview removeFromSuperview];
//        [self.view setUserInteractionEnabled:YES];
//        animation = NO;
//    }];
}
- (void)setTempRect:(CGRect *)tempRect PhotoRect:(CGRect *)photoRect with:(CGFloat)heigth
{
    if (heigth < 320) {
        CGFloat width = 320.f * (320.f / heigth);
        *photoRect  = CGRectMake((320 - width)/2.f, 0, width, 320);
        *tempRect = CGRectMake(0, 0, 320, 320);
    }else if(heigth > 320){
        *photoRect = CGRectMake(0, 0, 320, heigth);
        *tempRect = CGRectMake(0, 0, 320, 320);
        
    }else{
        *photoRect = CGRectMake(0, 0, 320,320);
        *tempRect = CGRectMake(0, 0, 320, 320);
    }
    
    CGFloat Y = ((SCPPhotoDetailViewController *)_dataManager.controller).pullingController.tableView.contentOffset.y;
    (*tempRect).origin.y -= (Y - 100);
    
}
- (CGFloat)getHeightofImage:(CGFloat)O_height :(CGFloat) O_width
{
    CGFloat finalHeigth = 0.f;
    finalHeigth = O_height * (320.f / O_width);
    //    NSLog(@"finalHeigth %f",finalHeigth);
    if (!finalHeigth) {
        finalHeigth = 320;
    }
    return finalHeigth;
}
- (UIImageView *)getCurrentImageView
{
    UIImageView * view = nil;
    if (self.scrollView.contentOffset.x == 0)
        view = self.fontImageView;
    if (self.scrollView.contentOffset.x == self.scrollView.frame.size.width)
        view =  self.currentImageView;
    if (self.scrollView.contentOffset.x == self.scrollView.frame.size.width * 2)
        view = self.rearImageView;
    return view;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
//    [self.tempView removeFromSuperview];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.view];
    [self listOrientationinit];
    [self.view setUserInteractionEnabled:YES];
    animation = NO;

//    if (anim == startAnimations) {
//        [self.tempView removeFromSuperview];
//        [[[[UIApplication sharedApplication] delegate] window] addSubview:self.view];
//        [self listOrientationinit];
//        [self.view setUserInteractionEnabled:YES];
//        animation = NO;
//    }else{
////        [self.view setUserInteractionEnabled:YES];
////        animation = NO;
//    }
    
}
- (void)showWithPushController:(id)nav_ctrller fromRect:(CGRect)temRect image:(UIImage *)image ImgaeRect:(CGRect)imageRect
{
   
    self.tempView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tempView.backgroundColor = [UIColor blackColor];
    [self.view setUserInteractionEnabled:NO];
     animation = YES;
    CATransition * startAnimations = [[CATransition animation] retain];
    startAnimations.type = kCATransitionFade;
    startAnimations.duration = 0.5;
    startAnimations.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.30 :0 :0.6 :0.8];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.tempView];
    startAnimations.delegate = self;
    [[[[[UIApplication sharedApplication] delegate] window] layer] addAnimation:startAnimations forKey:@"KO"];
    
//    [self.view setUserInteractionEnabled:NO];
//    animation = YES;
//    
//    UIView * boundsView = [[[UIView alloc] initWithFrame:temRect] autorelease];
//    boundsView.backgroundColor = [UIColor clearColor];
//    boundsView.clipsToBounds = YES;
//    
//    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
//    imageView.frame = imageRect;
//    [boundsView addSubview:imageView];
//    
//    SCPAppDelegate * app = (SCPAppDelegate *)[UIApplication sharedApplication].delegate;
//    UIView * view = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
//    view.backgroundColor = [UIColor blackColor];
//    
//    view.alpha = 0;
//    [app.window addSubview:view];
//    [app.window addSubview:boundsView];
//    
//    [self listOrientationinit];
//    CGRect finRect = [self getCurrentImageView].bounds;
//    finRect.origin.x = (self.view.frame.size.width - finRect.size.width)/2;
//    finRect.origin.y = (self.view.frame.size.height - finRect.size.height)/2;
//    
//    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
//        boundsView.frame = finRect;
//        imageView.frame = [self getCurrentImageView].bounds;
//        boundsView.transform = [self getTransfrom];
//        view.alpha = 1;
//        
//    } completion:^(BOOL finished) {
//        [((SCPMenuNavigationController *) (nav_ctrller)).menuManager.ribbon setHidden:YES];
//        [nav_ctrller pushViewController:self animated:NO];
//        [self listOrientationinit];
//        [view removeFromSuperview];
//        [boundsView removeFromSuperview];
//        [self.view setUserInteractionEnabled:YES];
//        animation = NO;
//        
//    }];
    
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    if ([[gesture view] isEqual:self.fontScrollview]) {
        NSLog(@"%s , scale :%f",__FUNCTION__ ,self.fontScrollview.maximumZoomScale);
        if (self.fontScrollview.zoomScale != self.fontScrollview.maximumZoomScale) {
            [self.fontScrollview setZoomScale:self.fontScrollview.maximumZoomScale animated:YES];
        }else{
            [self.fontScrollview setZoomScale:self.fontScrollview.minimumZoomScale animated:YES];
        }
    }
    if ([[gesture view] isEqual:self.curscrollView]) {
        if (self.curscrollView.zoomScale != self.curscrollView.maximumZoomScale) {
            [self.curscrollView setZoomScale:self.curscrollView.maximumZoomScale animated:YES];
        }else{
            [self.curscrollView setZoomScale:self.curscrollView.minimumZoomScale animated:YES];
        }
    }
    if ([[gesture view] isEqual:self.rearScrollview]) {
        if (self.rearScrollview.zoomScale != self.rearScrollview.maximumZoomScale) {
            [self.rearScrollview setZoomScale:self.rearScrollview.maximumZoomScale animated:YES];
        }else{
            [self.rearScrollview setZoomScale:self.rearScrollview.minimumZoomScale animated:YES];
        }
    }
    
    
}
#pragma mark Refresh ScrollView
- (void)setScrollViewProperty
{
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3 , self.scrollView.bounds.size.height);
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
}
- (BOOL)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:curPage-1];
    int last = [self validPageValue:curPage+1];
    
    if([curImages count] != 0) [curImages removeAllObjects];
    
    [curImages addObject:[imageArray objectAtIndex:pre]];
    [curImages addObject:[imageArray objectAtIndex:curPage]];
    [curImages addObject:[imageArray objectAtIndex:last]];
    return YES;
}
- (int)validPageValue:(NSInteger)value {
//    if(value == -1) value = 0;                   // value＝1为第一张，value = 0为前面一张
//    if(value == imageArray.count) value = imageArray.count - 1;
    return value;
}
- (void)resetImageFrame:(InfoImageView*)imageView
{
    if (!imageView.info) {
        return;
    }
    CGFloat w = [[[imageView info] objectForKey:@"width"] floatValue];
    CGFloat h = [[[imageView info] objectForKey:@"height"] floatValue];
    
    CGRect frameRect = self.scrollView.frame;
    frameRect.size.width -= 2  * OFFSET;
    
    [self.curscrollView  setZoomScale:1];
    [self.fontScrollview setZoomScale:1];
    [self.rearScrollview setZoomScale:1];
    
    CGRect rect = CGRectZero;
    if (w > frameRect.size.width || h > frameRect.size.height) {
        CGFloat scale = MIN(frameRect.size.width / w, frameRect.size.height / h);
        rect = CGRectMake(0, 0, w * scale, h * scale);
        
        if ([imageView isEqual:self.currentImageView]){
            self.curscrollView.maximumZoomScale = MIN(frameRect.size.width * 2 / rect.size.width, frameRect.size.height * 2 / rect.size.height);
        }
        if ([imageView isEqual:self.fontImageView]) {
            self.fontScrollview.maximumZoomScale  = MIN(frameRect.size.width * 2 / rect.size.width, frameRect.size.height * 2 / rect.size.height);
        }
        if ([imageView isEqual:self.rearImageView]) {
            self.rearScrollview.maximumZoomScale  = MIN(frameRect.size.width * 2 / rect.size.width, frameRect.size.height * 2 / rect.size.height);
        }    }else{
            
            if ([imageView isEqual:self.currentImageView]){
                self.curscrollView.maximumZoomScale = 1.1;
            }
            if ([imageView isEqual:self.fontImageView]) {
                self.fontScrollview.maximumZoomScale = 1.1;
            }
            if ([imageView isEqual:self.rearImageView]) {
                self.rearScrollview.maximumZoomScale = 1.1;
            }
            
            rect = CGRectMake(0, 0, w, h);
        }
    imageView.frame = rect;
    imageView.center  = CGPointMake(frameRect.size.width  / 2.f, frameRect.size.height / 2.f);
    if ([imageView isEqual:self.currentImageView]) {
        self.curscrollView.contentSize = imageView.frame.size;
        [self.curscrollView setContentOffset:CGPointMake(0, 0)];
    }
    if ([imageView isEqual:self.fontImageView]) {
        self.fontScrollview.contentSize = imageView.frame.size;
        [self.fontScrollview setContentOffset:CGPointMake(0, 0)];
    }
    if ([imageView isEqual:self.rearImageView]) {
        self.rearScrollview.contentSize = imageView.frame.size;
        [self.rearScrollview setContentOffset:CGPointMake(0, 0)];
    }
    [imageView resetGigView];
    if ([[imageView info] objectForKey:@"photo_url"]);
    {
        [imageView cancelCurrentImageLoad];
        [imageView.actV startAnimating];
        NSString * str = nil;
        if (h > w) {
            str = [NSString stringWithFormat:@"%@_h960",[[imageView info] objectForKey:@"photo_url"]];
        }else{
            str = [NSString stringWithFormat:@"%@_w640",[[imageView info] objectForKey:@"photo_url"]];
        }
        
        [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options: 0   success:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [imageView.actV stopAnimating];
            });
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    
        if ([[[imageView info] objectForKey:@"multi_frames"] boolValue])
            [imageView playGif:[NSURL URLWithString:[imageView.info objectForKey:@"photo_url"]]];

    }
}
- (void)refreshScrollviewOnMinBounds
{
    self.fontImageView.info = [imageArray objectAtIndex:0];
    self.currentImageView.info = [imageArray objectAtIndex:1];
    self.rearImageView.info = [imageArray objectAtIndex:2];
    
    self.info = self.fontImageView.info;
    [self resetImageFrame:self.fontImageView];
    [self resetImageFrame:self.currentImageView];
    [self resetImageFrame:self.rearImageView];
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height)];
    [self.scrollView setContentOffset:CGPointZero];
    curPage++;
}
- (void)refreshScrollviewOnMaxBounds
{
    
    self.rearImageView.info = [imageArray objectAtIndex:imageArray.count - 1];
    self.currentImageView.info = [imageArray objectAtIndex:imageArray.count - 2];
    self.fontImageView.info = [imageArray objectAtIndex:imageArray.count - 3];
    self.info = self.rearImageView.info;
    [self resetImageFrame:self.fontImageView];
    [self resetImageFrame:self.currentImageView];
    [self resetImageFrame:self.rearImageView];
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height)];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2,0)];
    curPage--;
}
- (void)refreshScrollviewWhenPhotonumLessThree
{
    self.fontImageView.info = [imageArray objectAtIndex:0];
    if (imageArray.count == 2) {
        self.currentImageView.info = [imageArray objectAtIndex:1];
    }else{
        self.currentImageView.info  = nil;
    }
    self.info = self.fontImageView.info;
    [self resetImageFrame:self.fontImageView];
    [self resetImageFrame:self.currentImageView];
    
    if (photoNum == 2) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height)];
    }
    if (photoNum == 1) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * curPage, 0)];
    
}
- (void)refreshScrollViewNormal
{
    if ([self getDisplayImagesWithCurpage:curPage]) {
     
        self.fontImageView.info = [curImages objectAtIndex:0];
        self.currentImageView.info = [curImages objectAtIndex:1];
        self.rearImageView.info = [curImages objectAtIndex:2];
        self.info = self.currentImageView.info;
        
        [self resetImageFrame:self.fontImageView];
        [self resetImageFrame:self.currentImageView];
        [self resetImageFrame:self.rearImageView];
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    }
}

- (void)refreshScrollView {
    
    if (!imageArray || imageArray.count == 0) {
        return;
    }
    if (isInit){
        isInit = NO;
        return;
    }
    
    NSLog(@"photoNum:%d imageCount::%d  curnum: %d",photoNum, imageArray.count, curPage);
    if (photoNum < 3) {
        [self refreshScrollviewWhenPhotonumLessThree];
        return;
    }
    if (curPage == 0) {
        [self refreshScrollviewOnMinBounds];
        return;
    }
    
    if (curPage == imageArray.count - 1) {
        [self refreshScrollviewOnMaxBounds];
        return;
    }
    [self refreshScrollViewNormal];
}

#pragma mark scrollView  Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isLoading) {
        return;
    }
    if (![scrollView isEqual:self.scrollView] || ![scrollView isDragging]|| animation )      return;
    if (photoNum < 3) {
        curPage = self.scrollView.contentOffset.x / self.view.frame.size.width;
        NSLog(@"curpage:%d",curPage);
        return;
    }
    int x = self.scrollView.contentOffset.x;
    if(x >= (self.scrollView.frame.size.width * 2)) {
        
        if (curPage >= photoNum - 2) {
            curPage = photoNum - 1;
            [self initSubViews];
            return;
        }
        if (curPage >= imageArray.count - 2) {
            [self getMoreImage];
            return;
        }
        curPage = [self validPageValue:curPage+1];
        [self refreshScrollView];
    }
    
    if(x <= 0) {
        
        if (curPage <= 1) {
            curPage = 0;
            [self initSubViews];
            return;
        }
        curPage = [self validPageValue:curPage-1];
        [self refreshScrollView];
    }
    
    if (x == self.scrollView.frame.size.width) {
        self.info = self.currentImageView.info;
        [self resetImageFrame:self.currentImageView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.curscrollView]) {
        return self.currentImageView;
    }
    if ([scrollView isEqual:self.fontScrollview]) {
        return self.fontImageView;
    }
    if ([scrollView isEqual:self.rearScrollview]) {
        return self.rearImageView;
    }
    return nil;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self resetImagetView:scrollView];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [self resetImagetView:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self resetImagetView:scrollView];
}
- (void)resetImagetView:(UIScrollView *)scrollView
{
    
    UIImageView * view = [self getCurrentImageView];
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    if (view.frame.size.width > scrollView.frame.size.width){
        x = 0;
        offsetX = (view.frame.size.width - scrollView.frame.size.width)/2.f;
    }else{
        offsetX = 0;
        x = (scrollView.frame.size.width - view.frame.size.width)/ 2;
    }
    if (view.frame.size.height > scrollView.frame.size.height){
        y = 0;
        offsetY = ( view.frame.size.height - scrollView.frame.size.height)/2.f;
    }else{
        offsetY = 0;
        y = (scrollView.frame.size.height - view.frame.size.height)/2.f;
    }
    scrollView.contentOffset = CGPointMake(offsetX , offsetY);
    view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
    scrollView.contentSize = view.frame.size;
}
@end
