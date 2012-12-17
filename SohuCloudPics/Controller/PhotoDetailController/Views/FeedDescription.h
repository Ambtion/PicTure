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
@property(nonatomic,retain)NSString * bookMark;

@end
@interface FeedDescription : UITableViewCell
{
    FeedDescriptionSource * _dataSource;
    UILabel* describLabel;
    UILabel* bookMarkLabel;
}
@property(retain,nonatomic)FeedDescriptionSource * dataScoure;
@end
