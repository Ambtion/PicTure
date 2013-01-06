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
    self.view.backgroundColor = [UIColor redColor];
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
