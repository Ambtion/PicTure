//
//  FlashButtom.m
//  test
//
//  Created by sohu on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FlashButton.h"
#import <QuartzCore/QuartzCore.h>


@implementation FlashButton
@synthesize selection;
- (void)dealloc
{
    [_imageView release];
    [super dealloc];
}
-(id)initWithOrinal:(CGPoint)point
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(point.x, point.y, 50, 32);
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"initWithFrame start");
    _isSegHidden = YES;
    self.view.layer.cornerRadius = 16;
    self.view.layer.borderWidth = 1.f;
    self.view.layer.borderColor = [UIColor colorWithRed:72/255.f green:72/255.f blue:72/255.f alpha:1].CGColor;
    self.view.clipsToBounds = YES;


    [self addSubViews];
}
-(void)addSubViews
{
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 32)];
    _imageView.image = [UIImage imageNamed:@"Light.png"];
    _imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tap.numberOfTapsRequired = 1;
    [_imageView addGestureRecognizer:tap];
    [tap release];
    [self.view addSubview:_imageView];

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

-(void)addtarget:(UIViewController*)controller  action:(SEL)Aaction
{
    _action = Aaction;
    _controller = controller;
}
-(void)handleTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (_isSegHidden) {
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.3];
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 150, 32);
            _imageView.frame = CGRectMake(0, 0, 150, 32);
            [UIView commitAnimations];
            _isSegHidden = NO;
        }else {
            CGPoint point = [gesture locationInView:_imageView];
            if (point.x <= 40) {
                
                self.selection = 0;   
            }else if (point.x <= 80) {
                
                self.selection = 1;
            }else {
                self.selection = 2;
            }
            if (_action)
                [_controller performSelector:_action withObject:self];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.3];
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 50, 32);
            _imageView.frame = CGRectMake(0 - selection * 50 , 0, 150, 32);
            [UIView commitAnimations];
            _isSegHidden = YES;
            
        }
        
    }
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
