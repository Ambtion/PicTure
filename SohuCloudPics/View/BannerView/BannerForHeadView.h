//
//  BannerForHeadView.h
//  SohuCloudPics
//
//  Created by sohu on 12-10-17.
//
//

#import <UIKit/UIKit.h>


@class BannerForHeadView;

@protocol BannerDataSoure <NSObject>
- (NSString *)bannerDataSouceLeftLabel;
- (NSString *)bannerDataSouceRightLabel;
@end



@interface BannerForHeadView : UIView
{
    UIImageView *_bannerName;
    UILabel * _labelName;
    id <BannerDataSoure> _datasouce;
}

@property (nonatomic, retain) UILabel *leftLabel;
@property (nonatomic, retain) UILabel *rightLabel;
@property (nonatomic, assign) id <BannerDataSoure> datasouce;
@property (nonatomic, retain) UIImageView *bannerName;
@property (nonatomic, retain) UILabel * labelName;
- (id)initWithImageName:(UIImage *)image;
- (id)initWithLabelName:(NSString *)name;
- (void)BannerreloadDataSource;

@end
