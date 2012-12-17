//
//  ImageForCell.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewForCell : UIImageView
{
    SEL _action;
    id _target;
}

- (id)initWithFrame:(CGRect)frame;
- (void)addTarget:(id)target action:(SEL)action;

//store imageinfo
@property (nonatomic,retain) NSString *imageId;

@end
