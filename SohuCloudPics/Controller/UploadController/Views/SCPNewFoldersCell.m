//
//  SCPNewFoldersCell.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-21.
//
//

#import "SCPNewFoldersCell.h"

@implementation SCPNewFoldersCell

@synthesize iconView;
@synthesize mylabelText;
@synthesize mydetailText;
- (void)dealloc
{
    self.iconView = nil;
    self.mylabelText = nil;
    self.mydetailText = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 40);
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(4, 5, 30, 30)] autorelease];
        self.iconView.backgroundColor = [UIColor clearColor];
        self.mylabelText = [[[UILabel alloc] initWithFrame:CGRectMake(40, 4, 240, 18)] autorelease];
        self.mylabelText.font = [UIFont systemFontOfSize:16];
        self.mylabelText.textColor = [UIColor colorWithRed:98/255.f green:98/255.f blue:98/255.f alpha:1];
        self.mylabelText.backgroundColor = [UIColor clearColor];

        self.mydetailText = [[[UILabel alloc] initWithFrame:CGRectMake(40, 24, 240, 14)] autorelease];
        self.mydetailText.font = [UIFont systemFontOfSize:12];
        self.mydetailText.textColor = [UIColor colorWithRed:98/255.f green:98/255.f blue:98/255.f alpha:1];
        self.mydetailText.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.mydetailText];
        [self.contentView addSubview:self.mylabelText];

    }
    return self;
}
@end
