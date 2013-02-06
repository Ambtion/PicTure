//
//  SCPAboutController.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-6.
//
//

#import "SCPAboutController.h"
#define PPHOST @"http://pp.sohu.com"

@implementation SCPAboutController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
    UIImageView * image = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about.png"]] autorelease];
    image.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:image];
    self.view.backgroundColor = [UIColor colorWithRed:244.0f/255.f green:244.0f/255.f blue:244.0f/255.f alpha:1];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(aboutNavigationBack:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(5, 2, 35, 35);
    [self.view addSubview:backButton];
    UILabel * versionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(160, 140, 100, 15)] autorelease];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textColor = [UIColor colorWithRed:126/255.f green:126/255.f blue:126/255.f alpha:1];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *currentVersion = [infoDic objectForKey:(NSString *)kCFBundleVersionKey];
    versionLabel.text = [NSString stringWithFormat:@"V %@",currentVersion];
    versionLabel.font = [UIFont systemFontOfSize:14.f];
    [image addSubview:versionLabel];
    
    UIImageView * sohu2003 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sohu-2013.png"]] autorelease];
    CGRect rect = CGRectMake(0, 0, 320, 10);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    rect.origin.y = screenRect.size.height - 20;
    sohu2003.frame = rect;
    [self.view addSubview:sohu2003];
    
    UIButton * ppsohu = [UIButton buttonWithType:UIButtonTypeCustom];
    ppsohu.frame = CGRectMake(183/ 2.f, 768 / 2.f, 150, 20);
    [ppsohu addTarget:self action:@selector(openPPSohu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ppsohu];
}
- (void)openPPSohu:(id)sender
{
    NSLog(@"%s",__FUNCTION__);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PPHOST]];
}
- (void)aboutNavigationBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
