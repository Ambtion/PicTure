//
//  CountLabel.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-23.
//
//

#import "CountLabel.h"

@implementation CountLabel

- (void)dealloc
{
    [_bgImageView release];
    [_baseLabel release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"album_nb.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(9.f, 9.f, 9.f, 9.f)]];
        _bgImageView.backgroundColor = [UIColor clearColor];
        _bgImageView.frame = self.bounds;
        _baseLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _baseLabel.backgroundColor = [UIColor clearColor];
        _baseLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_bgImageView];
        [self addSubview:_baseLabel];
    }
    return self;
}
#pragma mark
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _bgImageView.frame = self.bounds;
    _baseLabel.frame = self.bounds;
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [_baseLabel setFont:font];
}
- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:[UIColor clearColor]];
    [_baseLabel setTextColor:textColor];
}
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
}
- (void)setText:(NSString *)text
{
    [_baseLabel setText:text];
}
- (void)sizeToFit
{
    [_baseLabel sizeToFit];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _baseLabel.frame.size.width, _baseLabel.frame.size.height);
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
