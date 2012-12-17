//
//  UIUtils.h
//  SohuCloudPics
//
//  Created by mysohu on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIUtils : NSObject

/* label style */
+ (void)updateTitleLabel:(UILabel *)label title:(NSString *)title;
+ (void)updateNormalLabel:(UILabel *)label title:(NSString *)title;
+ (void)updateTextView:(UITextView *)textView;
+ (void)updateCountLabel:(UILabel *)label;
+ (void)updateUploadLabel:(UILabel *)label;
+ (void)updateAlbumCountLabel:(UILabel *)label;

/* get label size */
+ (CGSize)getLabelWidth:(UILabel *)label text:(NSString *)text;

/* prune string */
+ (NSString *)pruneString:(NSString *)string toLength:(int)length;	// .. not included in length

@end
