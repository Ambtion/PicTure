//
//  FunctionguideScroll.m
//  SohuCloudPics
//
//  Created by sohu on 12-11-15.
//
//

#import "FunctionGuideController.h"
#import "SCPAppDelegate.h"
#import "SCPGuideViewExchange.h"

#define PAGENUM 4

static NSString * staticImage[4] = {@"welcome-guid-1.png",@"cloud-2.png",@"camera-3.png",@"share_happy-4.png"};
static NSString * staticImage6[4] = {@"welcome-guid-ios61.png",@"cloudios62.png",@"cameraios63.png",@"share_happyios64.png"};

@implementation FunctionGuideController

@synthesize delegate = _delegate;

- (void)dealloc
{
    [_scrollView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.tag = FUNCTINVIEWTAG;
    
    _scrollView  = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    [self addScrollviewContent];
    
    _pageControll = [[SMPageControl alloc] initWithFrame:CGRectMake(110, _scrollView.bounds.size.height - 44, 100, 40)];
    _pageControll.backgroundColor = [UIColor clearColor];
    _pageControll.numberOfPages = 4;
    _pageControll.currentPage = 0;
    [_pageControll setIndicatorMargin:2];
    [_pageControll setIndicatorDiameter:5];
    [_pageControll setPageIndicatorImage:[UIImage imageNamed:@"currentPageDot.png"]];
    [_pageControll setCurrentPageIndicatorImage:[UIImage imageNamed:@"pageDot.png"]];
    [_pageControll setUserInteractionEnabled:NO];
    [self.view addSubview:_pageControll];
}

- (void)addScrollviewContent
{
    UIImageView * imageView = nil;
    CGFloat height = _scrollView.bounds.size.height;
    CGFloat offset = _scrollView.bounds.size.width;
    if ([[UIScreen mainScreen] bounds].size.height <= 480) {
        for (int i = 0; i < PAGENUM; i++) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * offset, 0, offset, height)];
            imageView.image = [UIImage imageNamed:staticImage[i]];
            imageView.tag = i;
            [_scrollView addSubview:imageView];
            [imageView release];
        }
    }else{
        for (int i = 0; i < PAGENUM; i++) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * offset, 0, offset, height)];
            imageView.image = [UIImage imageNamed:staticImage6[i]];
            imageView.tag = i;
            [_scrollView addSubview:imageView];
            [imageView release];
        }
    }
    
    [_scrollView setContentSize:CGSizeMake(offset * PAGENUM, height)];
    imageView = (UIImageView *)[_scrollView viewWithTag:PAGENUM - 1];
    [imageView setUserInteractionEnabled:YES];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setBackgroundImage:[UIImage imageNamed:@"login_btn_normal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"login_btn_press.png"] forState:UIControlStateHighlighted];
    [button setTitle:@"开始使用" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    button.frame = CGRectMake(105, self.view.frame.size.height - 120, 110, 35);
    [button addTarget:self action:@selector(beginUseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];
}

- (void)beginUseButtonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(functionGuideController:clickUserButton:)]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:FUNCTIONSHOWED];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_delegate performSelector:@selector(functionGuideController:clickUserButton:) withObject:self withObject:button];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView]) {
        NSInteger curPage = floorf(([_scrollView contentOffset].x+ 161) / _scrollView.bounds.size.width);
        _pageControll.currentPage = curPage;
    }

}
@end
