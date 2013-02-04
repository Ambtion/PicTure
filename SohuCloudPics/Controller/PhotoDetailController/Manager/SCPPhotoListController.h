//
//  SCPPhotoListScrollview.h
//  UISCrollView_NetWork
//
//  Created by sohu on 12-11-26.
//  Copyright (c) 2012年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "SCPRequestManager.h"
#import "ASIHTTPRequest.h"

@class PhotoDetailManager;

@interface InfoImageView : UIImageView<UIWebViewDelegate,ASIHTTPRequestDelegate>
@property(nonatomic,retain)NSDictionary * info;
@property(nonatomic,assign)UIActivityIndicatorView * actV;
@property(nonatomic,retain)UIWebView * webView;
@property(nonatomic,retain)ASIHTTPRequest * requset;
- (void)playGif:(NSURL *)url;
- (void)resetGigView;
@end

@class SCPPhotoListController;
@protocol SCPPhotoListControllerDeletate <NSObject>
- (void)whenViewRemveFromSuperview;
@end

typedef enum _imageStatePosition
{
    AtLess = 0,
    AtNomal,
    AtMore
    
}imageStatePosition;

@interface SCPPhotoListController : UIViewController <UIScrollViewDelegate,SCPRequestManagerDelegate>
{
    UIView * _bgView;
    UIScrollView * _scrollView;
    SCPRequestManager * _requestManger;
    InfoImageView * _fontImageView;
    UIScrollView * _fontScrollview;
    InfoImageView * _currentImageView;
    UIScrollView * _curscrollView;
    InfoImageView * _rearImageView;
    UIScrollView * _rearScrollview;
    
    PhotoDetailManager * _dataManager;
    NSInteger curPage;
    NSMutableArray * imageArray;
    NSMutableArray * curImages;
    NSInteger photoNum;
    NSInteger Pagenum;
    BOOL isInit;
    BOOL hasNextPage;
    imageStatePosition Imagestate;
    //for animation
    BOOL isAnimating;
    BOOL isLoading;
}
@property (nonatomic, assign)id<SCPPhotoListControllerDeletate> delegate;

@property (nonatomic,retain) UIView * tempView;
@property (nonatomic,retain) NSDictionary * info;
@property (nonatomic,retain) NSString * folder_id;
@property (nonatomic,retain) NSString * user_id;

@property (nonatomic,retain) UIView * bgView;
@property (nonatomic,retain) InfoImageView * fontImageView;
@property (nonatomic,retain) UIScrollView *  fontScrollview;
@property (nonatomic,retain) InfoImageView * currentImageView;
@property (nonatomic,retain) UIScrollView *  curscrollView;
@property (nonatomic,retain) InfoImageView * rearImageView;
@property (nonatomic,retain) UIScrollView * rearScrollview;
@property (nonatomic,retain) UIScrollView * scrollView;

- (id)initWithUseInfo:(NSDictionary * ) info : (PhotoDetailManager *)dataManager;
- (void)showWithPushController:(id)nav_ctrller fromRect:(CGRect)temRect image:(UIImage *)image ImgaeRect:(CGRect)imageRect;
- (UIImageView *)getCurrentImageView;

@end
