//
//  SCPAlert_Rename.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-10.
//
//

#import "SCPAlert_Rename.h"
#import "SCPAlertView_LoginTip.h"
#import "EmojiUnit.h"

@implementation SCPAlert_Rename


- (void)dealloc
{
    [_backgroundImageView release];
    [_alertboxImageView release];
    [_renameField release];
    [_okButton release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
    
}
- (id)initWithDelegate:(id<SCPAlertRenameViewDelegate>)delegate name:(NSString *)name
{
    
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (self) {
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.image = [UIImage imageNamed:@"pop_bg.png"];
        [self addSubview:_backgroundImageView];
        
        _alertboxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, (self.bounds.size.height - 178) / 2, 240, 178)];
        _alertboxImageView.image = [UIImage imageNamed:@"pop_up_bg.png"];
        [self addSubview:_alertboxImageView];
        [_alertboxImageView setUserInteractionEnabled:YES];
        
        UILabel * label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 240, 15)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.textColor =  [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        label.text = @"新建私密专辑";
        label.textAlignment = UITextAlignmentCenter;
        [_alertboxImageView addSubview:label];
        
        UIImageView * bg_view = [[[UIImageView alloc] initWithFrame:CGRectMake((240 - 192)/2.f, 49, 192, 35)] autorelease];
        [bg_view setUserInteractionEnabled:YES];
        
        bg_view.image = [UIImage imageNamed:@"pop_up_filed.png"];
        bg_view.backgroundColor = [UIColor whiteColor];
        _renameField = [[UITextField alloc] initWithFrame:CGRectMake(5, 6, 190 - 7, 23)];
        _renameField.backgroundColor = [UIColor clearColor];
        _renameField.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        _renameField.font = [_renameField.font fontWithSize:15];
        _renameField.placeholder = name;
        _renameField.textAlignment = UITextAlignmentLeft;
        _renameField.borderStyle = UITextBorderStyleNone;
        _renameField.returnKeyType = UIReturnKeyDefault;
        _renameField.delegate = self;
        [bg_view addSubview:_renameField];
        [_alertboxImageView addSubview:bg_view];
        
        //外面不用
        UIButton* _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(22, 209 - 89, 90, 35);
        _cancelButton.titleLabel.font = [_cancelButton.titleLabel.font fontWithSize:16];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"pop_btn_normal.png"] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"pop_btn_press.png"] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_alertboxImageView addSubview:_cancelButton];
        
        _okButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _okButton.frame = CGRectMake(128, 209 - 89, 90, 35);
        _okButton.titleLabel.font = [_okButton.titleLabel.font fontWithSize:16];
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1] forState:UIControlStateNormal];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"pop_btn_normal.png"] forState:UIControlStateNormal];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"pop_btn_press.png"] forState:UIControlStateHighlighted];
        [_okButton addTarget:self action:@selector(okClicked) forControlEvents:UIControlEventTouchUpInside];
        [_alertboxImageView addSubview:_okButton];
        [_okButton setUserInteractionEnabled:NO];
        [_okButton setAlpha:0.3];
        _okButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _delegate = delegate;
        
        [self addObserverofKeyBoard];
    }
    return self;
    
}
#pragma mark - 
#pragma mark TextFiled Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (!newLength) {
        [_okButton setUserInteractionEnabled:NO];
        [_okButton setAlpha:0.3];
    }else{
        [_okButton setUserInteractionEnabled:YES];
        [_okButton setAlpha:1.f];
    }
    return YES;
}
- (void)addObserverofKeyBoard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardWillShow:(NSNotification *)notice
{
    
    CGRect rect = [[[notice userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect finalRect = _alertboxImageView.frame;
    finalRect.origin.y -= (finalRect.origin.y +finalRect.size.height - rect.origin.y);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _alertboxImageView.frame = finalRect;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)keyBoardWillHide:(NSNotification *)notice
{
    CGFloat deley = [[[notice userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:0.2 delay:deley options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _alertboxImageView.center  = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)show
{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
}

- (void)cancelClicked
{
    if ([_renameField isFirstResponder]) {
        [_renameField resignFirstResponder];
    }else{
        [self removeFromSuperview];
    }
}
- (void)okClicked
{
    if (!_renameField.text || [_renameField.text isEqualToString:@""]) {
        return;
    }
    if ([EmojiUnit stringContainsEmoji:_renameField.text]) {
        SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:@"提示信息" message:@"专辑名称不能包含特殊字符或表情" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [tip show];
        [tip release];
        return;
    }
    if ([_delegate respondsToSelector:@selector(renameAlertView:OKClicked:)]) {
        [_delegate performSelector:@selector(renameAlertView:OKClicked:) withObject:self withObject:_renameField];
    }
    if ([_renameField isFirstResponder]) {
        [_renameField resignFirstResponder];
    }else{
        [self removeFromSuperview];
    }
   
}
@end
