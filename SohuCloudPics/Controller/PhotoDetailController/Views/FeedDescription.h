//
//  FeedDescribtion.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeedDescriptionSource : NSObject

@property(nonatomic,retain)NSString * describtion;

@end
@interface FeedDescription : UITableViewCell
{
    FeedDescriptionSource * _dataSource;
    UILabel* describLabel;
}
@property(retain,nonatomic)FeedDescriptionSource * dataScoure;
@end
