//
//  PhotoSwitch.h
//  SohuCloudPics
//
//  Created by sohu on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoSwitch;
@protocol phothswitchDelegate <NSObject>
-(void)photoSwitch:(PhotoSwitch*)swith photoButtonClick:(UIButton*)button;
-(void)photoSwitch:(PhotoSwitch*)swith setPhotoTypeOfImage:(BOOL)isImage;
@end
@interface PhotoSwitch : UIImageView
{
    id<phothswitchDelegate> _delegate;
    UIButton * _button;
    BOOL sectionOfImage;
}

@property(assign)id<phothswitchDelegate> delegate;
@property(nonatomic,retain)UIButton * button;
- (id)initWithFrame:(CGRect)frame delegate:(id<phothswitchDelegate>)delegate;
- (id)initWithFrameForIphone5:(CGRect)frame delegate:(id<phothswitchDelegate>)delegate;
@end
