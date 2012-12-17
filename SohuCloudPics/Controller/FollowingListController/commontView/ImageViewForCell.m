//
//  ImageForCell.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageViewForCell.h"

@interface ImageViewForCell()

@property (nonatomic) SEL action;
@property (nonatomic, assign) id target;

@end


@implementation ImageViewForCell
@synthesize action = _action, target = _target;
@synthesize imageId;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)] autorelease];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor  clearColor];
    }
    return self;
}

- (void)tapHandle:(UIGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateBegan) {
        if ([self.target respondsToSelector:self.action]) {
            [self.target performSelector:self.action withObject:self];
        }
    }
}

-(void)addTarget:(id)target action:(SEL)action
{
    self.action = action;
    self.target = target;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

@end
