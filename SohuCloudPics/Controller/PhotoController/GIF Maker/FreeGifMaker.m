

#import "FreeGifMaker.h"

@implementation FreeGifMaker

- (id)init
{
    if ((self = [super init])) 
    {
        frame = nil;
        timeDelay = 0.5f;
        homeDirectory = [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
        fileName = @"Default.gif";
        loopCount = 0;
        count = 0;
    }
    return self;
}

- (void)dealloc
{
    [frame release];
    [super dealloc];
}

- (void)setFrameDelay:(CGFloat)delayTime
{
    timeDelay = delayTime;
}

- (void)setLoopCount:(NSInteger)loop
{
    loopCount = loop;
}

- (void)setGifFrame:(NSArray *)arrayFrame
{
    frame = [[NSMutableArray arrayWithArray:arrayFrame] retain];
}

- (void)setGifFrame:(NSArray *)arrayFrame delay:(CGFloat)Adelay
{
    frame = [[NSMutableArray arrayWithArray:arrayFrame] retain];
    timeDelay = Adelay;
}

- (void)setGifFileDirectory:(NSString *)directory
{
    homeDirectory = [NSString stringWithFormat:@"%@",directory];
}

- (void)setGifFileName:(NSString *)name
{
    fileName = [NSString stringWithFormat:@"%@",name];
}

- (NSData *)saveAnimatedGif
{
    
    NSMutableData * mydata = [[[NSMutableData alloc] initWithLength:0] autorelease];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef)mydata, kUTTypeGIF, [frame count], NULL);

    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:loopCount] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
                                                              forKey:(NSString *)kCGImagePropertyGIFDictionary];
    for (UIImage *obj in frame)
    {
        NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:timeDelay] forKey:(NSString *)kCGImagePropertyGIFDelayTime]
                                                                    forKey:(NSString *)kCGImagePropertyGIFDictionary];
        CGImageDestinationAddImage(destination, obj.CGImage, (CFDictionaryRef)frameProperties);
        count++;
    }
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)gifProperties);
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
    count = 0;
    return mydata;
}

@end
