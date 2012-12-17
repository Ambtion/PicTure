//
//  CommentPostBar.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentPostBar.h"


@implementation CommentPostBar

@synthesize delegate = _delegate;

@synthesize backgroundImageView = _backgroundImageView;
@synthesize commentTextField = _commentTextField;
@synthesize postButton = _postButton;

- (void)dealloc
{
    [_backgroundImageView release];
    [_commentTextField release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = 320;
    frame.size.height = 45;
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        _backgroundImageView.image = [UIImage imageNamed:@"comment_post_bar.png"];
        _backgroundImageView.userInteractionEnabled = YES;
        [_backgroundImageView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)] autorelease]];
        [self addSubview:_backgroundImageView];
        
        _commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(18, 12, 225, 25)];
        _commentTextField.borderStyle = UITextBorderStyleNone;
        _commentTextField.placeholder = @"发表一条评论";;
        _commentTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _commentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _commentTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self addSubview:_commentTextField];
        
        _postButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _postButton.frame = CGRectMake(263, 8, 52, 30);
        [_postButton setImage:[UIImage imageNamed:@"send_btn.png"] forState:UIControlStateNormal];
        [_postButton setImage:[UIImage imageNamed:@"send_btn_h.png"] forState:UIControlStateHighlighted];
        [_postButton addTarget:self action:@selector(postButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_postButton];
        
        self.autoresizesSubviews = YES;
    }
    return self;
}

- (void)backgroundTapped:(id)sender
{
    [_commentTextField resignFirstResponder];
}

- (void)postButtonClicked
{
    [_commentTextField resignFirstResponder];
    if (_delegate && [_delegate respondsToSelector:@selector(commentPostBar:postComment:)]) {
        [_delegate commentPostBar:self postComment:[[_commentTextField.text copy] autorelease]];
    }
}

@end
