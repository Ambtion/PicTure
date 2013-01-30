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
@property(nonatomic,assign)BOOL isMe;
- (CGFloat)getHeigth;
@end
@class FeedDescription;
@protocol FeedDescriptionDelgate <NSObject>
- (void)feedDescription:(FeedDescription *)feed_des DesEditClick:(id)sender;
@end
@interface FeedDescription : UITableViewCell
{
    FeedDescriptionSource * _dataSource;
    UILabel* _describLabel;
    UIButton * _penButton;
    UIButton * _editButton;
}
@property(retain,nonatomic)FeedDescriptionSource * dataScoure;
@property(assign,nonatomic)id<FeedDescriptionDelgate> delegate;
@property(retain,nonatomic)UIButton * penbButton;
@end
