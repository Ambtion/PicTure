//
//  GifDetail.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GifDetail.h"

@interface GifDetail ()

@end

@implementation GifDetail
@synthesize delegate;
@synthesize n_images ,s_images;
@synthesize selectedSegmentIndex = _selectedSegmentIndex;
- (void)dealloc
{
    self.n_images = nil;
    self.s_images = nil;
    [_bgView release];
    [super dealloc];
}
-(id)initWithFrame:(CGRect)rect N_image:(NSArray *)nArray S_image:(NSArray *) sArray
{
    self = [super init];
    if (self) {
        self.view.frame = rect;
        _bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_bgView];
        self.n_images = nArray;
        self.s_images = sArray;
        self.selectedSegmentIndex = 0;
        
        [self addSubViews];
        [self setButtonImage];
        [self setSectionImage];
    }
    return self;
}
-(void)addSubViews
{
    for (int i = 0; i < self.n_images.count; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        CGFloat width = (self.view.frame.size.width - 16) / 3;
        button.frame = CGRectMake(8 + width * i, 0 ,width , 43);
        button.tag = i + 1000;
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
}

-(void)setBackImage:(UIImage*)image
{
    _bgView.image = image;
}
-(void)setButtonImage
{
    
    if (self.n_images && self.s_images) {
        for (int i = 0; i < self.n_images.count; i++) {
            UIButton * button = (UIButton*)[self.view viewWithTag:i + 1000];
            [button setBackgroundImage:[UIImage imageNamed:[self.n_images objectAtIndex:i]] forState:UIControlStateNormal];
            //[button setBackgroundImage:[UIImage imageNamed:[self.s_images objectAtIndex:i]] forState:UIControlStateHighlighted];
        }
    }
    
}
-(void)setSectionImage
{
    UIButton * button = (UIButton*)[self.view viewWithTag:1000 + self.selectedSegmentIndex];
    [button setBackgroundImage:[UIImage imageNamed:[self.s_images objectAtIndex:self.selectedSegmentIndex]] forState:UIControlStateNormal];
//     [button setBackgroundImage:[UIImage imageNamed:[self.n_images objectAtIndex:self.selectedSegmentIndex]] forState:UIControlStateHighlighted];
}
-(NSInteger)selectedSegmentIndex
{
    return _selectedSegmentIndex;
}
-(void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    _selectedSegmentIndex = selectedSegmentIndex;
    UIButton * button = (UIButton*)[self.view viewWithTag:_selectedSegmentIndex + 1000];
    if (self.s_images) {
        [button setBackgroundImage:[s_images objectAtIndex:_selectedSegmentIndex] forState:UIControlStateNormal];
    }
}
-(void)action:(UIButton *)button
{
    self.selectedSegmentIndex = button.tag - 1000;
    [self setButtonImage];
    [self setSectionImage];
    if ([self.delegate respondsToSelector:@selector(GifDetail:actionAtindex:)]) {
        [self.delegate GifDetail:self actionAtindex:self.selectedSegmentIndex];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

@end
