//
//  MoreAlterView.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-5.
//
//

#import "MoreAlertView.h"

@implementation MoreAlertView

- (id)init
{
    self = [super init];
//    self = [super initWithTitle:@"已经最多" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    if (self) {
        self.title = @"已经最多";
//        self.delegate = self;
        [self addButtonWithTitle:@"确定"];
        // Initialization code
    }
    return self;
}

@end
