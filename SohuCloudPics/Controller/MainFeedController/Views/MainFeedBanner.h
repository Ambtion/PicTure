//
//  SCPMainFeedBanner.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainFeedBanner;

@interface MainFeedBannerDataSource : NSObject
@property(nonatomic,retain)NSString * photoCountLabel;
@property(nonatomic,retain)NSString * timeLabel;
@end


@interface MainFeedBanner : UITableViewCell
{
    UIImageView * _nameLabel;
    UILabel * _photoCountLabel;
    UILabel * _timeLabel;
    
    MainFeedBannerDataSource * _dataSource;
}

@property(nonatomic,retain)MainFeedBannerDataSource * dataSource;
@end
