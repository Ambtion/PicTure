//
//  SCPFilterLib.h
//  SohuCloudPics
//
//  Created by sohu on 12-10-8.
//
//

#import <Foundation/Foundation.h>

@interface Filterlibrary : NSObject
+ (void)storeCachedOAuthData:(UIImage *)image forName:(NSInteger)number;
+ (UIImage *)cachedDataForName:(NSInteger)number;
+ (void)removeCachedAllImageData;

+ (void)storeCachedOAuthArrayData:(NSArray *)image_array forName:(NSInteger)number;
+ (NSArray *)cachedArrayDataForName:(NSInteger)number;
@end
