//
//  SCPMySettingCell.h
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import <UIKit/UIKit.h>
#import "ImageQualitySwitch.h"

@interface MySettingCell : UITableViewCell
@property(nonatomic,retain)UIImageView* c_ImageView;
@property(nonatomic,retain)UILabel* c_Label;
@property(nonatomic,retain)UIImageView * accessoryImage;
@property(nonatomic,retain)ImageQualitySwitch * imageSwitch;
@end
