//
//  MyFavouriteView.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-21.
//
//

#import "MyFavouriteView.h"

@implementation MyFavouriteView
@synthesize textLabel,imageView;

- (void)dealloc
{
    self.imageView = nil;
    self.textLabel = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, 51, 18);
        tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)] autorelease];
        self.imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageView];

        self.textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(23, 0, 28, 18)] autorelease];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = UITextAlignmentLeft;
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        self.textLabel.textColor = [UIColor colorWithRed:113.f/255 green:113/255.f blue:113/255.f alpha:1];
        self.textLabel.shadowColor = [UIColor whiteColor];
        self.textLabel.shadowOffset = CGSizeMake(0, 1);
        [self addSubview:self.textLabel];
    }
    return self;
}
-(void)addtarget:(id)target action:(SEL)action
{
    [tap addTarget:target action:action];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
