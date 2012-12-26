//
//  SCPSettingUserinfoController.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-26.
//
//

#import "SCPSettingUserinfoController.h"

@interface SCPSettingUserinfoController ()

@end

@implementation SCPSettingUserinfoController
- (void)dealloc
{
    [_portraitView release];
    [_nameFiled release];
    [_description release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _request = [[SCPRequestManager alloc] init];
    _portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 105, 50, 50)];
    _portraitView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_portraitView];
    
    _nameFiled = [[UITextField alloc] initWithFrame:CGRectMake(90, 105, 100, 50)];
    _nameFiled.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_nameFiled];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [_nameFiled becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
