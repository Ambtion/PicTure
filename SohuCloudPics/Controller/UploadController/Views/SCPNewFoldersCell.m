//
//  SCPNewFoldersCell.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-28.
//
//

#import "SCPNewFoldersCell.h"

@implementation SCPNewFoldersCell
@synthesize addView;
@synthesize labelText;
- (void)dealloc
{
    self.addView = nil;
    self.labelText = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.addView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 30, 30)] autorelease];
        self.labelText = [[[UILabel alloc] initWithFrame:CGRectMake(30, 2, 290, 30)] autorelease];
        self.labelText.font = [UIFont systemFontOfSize:17];
        self.labelText.textColor = [UIColor colorWithRed:98/255.f green:98/255.f blue:98/255.f alpha:1];
        [self.contentView addSubview:self.addView];
        [self.contentView addSubview:self.labelText];
    }
    return self;
}

@end
