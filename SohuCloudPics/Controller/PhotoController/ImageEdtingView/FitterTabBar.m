//
//  FitterTabBar.m
//  SohuCloudPics
//
//  Created by sohu on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FitterTabBar.h"
#import "ImageEdtingController.h"

@interface FitterTabBar ()

@end

@implementation FitterTabBar
- (void)dealloc
{
    [_boundsview release];
    [_scrollview release];
    [_photoArray release];
    [super dealloc];
}
-(id)initWithdelegate:(id<FitterDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _photoArray = [[NSMutableArray arrayWithCapacity:0] retain];
        _boundsview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"highlight.png"]];
        _boundsview.frame = CGRectMake(0, 0, 73, 73);
        [self addPhotoArray];
        self.view.backgroundColor = [UIColor clearColor];
        self.view.frame = CGRectMake(0, 90, 320, 100);
        [self addScrollview];
    }
    return self;
}
#pragma mark -

-(void)addPhotoArray
{
//    [_photoArray addObject:@"2-清新.png"];
//    [_photoArray addObject:@"3-黑白.png"];
//    
//    [_photoArray addObject:@"4-复古.png"];
//    [_photoArray addObject:@"5-LOMO.png"];
//    [_photoArray addObject:@"8-温暖.png"];
//    
//    [_photoArray addObject:@"6-大自然.png"];
//    [_photoArray addObject:@"7-淡雅.png"];
//    [_photoArray addObject:@"9-回忆.png"];
    [_photoArray addObject:@"清新.png"];
    [_photoArray addObject:@"黑白.png"];
    [_photoArray addObject:@"复古.png"];
    [_photoArray addObject:@"LOMO.png"];
    [_photoArray addObject:@"温暖.png"];
    [_photoArray addObject:@"大自然.png"];
    [_photoArray addObject:@"淡雅.png"];
    [_photoArray addObject:@"回忆.png"];
}
#pragma mark -
#pragma mark addScrollview
-(void)addScrollview
{
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 95)];
    _scrollview.showsVerticalScrollIndicator = _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.backgroundColor = [UIColor clearColor];
    [self addscrovllviewSubviews];
    [self.view addSubview:_scrollview];
}
-(void)addscrovllviewSubviews
{
    UIButton* originalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    originalButton.frame = CGRectMake(0, 0, 73, 73);
    originalButton.tag = 500;
    [originalButton setBackgroundImage:[UIImage imageNamed:@"原图.png"] forState:UIControlStateNormal];
    [originalButton addTarget:self action:@selector(fitterAction:) forControlEvents:UIControlEventTouchUpInside];
    [originalButton addSubview:_boundsview];
    [_scrollview addSubview:originalButton];
    
    UILabel* originalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 73, 73, 22)];
    originalLabel.backgroundColor  = [UIColor clearColor];
    originalLabel.textAlignment = UITextAlignmentCenter;
    UIFont * font = [UIFont fontWithName:@"Helvetica" size:12];
    originalLabel.font = font;
    originalLabel.textColor = [UIColor whiteColor];
    originalLabel.text = @"原图";
    
    [_scrollview addSubview:originalLabel];
    [originalLabel release];
    for (int i = 1; i <= _photoArray.count; i++) {
        NSString* str = [[[_photoArray objectAtIndex:i-1] copy] autorelease];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(75 * i, 0, 73, 73);
        button.tag = 1000 + i - 1;
        button.backgroundColor = [UIColor  clearColor];
        [button setBackgroundImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(75 * i, 73, 73, 20)];
        label.backgroundColor  = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = font;
        label.textColor = [UIColor whiteColor];
        label.text = [[str componentsSeparatedByString:@"."] objectAtIndex:0];
        [button addTarget:self action:@selector(fitterAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollview addSubview:button];
        [_scrollview addSubview:label];
        [label release];
    }
    [_scrollview setContentSize:CGSizeMake(75 * _photoArray.count + 73, 95)];

}

#pragma mark -
#pragma mark fitterButton
-(void)fitterAction:(UIButton*)button
{
    if (_boundsview.superview) {
        [_boundsview removeFromSuperview];
    }
    [button addSubview:_boundsview];
    
    if ([_delegate respondsToSelector:@selector(fitterAction:)]) {
        [_delegate fitterAction:button];
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
