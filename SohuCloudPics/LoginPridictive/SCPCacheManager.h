//
//  SCPCacheManager.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-16.
//
//

#import <Foundation/Foundation.h>
#import "SCPStoreLibaray.h"

@interface SCPCacheManager : NSObject

+ (void)removeCacheOfImage;
+ (void)removeCacheAlluserInfo:(BOOL)isRemove;
@end
