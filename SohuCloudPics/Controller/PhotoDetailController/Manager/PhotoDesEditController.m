//
//  SCPDescriptionEditController.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-15.
//
//修改图片描述

#import "PhotoDesEditController.h"
#import "SCPFeedBackController.h"
#import "SCPAlertView_LoginTip.h"
#import "SCPAlert_CustomeView.h"
#import "SCPMenuNavigationController.h"
#import "SCPPhotoDetailController.h"
#import "PhotoDetailManager.h"
#import "EmojiUnit.h"

#define DESC_COUNT_LIMIT 300
#define PLACEHOLDER  @"添加描述"
#define TITLE_DES @"300字以内"


@implementation PhotoDesEditController
@synthesize photo_id = _photo_id;
@synthesize originalDes = _originalDes;

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_requset release];
    [_textView release];
    [_placeHolder release];
    [_saveButton release];
    [_textView_bg release];
    [_originalDes release];
    [_photo_id release];
    [super dealloc];
}
- (id)initphoto:(NSString *)photo_id withDes:(NSString * )des
{
    if (self = [super init]) {
        self.originalDes = des;
        self.photo_id = photo_id;
    }
    return self;
}
#pragma mark - view
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customerNavigationbar];
    _requset = [[SCPRequestManager alloc] init];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self addSubviews];
}
- (void)barButtonBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)customerNavigationbar
{
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 35, 35);
    [backButton setImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(barButtonBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    
    _saveButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_saveButton setBackgroundImage:[UIImage imageNamed:@"header_OK.png"] forState:UIControlStateNormal];
    [_saveButton setBackgroundImage:[UIImage imageNamed:@"header_OK_press.png"] forState:UIControlStateHighlighted];
    [_saveButton addTarget:self action:@selector(saveButton:) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.frame = CGRectMake(0, 0, 35, 35);
    UIBarButtonItem * item = [[[UIBarButtonItem alloc] initWithCustomView:_saveButton] autorelease];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [((SCPMenuNavigationController *) self.navigationController).menuView setHidden:YES];
    [((SCPMenuNavigationController *) self.navigationController).ribbonView setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [((SCPMenuNavigationController *) self.navigationController).ribbonView setHidden:NO];
}

- (void)saveButton:(UIButton *)button
{
    
    if ([EmojiUnit stringContainsEmoji:_textView.text]) {
        SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:@"提示信息" message:@"图片描述不能包含特殊字符或表情" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [tip show];
        [tip release];
        return;
    }
    [_requset editphotot:self.photo_id Description:_textView.text success:^(NSString *response) {
        SCPAlert_CustomeView * cus = [[[SCPAlert_CustomeView alloc] initWithTitle:@"修改成功"] autorelease];
        [cus show];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        if ([error isEqualToString:REFRESHFAILTURE]) {
            SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:@"提示信息" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [tip show];
            [tip release];
            return;
        }
        SCPAlert_CustomeView * cus = [[[SCPAlert_CustomeView alloc] initWithTitle:error] autorelease];
        [cus show];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SCPMenuNavigationController * menu = (SCPMenuNavigationController *)self.navigationController;
    [menu.menuManager onPlazeClicked:nil];
}

- (void)addSubviews
{
    
    self.view.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f];
    UIImageView * imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
    imageView.image = [UIImage imageNamed:@"title_description.png"];
    [self.view addSubview:imageView];
    UILabel * titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(5, 100, 160, 18);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = TITLE_DES;
    [imageView addSubview:titleLabel];
    
    _textView_bg = [[UIView alloc] initWithFrame:CGRectMake(8, 122, 304, 134)];
    _textView_bg.backgroundColor = [UIColor whiteColor];
    _textView_bg.layer.cornerRadius = 5.f;
    _textView_bg.layer.borderColor = [UIColor colorWithRed:222.f/255.f green:222.f/255.f blue:222.f/255.f alpha:1].CGColor;
    _textView_bg.layer.borderWidth = 1.f;
    _textView_bg.layer.masksToBounds = NO;
    _textView_bg.layer.shouldRasterize = NO;
    [self.view addSubview:_textView_bg];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(2, 2, 300, 130)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:16];
    _textView.returnKeyType = UIReturnKeyDefault;
    _textView.delegate = self;
    _textView.text = _originalDes;
    [_textView becomeFirstResponder];
    _textView.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1];
    
    [_textView_bg addSubview:_textView];
    _placeHolder = [[UITextField alloc] initWithFrame:CGRectMake(10, 6, 250, 20)];
    _placeHolder.placeholder = PLACEHOLDER;
    [_placeHolder setUserInteractionEnabled:NO];
    [_textView addSubview:_placeHolder];
    [self textViewDidChange:_textView];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    CGFloat heigth = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect rect = _textView_bg.frame;
    rect.size.height = self.view.bounds.size.height - heigth - rect.origin.y - 8;
    [UIView animateWithDuration:0.3 animations:^{
        _textView_bg.frame = rect;
        _textView.frame = CGRectMake(2, 2, _textView_bg.frame.size.width - 4, _textView_bg.frame.size.height - 4);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        _textView_bg.frame = CGRectMake(8, 122, 304, 134);
        _textView.frame = CGRectMake(2, 2, _textView_bg.frame.size.width - 4, _textView_bg.frame.size.height - 4);
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
        //        [_saveButton setAlpha:1.0];
        //        [_saveButton setUserInteractionEnabled:YES];
        if (!_placeHolder.hidden)
            [_placeHolder setHidden:YES];
    }else{
        //        [_saveButton setAlpha:0.3];
        //        [_saveButton setUserInteractionEnabled:NO];
        if (_placeHolder.hidden)
            [_placeHolder setHidden:NO];
    }
}
@end
