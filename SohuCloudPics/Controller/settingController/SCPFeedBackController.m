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
#import <QuartzCore/QuartzCore.h>

#define DESC_COUNT_LIMIT 200
#define PLACEHOLDER  @"您遇到的任何问题或您的建议"
#define TITLE_DES @"您的反馈有助于我们的改进"

@implementation SCPFeedBackController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [requset release];
    [_textView release];
    [_placeHolder release];
    [saveButton release];
    [textView_bg release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    requset = [[SCPRequestManager alloc] init];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self addSubviews];
}

- (void)settingnavigationBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

- (void)saveButton:(UIButton *)button
{
    if ([self stringContainsEmoji:_textView.text]) {
        SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:@"您输入的内容包含非法字符,请重新输入" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [tip show];
        [tip release];
        return;
    }
    [requset feedBackWithidea:_textView.text success:^(NSString *response) {
        SCPAlert_CustomeView * cus = [[[SCPAlert_CustomeView alloc] initWithTitle:@"成功提交,感谢您的反馈"] autorelease];
        [cus show];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        SCPAlert_CustomeView * cus = [[[SCPAlert_CustomeView alloc] initWithTitle:error] autorelease];
        [cus show];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)addSubviews
{
    
    self.view.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f];
    UIImageView * imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
    imageView.image = [UIImage imageNamed:@"title_feedback.png"];
    [self.view addSubview:imageView];
    
    UILabel * titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(5, 100, 160, 18);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = TITLE_DES;
    [imageView addSubview:titleLabel];
    UITapGestureRecognizer * tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)] autorelease];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(settingnavigationBack:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(5, 2, 35, 35);
    [self.view addSubview:backButton];
    
    saveButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"header_OK.png"] forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"header_OK_press.png"] forState:UIControlStateHighlighted];
    [saveButton addTarget:self action:@selector(saveButton:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.frame = CGRectMake(320 - 40, 2, 35, 35);
    [saveButton setAlpha:0.3];
    [saveButton setUserInteractionEnabled:NO];
    [self.view addSubview:saveButton];
    
    textView_bg = [[UIView alloc] initWithFrame:CGRectMake(8, 122, 304, 134)];
    textView_bg.backgroundColor = [UIColor whiteColor];
    textView_bg.layer.cornerRadius = 5.f;
    textView_bg.layer.borderColor = [UIColor colorWithRed:222.f/255.f green:222.f/255.f blue:222.f/255.f alpha:1].CGColor;
    textView_bg.layer.borderWidth = 1.f;
    textView_bg.layer.shouldRasterize = NO;
    [self.view addSubview:textView_bg];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(2, 2, 300, 130)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:16];
    _textView.returnKeyType = UIReturnKeyDefault;
    _textView.delegate = self;

    [_textView becomeFirstResponder];
    _textView.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1];
    
    [textView_bg addSubview:_textView];
    _placeHolder = [[UITextField alloc] initWithFrame:CGRectMake(10, 6, 250, 20)];
    _placeHolder.placeholder = PLACEHOLDER;
    [_placeHolder setUserInteractionEnabled:NO];
    [_textView addSubview:_placeHolder];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    CGFloat heigth = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect rect = textView_bg.frame;
    rect.size.height = self.view.bounds.size.height - heigth - rect.origin.y - 8;
    [UIView animateWithDuration:0.3 animations:^{
        textView_bg.frame = rect;
        _textView.frame = CGRectMake(2, 2, textView_bg.frame.size.width - 4, textView_bg.frame.size.height - 4);
    }];
    NSLog(@"%@",[dic objectForKey:UIKeyboardFrameEndUserInfoKey]);
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        textView_bg.frame = CGRectMake(8, 122, 304, 134);
        _textView.frame = CGRectMake(2, 2, textView_bg.frame.size.width - 4, textView_bg.frame.size.height - 4);
    }];
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
//    [_textView resignFirstResponder];
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text && ![textView.text isEqualToString:@""]) {
        [saveButton setAlpha:1.0];
        [saveButton setUserInteractionEnabled:YES];
        if (!_placeHolder.hidden)
            [_placeHolder setHidden:YES];
    }else{
        [saveButton setAlpha:0.3];
        [saveButton setUserInteractionEnabled:NO];
        if (_placeHolder.hidden)
            [_placeHolder setHidden:NO];
    }
}
@end
