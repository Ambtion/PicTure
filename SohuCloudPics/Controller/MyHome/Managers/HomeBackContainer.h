//
//  HomeBackContainer.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-21.
//
//

#import <UIKit/UIKit.h>

@class HomeBackContainer;
@protocol HomeBackContainerDelegate <NSObject>
- (void)homeBackContainerSeleced:(UIImage *)image;
@end
@interface HomeBackContainer : UIImageView <UIScrollViewDelegate>
{
    UIImageView * _boxViews;
}
@property (nonatomic,assign)id<HomeBackContainerDelegate> delegate;
- (id)initWithDelegate:(id<HomeBackContainerDelegate>) Adelegete;
- (void)show;
@end
