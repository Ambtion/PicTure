//
//  SCPHorizontalGestureRecognizer.m
//  SohuCloudPics
//
//  Created by Chen Chong on 12-10-26.
//
//

#import "SCPHorizontalGestureRecognizer.h"


#define TIME_THRESHOLD 1.2
#define DELTA_X_THRESHOLD 80


@implementation SCPHorizontalGestureRecognizer

@synthesize direction = _direction;

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
    return NO;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
    return YES;
}

- (void)reset
{
    [super reset];
    _totalDeltaX = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (touches.count != 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    self.state = UIGestureRecognizerStatePossible;
    _beginTime = CFAbsoluteTimeGetCurrent();
    _totalDeltaX = 0;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) {
        return;
    }
    if (self.state != UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    UITouch *touch = [touches anyObject];
    CGPoint nowPoint = [touch locationInView:self.view];
    CGPoint prevPoint = [touch previousLocationInView:self.view];
    CGFloat deltaX = nowPoint.x - prevPoint.x;
    CGFloat deltaY = nowPoint.y - prevPoint.y;
    CGFloat k = deltaY / deltaX;
    
    switch (self.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            if (currentTime - _beginTime >= TIME_THRESHOLD) {
                if (_totalDeltaX >= DELTA_X_THRESHOLD) {
                    self.state = UIGestureRecognizerStateRecognized;
                } else {
                    self.state = UIGestureRecognizerStateFailed;
                }
                return;
            }
            
            if (_totalDeltaX >= DELTA_X_THRESHOLD) {
                self.state = UIGestureRecognizerStateRecognized;
            }
            
            if (fabs(k) <= 1) {
                _totalDeltaX += deltaX;
                self.state = UIGestureRecognizerStatePossible;
            } else {
                self.state = UIGestureRecognizerStateFailed;
                return;
            }
            break;
            
        case UISwipeGestureRecognizerDirectionLeft:
            if (currentTime - _beginTime >= TIME_THRESHOLD) {
                if (_totalDeltaX <= -DELTA_X_THRESHOLD) {
                    self.state = UIGestureRecognizerStateRecognized;
                } else {
                    self.state = UIGestureRecognizerStateFailed;
                }
                return;
            }
            
            if (_totalDeltaX <= -DELTA_X_THRESHOLD) {
                self.state = UIGestureRecognizerStateRecognized;
            }
            
            if (fabs(k) <= 1) {
                _totalDeltaX += deltaX;
                self.state = UIGestureRecognizerStatePossible;
            } else {
                self.state = UIGestureRecognizerStateFailed;
                return;
            }
            break;
            
        default:
            self.state = UIGestureRecognizerStateFailed;
            break;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    switch (self.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            if (_totalDeltaX >= DELTA_X_THRESHOLD) {
                self.state = UIGestureRecognizerStateRecognized;
            } else {
                self.state = UIGestureRecognizerStateFailed;
            }
            break;
            
        case UISwipeGestureRecognizerDirectionLeft:
            if (_totalDeltaX <= -DELTA_X_THRESHOLD) {
                self.state = UIGestureRecognizerStateRecognized;
            } else {
                self.state = UIGestureRecognizerStateFailed;
            }
            break;
            
        default:
            self.state = UIGestureRecognizerStateFailed;
            break;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateFailed;
}

@end
