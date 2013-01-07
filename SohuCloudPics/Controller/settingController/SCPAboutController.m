//
//  SCPAboutController.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-6.
//
//

#import "SCPAboutController.h"

@interface SCPAboutController ()

@end

@implementation SCPAboutController


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about.png"]];
    image.frame = self.view.bounds;
    [self.view addSubview:image];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(aboutNavigationBack:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(5, 2, 35, 35);
    [self.view addSubview:backButton];
    
}
- (void)aboutNavigationBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
