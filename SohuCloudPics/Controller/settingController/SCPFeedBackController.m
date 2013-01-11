//
//  SCPFeedBackController.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-7.
//
//

#import "SCPFeedBackController.h"
#import "SCPAlertView_LoginTip.h"
#import "SCPAlert_CustomeView.h"

#define DESC_COUNT_LIMIT 100
#define PLACEHOLDER  @"Bug,崩溃或其他建议"
@implementation SCPFeedBackController
- (void)dealloc
{
    [requset release];
    [_textView release];
    [_placeHolder release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    requset = [[SCPRequestManager alloc] init];
    [self addSubviews];
}

- (void)settingnavigationBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveButton:(UIButton *)button
{
    if (!_textView.text || [_textView.text isEqualToString:@""]) {
        SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:@"请您输入反馈意见" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [tip show];
        [tip release];
    }else{
        [requset feedBackWithidea:_textView.text success:^(NSString *response) {
            SCPAlert_CustomeView * cus = [[[SCPAlert_CustomeView alloc] initWithTitle:@"感谢您的意见"] autorelease];
            [cus show];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *error) {
            SCPAlert_CustomeView * cus = [[[SCPAlert_CustomeView alloc] initWithTitle:error] autorelease];
            [cus show];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
- (void)addSubviews
{
    
    self.view.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f];
    UIImageView * imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
    imageView.image = [UIImage imageNamed:@"title_feedback.png"];
    [self.view addSubview:imageView];
    UITapGestureRecognizer * tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)] autorelease];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(settingnavigationBack:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(5, 2, 35, 35);
    [self.view addSubview:backButton];
    
    UIButton* okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setBackgroundImage:[UIImage imageNamed:@"header_OK.png"] forState:UIControlStateNormal];
    [okButton setBackgroundImage:[UIImage imageNamed:@"header_OK_press.png"] forState:UIControlStateHighlighted];
    [okButton addTarget:self action:@selector(saveButton:) forControlEvents:UIControlEventTouchUpInside];
    okButton.frame = CGRectMake(320 - 40, 2, 35, 35);
    [self.view addSubview:okButton];
    
    UIView * view = [[[UIView alloc] initWithFrame:CGRectMake(10, 105, 300, 150)] autorelease];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 105, 300, 130)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:16];
    _textView.returnKeyType = UIReturnKeyDefault;
    _textView.delegate = self;
    [_textView becomeFirstResponder];
    _textView.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1];
    [self.view addSubview:_textView];
    _placeHolder = [[UITextField alloc] initWithFrame:CGRectMake(10, 6, 200, 20)];
    _placeHolder.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:16];
    _placeHolder.backgroundColor = [UIColor clearColor];
    [_placeHolder setUserInteractionEnabled:NO];
    _placeHolder.placeholder = PLACEHOLDER;
    [_textView addSubview:_placeHolder];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > DESC_COUNT_LIMIT) ? NO : YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.view];
    if ([touch.view isKindOfClass:[UIButton class]] || CGRectContainsPoint(CGRectMake(10, 105, 300, 150), point))
        return NO;
    return YES;
}
- (void)handleGuesture:(UITapGestureRecognizer *)gesture
{
    [_textView resignFirstResponder];
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text && ![textView.text isEqualToString:@""]) {
        if (!_placeHolder.hidden)
            [_placeHolder setHidden:YES];
    }else{
        if (_placeHolder.hidden)
            [_placeHolder setHidden:NO];
    }
}
@end
