//
//  PersonalPageCell.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuButtonView.h"
#import "RefreshButton.h"

@class PersonalPageCell;
@interface PersonalPageCellDateSouce : NSObject
@property(nonatomic,retain)NSDictionary * allInfo;
@property(nonatomic,retain)NSString * portrait;
@property(nonatomic,retain)NSString* name;
//@property(nonatomic,retain)NSString* position;
@property(nonatomic,retain)NSString* desc;
@property(nonatomic,assign)BOOL isFollowed;

@property(nonatomic,assign)NSInteger albumAmount;
@property(nonatomic,assign)NSInteger favouriteAmount;
@property(nonatomic,assign)NSInteger followedAmount;
@property(nonatomic,assign)NSInteger followingAmount;
@end

@protocol PersonalPageCellDelegate <NSObject>

- (void)personalPageCell:(PersonalPageCell *)personal followedButtonClicked:(id)sender;
- (void)personalPageCell:(PersonalPageCell *)personal followingButtonClicked:(id)sender;
- (void)personalPageCell:(PersonalPageCell *)personal photoBookClicked:(id)sender;
- (void)personalPageCell:(PersonalPageCell *)personal favoriteClicked:(id)sender;
- (void)personalPageCell:(PersonalPageCell *)personal follwetogether:(id)sender;
- (void)personalPageCell:(PersonalPageCell *)personal refreshClick:(id)sender;

@end

@interface PersonalPageCell : UITableViewCell<MenuButtonViewDelegate>
{
    PersonalPageCellDateSouce * _dataSource;
    UIImageView * _backgroundImageView;
    UIImageView * _portraitImageView;
    UILabel * _nameLabel;
    UILabel * _descLabel;
    UIButton * _followButton;
    
    MenuButtonView * _albumButton;
    MenuButtonView * _favorButton;
    MenuButtonView * _followingButton;
    MenuButtonView * _followedButton;
}
@property (assign, nonatomic) id<PersonalPageCellDelegate> delegate;
@property(retain,nonatomic) PersonalPageCellDateSouce * datasource;
@end
