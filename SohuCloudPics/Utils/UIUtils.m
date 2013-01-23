//
//  UIUtils.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIUtils.h"

#import <QuartzCore/QuartzCore.h>


@implementation UIUtils

+ (void)updateTitleLabel:(UILabel *)label title:(NSString *)title
{
    NSString *setTitle = title;
    if ([title length] > 6) {
        setTitle = [NSString stringWithFormat:@"%@...", [title substringWithRange:NSMakeRange(0, 5)]];
    }
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
    label.text = setTitle;
    label.textAlignment = UITextAlignmentCenter;
    label.font = [label.font fontWithSize:24];
}

+ (void)updateNormalLabel:(UILabel *)label title:(NSString *)title
{
    NSString *setTitle = title;
    if ([title length] > 15) {
        setTitle = [NSString stringWithFormat:@"%@...", [title substringWithRange:NSMakeRange(0, 15)]];
    }
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
    label.text = setTitle;
    label.font = [label.font fontWithSize:15];
}

+ (void)updateTextView:(UITextView *)textView
{
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    textView.font = [textView.font fontWithSize:15];
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textView.returnKeyType = UIReturnKeyDone;
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

+ (void)updateCountLabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0];
    label.textAlignment = UITextAlignmentRight;
    label.font = [label.font fontWithSize:15];
}

+ (void)updateUploadLabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    label.textAlignment = UITextAlignmentRight;
    label.font = [label.font fontWithSize:15];
}

+ (void)updateAlbumCountLabel:(UILabel *)label
{
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
//    [label addSubview:imageview];
//    label.font = [label.font fontWithSize:13];
}
+ (CGSize)getLabelWidth:(UILabel *)label text:(NSString *)text
{
    CGSize maxSize = CGSizeMake(9999, label.font.lineHeight);
    CGSize retSize = [text sizeWithFont:label.font constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
    return retSize;
}

+ (NSString *)pruneString:(NSString *)string toLength:(int)length
{
	return string.length <= length ? string : [NSString stringWithFormat:@"%@...", [string substringWithRange:NSMakeRange(0, length)]];
}

@end
