//
//  SCPUploadCell.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPUploadCell.h"

#import <QuartzCore/QuartzCore.h>

#import "UIImageView+WebCache.h"
#import "UIUtils.h"


@implementation SCPUploadCell

@synthesize uploadController = _uploadController;
@synthesize portraitImageView = _portraitImageView;
@synthesize descBackgroundImageView = _descBackgroundImageView;
@synthesize descTextView = _descTextView;
@synthesize descCountLabel = _descCountLabel;

- (void)dealloc
{
    [_portraitImageView release];
    [_descBackgroundImageView release];
    [_descTextView release];
    [_descCountLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.frame = CGRectMake(0, 0, 320, 68);
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderColor = [UIColor colorWithRed:209.f/255 green:209.f/255 blue:209.f/255 alpha:1].CGColor;
        _bgView.layer.borderWidth = 1.f;
        _bgView.layer.cornerRadius = 4.f;
        [self addSubview:_bgView];
        
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 50, 50)];
        _portraitImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _portraitImageView.layer.borderWidth = 1.f;
        _portraitImageView.layer.shadowColor = [UIColor grayColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(0, 2);
        _portraitImageView.layer.masksToBounds = NO;
        _portraitImageView.layer.shouldRasterize = NO;
        [_bgView addSubview:_portraitImageView];
        
        CGRect frame = CGRectMake(60, 4, 230, _bgView.frame.size.height - 8);
        _descTextView = [[UITextView alloc] initWithFrame:frame];
        _descTextView.font = [_descTextView.font fontWithSize:15];
        _descTextView.textColor = [UIColor colorWithRed:128.0 / 255 green:128.0 / 255 blue:128.0 / 255 alpha:1];
        _descTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _descTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        _descTextView.keyboardAppearance = UIKeyboardAppearanceDefault;
        _descTextView.keyboardType = UIKeyboardTypeDefault;
        _descTextView.delegate = self;
        _descTextView.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_descTextView];
        
        _descCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 15, frame.origin.y + frame.size.height + 4, frame.size.width, 15)];
        _descCountLabel.backgroundColor = [UIColor clearColor];
        [UIUtils updateCountLabel:_descCountLabel];
        [_descCountLabel setText:[NSString stringWithFormat:@"%d/%d", _descTextView.text.length, DESC_COUNT_LIMIT]];
        [self addSubview:_descCountLabel];
    }
    return self;
}

- (void)descTextViewresignFirstResponder
{
    [_descTextView resignFirstResponder];
}

#pragma mark
#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length - range.length + text.length <= DESC_COUNT_LIMIT;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [_descCountLabel setText:[NSString stringWithFormat:@"%d/%d", textView.text.length, DESC_COUNT_LIMIT]];
    return;
	
    CGSize maxinumSize = CGSizeMake(textView.frame.size.width - 13, MAXFLOAT);
    UIFont * font = textView.font;
    CGSize myStringSize = [textView.text sizeWithFont:font constrainedToSize:maxinumSize lineBreakMode:UILineBreakModeClip];
    CGRect descFrame = _descTextView.frame;
    descFrame.size.height = myStringSize.height + 19;
    if (descFrame.size.height < 38) {
        descFrame.size.height = 38;
    }
    
    CGRect cellFrame = self.frame;
    cellFrame.size.height = descFrame.size.height + 40;
    
    [UIView beginAnimations:nil context:nil];
    _descTextView.frame = descFrame;
    _descCountLabel.frame = CGRectMake(descFrame.origin.x, descFrame.origin.y + descFrame.size.height + 1, descFrame.size.width, 15);
    self.frame = cellFrame;
    _bgView.frame = CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height);
    [_uploadController.uploadTableView beginUpdates];
    [_uploadController.uploadTableView endUpdates];
    [UIView commitAnimations];
    
    CGPoint offset = _uploadController.uploadTableView.contentOffset;
    CGFloat currentCellY = textView.superview.frame.origin.y;
    CGFloat currentCellYinWindow = currentCellY - offset.y;
    CGFloat currentCellBottom = currentCellYinWindow + textView.superview.frame.size.height;
    offset.y += ((currentCellBottom + _uploadController.keyboardHeight) - [UIApplication sharedApplication].keyWindow.screen.bounds.size.height);
    [_uploadController.uploadTableView setContentOffset:offset animated:YES];
}
- (void)resignmyFirstResponder
{
    [_descTextView resignFirstResponder];
}
@end
