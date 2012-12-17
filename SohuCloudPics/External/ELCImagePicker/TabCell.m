//
//  TabCell.m
//  ELCImagePickerDemo
//
//  Created by mysohu on 12-8-13.
//  Copyright (c) 2012年 ELC Technologies. All rights reserved.
//

#import "TabCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TabCell
@synthesize imageView;
@synthesize delBtn;
@synthesize editBtn;
- (void)dealloc
{
    self.editBtn = nil;
    self.imageView = nil;
    self.delBtn = nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor greenColor];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, 70, 70)];
        
        //影响性能;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 2;
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOpacity = 0.8;
        imageView.layer.shadowOffset = CGSizeMake(0, 2);
        imageView.layer.masksToBounds = NO;
        imageView.layer.shouldRasterize = YES;
        imageView.backgroundColor = [UIColor clearColor];
        
        
        [self addSubview:imageView];
        delBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, -15, 40, 40)];
        delBtn.backgroundColor = [UIColor clearColor];
        [delBtn setImage:[UIImage imageNamed:@"upload_delete.png"] forState:UIControlStateNormal];
        [delBtn setImage:[UIImage imageNamed:@"upload_delete_press.png"] forState:UIControlStateHighlighted];

        [self addSubview:delBtn];
        
        editBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        editBtn.frame = CGRectMake(84 - 30, 84 - 40, 40, 40);
        editBtn.backgroundColor = [UIColor clearColor];
        [editBtn setImage:[UIImage imageNamed:@"upload_edit.png"] forState:UIControlStateNormal];
        [editBtn setImage:[UIImage imageNamed:@"upload_edit_press.png"] forState:UIControlStateHighlighted];

        [self addSubview:editBtn];
    }
    return self;
}
@end
