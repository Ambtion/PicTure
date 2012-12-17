//
//  GifDetail.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GifDetail;
@protocol GifDetailDelegate <NSObject>
-(void)GifDetail:(GifDetail*)controller actionAtindex:(NSInteger)index;
@end
@interface GifDetail : UIViewController
{
    NSInteger _selectedSegmentIndex;
    UIImageView* _bgView;
}
@property(retain)NSArray* n_images;
@property(retain)NSArray* s_images;
@property(assign)NSInteger selectedSegmentIndex;
@property(nonatomic,assign)id<GifDetailDelegate> delegate;
-(id)initWithFrame:(CGRect)rect N_image:(NSArray *)nArray  S_image:(NSArray *) sArray;
-(void)setBackImage:(UIImage*)image;
@end
