//
//  SCPReadDealController.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-13.
//
//

#import "SCPReadDealController.h"


@implementation SCPReadDealController
- (void)dealloc
{
    [_backbutton release];
    [super dealloc];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    CGRect rect = self.view.bounds;
    UIScrollView * scrollView = [[[UIScrollView alloc] initWithFrame:rect] autorelease];
    UIImageView * imageview = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 5700/2.f)] autorelease];
    imageview.image = [UIImage imageNamed:@"服务协议.png"];
    imageview.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:imageview];
    [scrollView setContentSize:imageview.bounds.size];
    [self.view addSubview:scrollView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _backbutton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backbutton.frame = CGRectMake(5, 2, 35, 35);
    [_backbutton setImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [_backbutton setImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateNormal];
    [_backbutton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backbutton];
}
- (void)back:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
