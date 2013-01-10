//
//  SCPWatiAlterView.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-26.
//
//

#import "SCPAlert_WaitView.h"

@implementation SCPAlert_WaitView

#ifdef ALERT
- (void)dealloc
{
    [backgroundView release];
    [alertTextLabel release];
    [activity release];
    [_superView release];
    [super dealloc];
}
- (id) initWithImage:(UIImage *)backgroundImage text:(NSString *)text withView:(UIView *)superView
{
    
    if (self = [super init]) {
        
        self.frame = [[UIScreen mainScreen] bounds] ;
        UIImageView * bgView = [[[UIImageView alloc] initWithFrame:[self  bounds]] autorelease];
        bgView.image = [UIImage imageNamed:@"pop_bg.png"];
        [self  addSubview:bgView];
        backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        backgroundView.frame = CGRectMake(0, 0, 130, 130);
        backgroundView.center = CGPointMake(bgView.frame.size.width / 2.f, bgView.frame.size.height / 2.f);
        [self addSubview:backgroundView];
		alertTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        alertTextLabel.backgroundColor = [UIColor redColor];
		alertTextLabel.textColor = [UIColor whiteColor];
		alertTextLabel.backgroundColor = [UIColor clearColor];
		alertTextLabel.font = [UIFont boldSystemFontOfSize:16.f];
        alertTextLabel.textAlignment = UITextAlignmentCenter;
        alertTextLabel.text = text;
        [alertTextLabel sizeToFit];
        alertTextLabel.frame = CGRectMake(0, backgroundView.frame.size.height - 40, backgroundView.frame.size.width, 16);
        [backgroundView  addSubview:alertTextLabel];
        
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.center = CGPointMake(backgroundView.frame.size.width /2.f, backgroundView.frame.size.height/2.f - 15);
        [backgroundView addSubview:activity];
        _superView = [superView retain];
        
    }
    return self;
}

- (void)show
{
    [_superView addSubview:self];
    [activity startAnimating];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (self.superview)
        [self removeFromSuperview];
}
#else
- (id) initWithImage:(UIImage *)backgroundImage text:(NSString *)text withView:(UIView *)superView
{
    
    if (self = [super init]) {
        
        backgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        backgroundView.image = backgroundImage;
        self.backgroundImage = backgroundImage;
        
		alertTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		alertTextLabel.textColor = [UIColor whiteColor];
		alertTextLabel.backgroundColor = [UIColor clearColor];
		alertTextLabel.font = [UIFont boldSystemFontOfSize:16.f];
        alertTextLabel.textAlignment = UITextAlignmentCenter;
        self.alertText = text;
        
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return self;
}
- (void) layoutSubviews {
    
    UIImageView * imageView = nil;
    for (UIView * ob in self.subviews) {
        if ([ob isKindOfClass:[UIImageView class]]) {
            imageView = (UIImageView *)ob;
            [imageView setImage:self.backgroundImage];
            imageView.frame = CGRectMake(0, 0, self.backgroundImage.size.width/2.f, self.backgroundImage.size.height/2.f);
            imageView.center = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
        }else{
            [ob removeFromSuperview];
        }
    }
    [imageView addSubview:activity];
    activity.center = CGPointMake(imageView.frame.size.width/2.f, imageView.frame.size.height/ 2.f);
    [imageView addSubview:alertTextLabel];
    alertTextLabel.frame = CGRectMake(0, imageView.frame.size.height - 30, imageView.frame.size.width, 25);
    
}
- (void) show {
    
	[super show];
    [activity startAnimating];
}

- (void)dealloc {
    
    [backgroundView release];
    [alertTextLabel release];
    [activity release];
    [super dealloc];
}
#endif
@end
