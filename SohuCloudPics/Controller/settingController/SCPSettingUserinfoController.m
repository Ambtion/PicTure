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
#import "SCPAlertView_LoginTip.h"
#import <QuartzCore/QuartzCore.h>

#define DESC_COUNT_LIMIT 400
#define NAME_COUNT_LIMIT 12
#define PLACEHOLDER @"请描述一下"

@implementation SCPSettingUserinfoController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_request setDelegate:nil];
    [_request release];
    [_portraitView release];
    [_nameFiled release];
    [_description release];
    [_placeHolder release];
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
    if ([self stringContainsEmoji:_nameFiled.text] || [self stringContainsEmoji:_description.text]) {
        SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:@"您输入的内容包含非法字符,请重新输入" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [tip show];
        [tip release];
        return;
    }
    [_request renameUserinfWithnewName:_nameFiled.text Withdescription:_description.text success:^(NSString *response) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        SCPAlertView_LoginTip * alterview = [[SCPAlertView_LoginTip alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterview show];
        [alterview release];
    }];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSubviews];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if (![SCPLoginPridictive currentUserId]) return;
    [_request getUserInfoWithID:[NSString stringWithFormat:@"%@",[SCPLoginPridictive currentUserId]] asy:NO success:^(NSDictionary *response) {
        [_portraitView setImageWithURL:[NSURL URLWithString:[response objectForKey:@"user_icon"]] placeholderImage:[UIImage imageNamed:@"portrait_default.png"]];
        _nameFiled.text = [response objectForKey:@"user_nick"];
        if (![response objectForKey:@"user_desc"]||[[response objectForKey:@"user_desc"] isEqualToString:@""] ) {
            
        }else{
            _description.text = [response objectForKey:@"user_desc"];
            [_placeHolder setHidden:YES];
        }
    } failure:^(NSString *error) {
        NSLog(@"%s, %@",__FUNCTION__, error);
    }];
}
- (void)addSubviews
{
    
    UIImageView * imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    imageView.image = [UIImage imageNamed:@"personal_setting.png"];
    [self.view addSubview:imageView];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(settingnavigationBack:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(5, 2, 35, 35);
    [self.view addSubview:backButton];
    UITapGestureRecognizer * tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)] autorelease];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    
    UIButton* okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setBackgroundImage:[UIImage imageNamed:@"header_OK.png"] forState:UIControlStateNormal];
    [okButton setBackgroundImage:[UIImage imageNamed:@"header_OK_press.png"] forState:UIControlStateHighlighted];
    [okButton addTarget:self action:@selector(saveButton:) forControlEvents:UIControlEventTouchUpInside];
    okButton.frame = CGRectMake(320 - 40, 2, 35, 35);
    [self.view addSubview:okButton];
    
    _portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 100, 35, 35)];
    _portraitView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_portraitView];
    
    _nameFiled = [[UITextField alloc] initWithFrame:CGRectMake(51, 106, 230, 20)];
    _nameFiled.backgroundColor = [UIColor clearColor];
    _nameFiled.returnKeyType = UIReturnKeyNext;
    _nameFiled.delegate = self;
    _nameFiled.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:15];
    _nameFiled.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1];
    _nameFiled.delegate = self;
    [self.view addSubview:_nameFiled];
    
    textView_bg = [[[UIView alloc] initWithFrame:CGRectMake(8, 142, 304, 115)] autorelease];
    textView_bg.backgroundColor = [UIColor whiteColor];
    textView_bg.layer.cornerRadius = 5.f;
    textView_bg.layer.borderColor = [UIColor colorWithRed:222.f/255.f green:222.f/255.f blue:222.f/255.f alpha:1].CGColor;
    textView_bg.layer.borderWidth = 1.f;
    textView_bg.layer.shouldRasterize = NO;
    [self.view addSubview:textView_bg];

    _description = [[UITextView alloc] initWithFrame:CGRectMake(2, 2, 300, 111)];
    _description.backgroundColor = [UIColor clearColor];
    _description.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:16];
    _description.returnKeyType = UIReturnKeyDefault;
    _description.delegate = self;
    _description.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1];
    _description.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [textView_bg addSubview:_description];
    
    _placeHolder = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 250, 20)];
    _placeHolder.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:16];
    _placeHolder.backgroundColor = [UIColor clearColor];
    [_placeHolder setUserInteractionEnabled:NO];
    _placeHolder.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:15];
    _placeHolder.textColor = [UIColor colorWithRed:137.f/255 green:137.f/255 blue:137.f/255 alpha:1];
    _placeHolder.text = PLACEHOLDER;
    [_description addSubview:_placeHolder];

}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    CGFloat heigth = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect rect = textView_bg.frame;
    rect.size.height = self.view.bounds.size.height - heigth - rect.origin.y - 8;
    [UIView animateWithDuration:0.3 animations:^{
        textView_bg.frame = rect;
        _description.frame = CGRectMake(2, 2, textView_bg.frame.size.width - 4, textView_bg.frame.size.height - 4);
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        textView_bg.frame = CGRectMake(8, 122, 304, 134);
        _description.frame = CGRectMake(2, 2, textView_bg.frame.size.width - 4, textView_bg.frame.size.height - 4);
    }];
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
//    [_nameFiled resignFirstResponder];
//    [_description resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > NAME_COUNT_LIMIT) ? NO : YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > DESC_COUNT_LIMIT) ? NO : YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _nameFiled) {
        [_nameFiled resignFirstResponder];
        [_description becomeFirstResponder];
    }
    return YES;
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
- (void)viewWillAppear:(BOOL)animated
{
    [_nameFiled becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
