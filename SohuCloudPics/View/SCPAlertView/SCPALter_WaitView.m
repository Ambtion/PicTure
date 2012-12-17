//
//  SCPWatiAlterView.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-26.
//
//

#import "SCPAlter_WaitView.h"

@implementation SCPAlert_WaitView
@synthesize backgroundImage, alertText;

- (id)initWithImage:(UIImage *)image text:(NSString *)text {
    
    if (self = [super init]) {
        
        backgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        backgroundView.image = image;
        self.backgroundImage = image;

		alertTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		alertTextLabel.textColor = [UIColor whiteColor];
		alertTextLabel.backgroundColor = [UIColor clearColor];
		alertTextLabel.font = [UIFont boldSystemFontOfSize:16.f];
        self.alertText = text;
        
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return self;
}

- (void) setAlertText:(NSString *)text {
    
	alertTextLabel.text = text;
}

- (NSString *) alertText {
    
	return alertTextLabel.text;
}
//- (void)drawRect:(CGRect)rect {
//    
//    //CGContextRef ctx = UIGraphicsGetCurrentContext();
////	CGSize imageSize = self.backgroundImage.size;
////    imageSize.width /= 2.f;
////    imageSize.height /= 2.f;
////	[self.backgroundImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
//    
//}
 
- (void) layoutSubviews {
    
    backgroundView.frame = self.bounds;
	alertTextLabel.transform = CGAffineTransformIdentity;
    
    CGRect activityRect = activity.bounds;
    activityRect.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(activityRect)) / 2;
    //	activityRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(activityRect)) / 2;
    //	activityRect.origin.y -= 50;
    activityRect.origin.y = 32;
    activity.frame = activityRect;

	[alertTextLabel sizeToFit];
	CGRect textRect = alertTextLabel.frame;
	textRect.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(textRect)) / 2;
//	textRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(textRect)) / 2;
//	textRect.origin.y -= 30.0;
	
    textRect.origin.y = 90;
	alertTextLabel.frame = textRect;
//	alertTextLabel.transform = CGAffineTransformMakeRotation(- M_PI * .08);
    
        
}
- (void)showCustomizeView
{
    [self addSubview:backgroundView];
    [self addSubview:alertTextLabel];
    [self addSubview:activity];
    [self layoutSubviews];
}
- (void) show {
    
	[super show];
    for (id ob in self.subviews) {
        [ob removeFromSuperview];
    }
    CGSize imageSize = self.backgroundImage.size;
    self.bounds = CGRectMake(0, 0, imageSize.width/2, imageSize.height/2);
    self.backgroundColor = [UIColor clearColor];
    [self showCustomizeView];
    [activity startAnimating];
}


- (void)dealloc {
    
    [alertTextLabel release];
    [alertTextLabel release];
    [activity release];
    [super dealloc];
}



@end
