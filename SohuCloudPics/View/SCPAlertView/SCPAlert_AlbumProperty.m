//
//  SCPAlert_AlbumProperty.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-10.
//
//

#import "SCPAlert_AlbumProperty.h"
#define OFFSET 10
@implementation SCPAlert_AlbumProperty
- (void)dealloc
{
    [_backgroundImageView release];
    [_alertboxImageView release];
    [_renameField release];
    [_public release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
- (void)handleGesture:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:_backgroundImageView];
    if (CGRectContainsPoint(_alertboxImageView.frame, point)) return;
    [_renameField resignFirstResponder];
}
- (id)initWithDelegate:(id<SCPAlert_AlbumPropertyDelegate>)delegate name:(NSString *)name isPublic:(BOOL)isPublic
{
    
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (self) {
        
        shouldRemove = NO;
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.image = [UIImage imageNamed:@"pop_bg.png"];
        [_backgroundImageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer * gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)] autorelease];
        [_backgroundImageView addGestureRecognizer:gesture];
        [self addSubview:_backgroundImageView];
        
        _alertboxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, (self.bounds.size.height - 202) / 2, 240, 215)];
        _alertboxImageView.image = [UIImage imageNamed:@"pop_alert_M_bg.png"];
        [self addSubview:_alertboxImageView];
        [_alertboxImageView setUserInteractionEnabled:YES];
        
        UILabel * label = [[[UILabel alloc] initWithFrame:CGRectMake(20, 15, 200, 20)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.textColor =  [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:18];
        label.text = @"编辑相册";
        [_alertboxImageView addSubview:label];
        
        UILabel * rename = [[[UILabel alloc] initWithFrame:CGRectMake(20 , 40 + OFFSET, 200, 15)] autorelease];
        rename.backgroundColor = [UIColor clearColor];
        rename.textColor =  [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        rename.textAlignment = UITextAlignmentLeft;
        rename.text = @"重命名";
        [_alertboxImageView addSubview:rename];
        
        UIImageView * bg_view = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 62 + OFFSET, 200, 35)] autorelease];
        [bg_view setUserInteractionEnabled:YES];
        bg_view.image = [UIImage imageNamed:@"pop_up_filed.png"];
        bg_view.backgroundColor = [UIColor whiteColor];
        _renameField = [[UITextField alloc] initWithFrame:CGRectMake(5, 6, 195, 23)];
        _renameField.backgroundColor = [UIColor clearColor];
        _renameField.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        _renameField.font = [_renameField.font fontWithSize:15];
        _renameField.text = name;
        _renameField.textAlignment = UITextAlignmentLeft;
        _renameField.borderStyle = UITextBorderStyleNone;
        _renameField.returnKeyType = UIReturnKeyDefault;
        [bg_view addSubview:_renameField];
        [_alertboxImageView addSubview:bg_view];
        
        UILabel * public = [[[UILabel alloc] initWithFrame:CGRectMake(20, 115 + OFFSET, 109, 16)] autorelease];
        public.backgroundColor = [UIColor clearColor];
        public.textColor =  [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        public.text = @"相册权限";
        public.textAlignment = UITextAlignmentLeft;
        [_alertboxImageView addSubview:public];
        //相反的 ..
        _public = [[ImageQualitySwitch alloc] initWithFrame:CGRectMake(130, 112 + OFFSET, 0, 0) WithOriginalImage:!isPublic];
        [_alertboxImageView addSubview:_public];
        
        //外面不用
        UIButton* _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(22, 215 - 35 - 20, 90, 35);
        _cancelButton.titleLabel.font = [_cancelButton.titleLabel.font fontWithSize:16];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"pop_btn_normal.png"] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"pop_btn_press.png"] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_alertboxImageView addSubview:_cancelButton];
        
        UIButton* _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _okButton.frame = CGRectMake(128, 215 - 35 - 20, 90, 35);
        _okButton.titleLabel.font = [_okButton.titleLabel.font fontWithSize:16];
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1] forState:UIControlStateNormal];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"pop_btn_normal.png"] forState:UIControlStateNormal];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"pop_btn_press.png"] forState:UIControlStateHighlighted];
        [_okButton addTarget:self action:@selector(okClicked) forControlEvents:UIControlEventTouchUpInside];
        [_alertboxImageView addSubview:_okButton];
        _okButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _delegate = delegate;
        
        [self addObserverofKeyBoard];
    }
    return self;
    
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
        if (shouldRemove)
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
        shouldRemove = YES;
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
    if ([_delegate respondsToSelector:@selector(albumProperty:OKClicked:ispublic:)]) {
        //相反的
        [_delegate albumProperty:self OKClicked:_renameField ispublic:!_public.originalImage];
    }
    if ([_renameField isFirstResponder]) {
        shouldRemove = YES;
        [_renameField resignFirstResponder];
    }else{
        [self removeFromSuperview];
    }
    
}

@end
