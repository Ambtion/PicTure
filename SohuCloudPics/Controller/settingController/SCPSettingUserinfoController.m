//
//  SCPSettingUserinfoController.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-26.
//
//

#import "SCPSettingUserinfoController.h"
#import "UIImageView+WebCache.h"
#import "SCPLoginPridictive.h"
@interface SCPSettingUserinfoController ()

@end

@implementation SCPSettingUserinfoController
- (void)dealloc
{
    [_portraitView release];
    [_nameFiled release];
    [_description release];
    [_request release];
    [super dealloc];
}
- (id)init
{
    if (self = [super init]) {
        _request = [[SCPRequestManager alloc] init];
    }
    return self;
}
- (void)settingnavigationBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveButton:(UIButton *)button
{
    NSString * des = nil;
    if ([_description.text isEqualToString:@"个性签名,随便写点什么吧"]) {
        NSLog(@"%@",_description.text);
        des = @"";
    }
    [_request renameUserinfWithnewName:_nameFiled.text Withdescription:_description.text success:^(NSString *response) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        UIAlertView * alterview = [[UIAlertView alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterview show];
        [alterview release];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView * imageView = [[[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    imageView.image = [UIImage imageNamed:@"personal_setting.png"];
    [self.view addSubview:imageView];
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(settingnavigationBack:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 26, 26);
    
    [self.view addSubview:backButton];
    UIButton* okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setBackgroundImage:[UIImage imageNamed:@"header_OK.png"] forState:UIControlStateNormal];
    [okButton setBackgroundImage:[UIImage imageNamed:@"header_OK_press.png"] forState:UIControlStateHighlighted];
    [okButton addTarget:self action:@selector(saveButton:) forControlEvents:UIControlEventTouchUpInside];
    okButton.frame = CGRectMake(320 - 26, 0, 26, 26);
    [self.view addSubview:okButton];
    
    _portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 100, 60, 60)];
    _portraitView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_portraitView];
    [_request getUserInfoWithID:[SCPLoginPridictive currentUserId] success:^(NSDictionary *response) {
        [_portraitView setImageWithURL:[NSURL URLWithString:[response objectForKey:@"user_icon"]]placeholderImage:[UIImage imageNamed:@"portrait_default.png"]];
    } failure:^(NSString *error) {
        
    }];
    _nameFiled = [[UITextField alloc] initWithFrame:CGRectMake(83, 121, 200, 20)];
    _nameFiled.backgroundColor = [UIColor clearColor];
    _nameFiled.returnKeyType = UIReturnKeyNext;
    _nameFiled.placeholder = @"昵称";
    _nameFiled.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:15];
    _nameFiled.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1];
    _nameFiled.delegate = self;
    [self.view addSubview:_nameFiled];

    _description = [[UITextView alloc] initWithFrame:CGRectMake(8, 170, 310, self.view.bounds.size.height - 250 - 170)];
    NSLog(@"%@",NSStringFromCGRect(_description.frame));
    _description.backgroundColor = [UIColor clearColor];
    _description.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:16];
    _description.returnKeyType = UIReturnKeyDefault;
    _description.delegate = self;
    _description.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1];
    _description.text = @"个性签名,随便写点什么吧";
    [self.view addSubview:_description];
    
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    _description.text = @"";
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSLog(@"%@",textView);
    if (textView.text.length == 0) {
        _description.text = @"个性签名,随便写点什么吧";
        [_description resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _nameFiled) {
        [_nameFiled resignFirstResponder];
        [_description becomeFirstResponder];
    }
    return YES;
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
