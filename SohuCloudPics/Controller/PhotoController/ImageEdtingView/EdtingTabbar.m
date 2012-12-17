//
//  EdtingTabbar.m
//  SohuCloudPics
//
//  Created by sohu on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EdtingTabbar.h"
#import "ImageEdtingController.h"

@interface EdtingTabbar ()

@end

@implementation EdtingTabbar

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithDeleggate:(id)delegete
{
    self = [super init];
    if (self) {
        _delegate = delegete;
        isHiddenFitter = YES;
        NSLog(@"initWithDeleggate");
        ImageEdtingController* ivc = (ImageEdtingController *)_delegate;
        CGRect rect  = CGRectMake(0, ivc.view.frame.size.height - 49, 320, 49);
        self.view.frame = rect;
        self.view.backgroundColor = [UIColor clearColor];
        [ivc.view addSubview:self.view];
        [self addMysubViews];
    }
    return self;
}
-(void)dealloc
{
    [_bgview release];
    [super dealloc];
}
#pragma mark-
#pragma mark   viewLoading
- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    NSLog(@"ImageEdtingController %@",_delegate);

}
-(void)addMysubViews
{
    _bgview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgview.image = [UIImage imageNamed:@"camera_bar.png"];
    _bgview.userInteractionEnabled = YES;
    [self.view addSubview:_bgview];
    
    UIButton* cutbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    cutbutton.frame = CGRectMake(24, 4, 41, 41);
    cutbutton.backgroundColor = [UIColor clearColor];
    cutbutton.tag = 100;
    [cutbutton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cutbutton setBackgroundImage:[UIImage imageNamed:@"crop.png"] forState:UIControlStateNormal];
    [_bgview addSubview:cutbutton];
    
    UIButton* translate = [UIButton buttonWithType:UIButtonTypeCustom];
    translate.frame = CGRectMake(80 + 24, 4, 41, 41);
    translate.backgroundColor = [UIColor clearColor];
    translate.tag = 200;
    [translate addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [translate setBackgroundImage:[UIImage imageNamed:@"random.png"] forState:UIControlStateNormal];
    [translate setBackgroundImage:[UIImage imageNamed:@"random——2.png"] forState:UIControlStateHighlighted];

    [_bgview addSubview:translate];
    
    UIButton* more = [UIButton buttonWithType:UIButtonTypeCustom];
    more.frame = CGRectMake(160 + 24, 4, 41, 41);
    more.backgroundColor = [UIColor clearColor];
    more.tag = 400;
    [more addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [more setBackgroundImage:[UIImage imageNamed:@"模糊.png"] forState:UIControlStateNormal];
    [_bgview addSubview:more];
    
    UIButton* fitter = [UIButton buttonWithType:UIButtonTypeCustom];
    fitter.frame = CGRectMake(240 + 3, 4, 62, 41);
    fitter.backgroundColor = [UIColor clearColor];
    fitter.tag = 300;
    [self setFilterBackImage:fitter];
    [fitter addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:fitter];
    

}
#pragma mark-
#pragma TabbarTapEvent
-(void)ButtonClick:(UIButton*)button
{
    switch (button.tag) {
        case 100:
            if ([_delegate respondsToSelector:@selector(EdtingTabbar:cutButton:)]) {
                [_delegate EdtingTabbar:self cutButton:button];
            }
            break;
        case 200:
            if ([_delegate respondsToSelector:@selector(EdtingTabbar:translateButton:)]) {
                [_delegate EdtingTabbar:self translateButton:button];
            }
            break;
        case 300:
            [self setFilterBackImage:button];
            if ([_delegate respondsToSelector:@selector(EdtingTabbar:fitterButton:)]) {
                [_delegate EdtingTabbar:self fitterButton:button];
            }
            break;
        case 400:
            if ([_delegate respondsToSelector:@selector(EdtingTabbar:blurredButton:)]) {
                [_delegate EdtingTabbar:self blurredButton:button];
            }
            break;
        default:
            break;
    }
   
}
-(void)setFilterBackImage:(UIButton* )button
{
    if (isHiddenFitter) {
        [button setBackgroundImage:[UIImage imageNamed:@"特效.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"特效-2.png"] forState:UIControlStateHighlighted];
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"特效-3.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"特效-4.png"] forState:UIControlStateHighlighted];
    }
    isHiddenFitter = !isHiddenFitter;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
