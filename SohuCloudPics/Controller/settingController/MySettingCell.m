//
//  SCPMySettingCell.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import "MySettingCell.h"

@implementation MySettingCell
@synthesize c_ImageView = _c_ImageView;
@synthesize c_Label = _c_Label;
@synthesize accessoryImage = _accessoryImage;

- (void)dealloc
{
    self.c_ImageView = nil;
    self.c_Label = nil;
    self.accessoryImage = nil;
    self.imageSwitch = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addsubVies];
    }
    return self;
}
- (void)addsubVies
{
    
    self.c_ImageView = [[[UIImageView alloc] initWithFrame:CGRectMake((50.f - 28)/2, (55.f - 28)/2, 28, 28)]autorelease];
    self.c_ImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.c_ImageView];
    
    self.c_Label = [[[UILabel alloc] initWithFrame:CGRectMake(self.c_ImageView.frame.origin.x + 32 + 10, self.c_ImageView.frame.origin.y + 9, 200, 14)] autorelease];
    self.c_Label.center = CGPointMake(self.c_Label.center.x, self.c_ImageView.center.y);
    self.c_Label.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:14];
    self.c_Label.backgroundColor = [UIColor clearColor];
    self.c_Label.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1];
    [self.contentView addSubview:self.c_Label];
    
    self.accessoryImage = [[[UIImageView alloc] initWithFrame:CGRectMake(320 - 5 -21, (55 - 21)/2, 21, 21)] autorelease];
    self.accessoryImage.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.accessoryImage];
    
    UIImageView * lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    lineView.frame = CGRectMake(0, 54, 320, 1);
    [self.contentView addSubview:lineView];
    [lineView release];
    
}

@end
