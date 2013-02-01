//
//  SCPPerfrencdStoreManager.h
//  SohuCloudPics
//
//  Created by sohu on 13-2-1.
//
//

#import <Foundation/Foundation.h>

@interface SCPPerfrenceStoreManager : NSObject

+ (NSString *)homeBackGroundImageName;
+ (void)resetHomeBackGroudImageName:(NSString *)newName;

+ (NSNumber *)isUploadJPEGImage;
+ (void)setIsUploadJPEGImage:(BOOL)ture;

+ (NSNumber *)isShowingGridView;
+ (void)setIsShowingGridView:(BOOL)ture;

@end
