//
//  SCPFilterLib.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-8.
//
//

#import "Filterlibrary.h"

@implementation Filterlibrary

+ (void)storeCachedOAuthData:(UIImage *)image forName:(NSInteger)number
{
    NSString * str = [NSString stringWithFormat:@"image_%d",number];
    NSUserDefaults * defults = [NSUserDefaults standardUserDefaults];
    NSData * data = UIImagePNGRepresentation(image);
    [defults setObject:data forKey:str];
    [defults synchronize];
    
}
+ (UIImage *)cachedDataForName:(NSInteger)number
{
    NSString * str = [NSString stringWithFormat:@"image_%d",number];
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defults objectForKey:str];
    return [UIImage imageWithData:data];
}
+ (void)storeCachedOAuthArrayData:(NSArray *)image_array forName:(NSInteger)number
{
//    NSLog(@"storeCachedOAuthArrayData");
    NSString * str = [NSString stringWithFormat:@"image_array_%d",number];
    NSUserDefaults * defults = [NSUserDefaults standardUserDefaults];
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    for (int i = 1; i <= image_array.count; i++) {
        NSData * data = UIImagePNGRepresentation([image_array objectAtIndex:i-1]);
        [tempArray addObject:data];
        if (i % 100 == 0) {
            [pool drain];
            pool = [[NSAutoreleasePool alloc] init];
        }
    }
    [pool drain];
//    NSLog(@"storeCachedOAuthArrayData %d",tempArray.count);
    [defults setObject:tempArray forKey:str];
    [defults synchronize];
    
}
+ (NSArray *)cachedArrayDataForName:(NSInteger)number
{
    
    NSString * str = [NSString stringWithFormat:@"image_array_%d",number];
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    NSArray *dataArray = [defults objectForKey:str];
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    for (int i = 1; i <= dataArray.count; i++) {
        UIImage * image = [UIImage imageWithData:[dataArray objectAtIndex:i-1]];
        [tempArray addObject:image];
        if (i % 100 == 0) {
            [pool drain];
            pool = [[NSAutoreleasePool alloc] init];
        }
        
    }
    [pool drain];
    if (tempArray.count == 0) {
        return nil;
    }
//    NSLog(@"cachedArrayDataForName %d",tempArray.count);
    return tempArray;
}
+ (void)removeCachedAllImageData
{
    NSLog(@"%s",__FUNCTION__);
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    for (int i = 0; i < 10; i++) {
        NSString * str = [NSString stringWithFormat:@"image_%d",i];
        [defults removeObjectForKey:str];
        str = [NSString stringWithFormat:@"image_array_%d",i];
        [defults removeObjectForKey:str];
    }
    [defults synchronize];

}

@end

