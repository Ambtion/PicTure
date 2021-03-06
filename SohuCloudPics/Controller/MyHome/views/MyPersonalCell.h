//
//  MyPersonalCell.h
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import <UIKit/UIKit.h>
#import "MenuButtonView.h"
#import "RefreshButton.h"
#import "UIImageView+WebCache.h"
#import "HomeBackContainer.h"

@class MyPersonalCell;

@interface MyPersonalCelldataSource : NSObject

@property(nonatomic,assign)BOOL isInit;
@property(nonatomic,retain)NSString * portrait;
@property(nonatomic,retain)NSString* name;
@property(nonatomic,retain)NSString* position;
@property(nonatomic,retain)NSString* desc;

@property(nonatomic,assign)NSInteger albumAmount;
@property(nonatomic,assign)NSInteger followedAmount;
@property(nonatomic,assign)NSInteger followingAmount;

- (CGFloat)getheitgth;
@end

@protocol MyPersonalCellDelegate <NSObject>
- (void)MyPersonalCell:(MyPersonalCell *)cell followedButtonClicked:(id)sender;
- (void)MyPersonalCell:(MyPersonalCell *)cell followingButtonClicked:(id)sender;
- (void)MyPersonalCell:(MyPersonalCell *)cell photoBookClicked:(id)sender;
- (void)MyPersonalCell:(MyPersonalCell *)cell favoriteClicked:(id)sender;
- (void)MyPersonalCell:(MyPersonalCell *)cell settingClick:(id)sender;
- (void)MyPersonalCell:(MyPersonalCell *)cell refreshClick:(id)sender;

@end

@interface MyPersonalCell : UITableViewCell<MenuButtonViewDelegate,HomeBackContainerDelegate>
{
    MyPersonalCelldataSource * _dataSource;
    UIImageView * _backgroundImageView;
    UIImageView * _portraitImageView;
    UIImageView * bgCircleView;
    
    UILabel * _nameLabel;
    UILabel * _descLabel;
    UIButton * _settingButton;
    
    MenuButtonView * _albumButton;
    MenuButtonView * _followingButton;
    MenuButtonView * _followedButton;
}
@property (assign, nonatomic) id<MyPersonalCellDelegate> delegate;
@property(retain,nonatomic) MyPersonalCelldataSource * datasource;

@end
