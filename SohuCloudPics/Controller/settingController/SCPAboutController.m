//
//  SCPAboutController.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-6.
//
//

#import "SCPAboutController.h"


@implementation SCPAboutController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aboutv1.0.0.png"]];
    image.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:image];
    self.view.backgroundColor = [UIColor colorWithRed:244.0f/255.f green:244.0f/255.f blue:244.0f/255.f alpha:1];

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
