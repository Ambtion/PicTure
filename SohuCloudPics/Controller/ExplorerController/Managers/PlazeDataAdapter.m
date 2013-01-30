//
//  PlazeDataAdapter.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-29.
//
//

#import "PlazeDataAdapter.h"
#import "PlazeViewCell.h"

#define PICTURESIZE 205
@implementation NSMutableArray (AddWithType_and_Random)

- (void)addRect:(CGRect)rect
{
    [self addObject:[NSValue valueWithCGRect:rect]];
}

@end

static CGFloat strategy1(NSMutableArray *frames, NSMutableArray *figures)
{
    [frames addRect:CGRectMake(5, 0, 205, 200)];
    
    [frames addRect:CGRectMake(215, 0, 100, 100)];
    
    [frames addRect:CGRectMake(5, 205, 205, 100)];
    
    [frames addRect:CGRectMake(215, 105, 100, 200)];
    
    return 310;
}

static CGFloat strategy2(NSMutableArray *frames, NSMutableArray *figures)
{
    [frames addRect:CGRectMake(5, 0, 100, 100)];
    
    [frames addRect:CGRectMake(5, 105, 100, 100)];
    
    [frames addRect:CGRectMake(110, 0, 205, 205)];
    
    return 210;
}

static CGFloat strategy3(NSMutableArray *frames, NSMutableArray *figures)
{
    [frames addRect:CGRectMake(5, 0, 205, 205)];
    
    [frames addRect:CGRectMake(215, 0, 100, 100)];
    
    [frames addRect:CGRectMake(215, 105, 100, 100)];
    
    return 210;
}

static CGFloat strategy4(NSMutableArray *frames, NSMutableArray *figures)
{
    [frames addRect:CGRectMake(5, 0, 100, 205)];
    
    [frames addRect:CGRectMake(110, 0, 205, 205)];
    
    return 210;
}

static CGFloat strategy5(NSMutableArray *frames, NSMutableArray *figures)
{
    [frames addRect:CGRectMake(5, 0, 100, 100)];
    
    [frames addRect:CGRectMake(110, 0, 205, 100)];
    
    return 105;
}

static CGFloat strategy6(NSMutableArray *frames, NSMutableArray *figures)
{
    [frames addRect:CGRectMake(5, 0, 100, 100)];
    
    [frames addRect:CGRectMake(110, 0, 100, 100)];
    
    [frames addRect:CGRectMake(215, 0, 100, 100)];
    
    return 105;
    
}

static CGFloat strategy7(NSMutableArray *frames, NSMutableArray *figures)
{
    [frames addRect:CGRectMake(5, 0, 205, 105)];
    
    [frames addRect:CGRectMake(215, 0, 100, 105)];
    
    return 110;
}

static CGFloat (*strategys[])(NSMutableArray *, NSMutableArray *) = {
    strategy1, strategy2, strategy3, strategy4,
    strategy5, strategy6, strategy7
};
static NSInteger lastNum = -1;
@implementation PlazeDataAdapter

+ (NSInteger)randomNum
{
    int i;
    while ((i = (random() >> 16) % 6) == lastNum) {
        // empty
    }
    lastNum = i;
    return lastNum;
}
+ (NSDictionary *)getViewFrameForRandom
{
    NSInteger num_strategy = [self randomNum];
    NSMutableArray * frames = [[[NSMutableArray alloc] init] autorelease];
    CGFloat height = strategys[num_strategy](frames,nil);
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithFloat:height],@"height",frames,@"viewFrame",[NSNumber numberWithInt:num_strategy],@"strategy_num",nil];
    return dic;
}
+ (NSArray *)getURLArrayByImageFrames:(NSArray *)frames FrominfoSource:(NSArray *)infoSource

{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < frames.count; i++) {
        NSDictionary * dic = [infoSource objectAtIndex:i];
        [array addObject:dic];
    }
    return array;
}
//+ (NSUInteger)offsetOfDataSouceWithstrategy:(NSArray *)strategyArray
//{
//    
//    if (!strategyArray.count)  return 0;
//    long long i = 0;
//    for (PlazeViewCellDataSource * data in strategyArray) {
//        i = i + data.viewRectFrame.count;
//    }
//    return i;
//}
+ (NSArray *)getBorderViewOfImageViewByImageViewFrame:(NSArray *) viewFrame
{
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < viewFrame.count; i++) {
        CGRect superRect = [[viewFrame objectAtIndex:i] CGRectValue];
        
        CGFloat heigth = PICTURESIZE;
        CGFloat wigth = PICTURESIZE;
        if (!heigth || !wigth) {
            [array addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, superRect.size.width, superRect.size.height)]];
            break;
        }
        CGFloat scale = MIN(heigth/superRect.size.height, wigth/superRect.size.width);
        CGRect frame = CGRectMake(0, 0, wigth/scale, heigth/scale);
        frame.origin.x = (superRect.size.width - frame.size.width)/2.f;
        frame.origin.y = (superRect.size.height - frame.size.height)/2.f;
        [array addObject:[NSValue valueWithCGRect:frame]];
        
    }
    return array;
}
@end
