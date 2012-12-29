//
//  SCPTaskUnit.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-11.
//
//

#import "SCPTaskUnit.h"

@implementation SCPTaskUnit


@synthesize asseetUrl = _asseetUrl;
@synthesize description = _description;
@synthesize taskState = _taskState;
@synthesize thumbnail = _thumbnail;
//@synthesize keyValue = _keyValue;
@synthesize request = _request;
@synthesize data = _data;

- (void)dealloc
{
    self.asseetUrl = nil;
    self.thumbnail = nil;
    self.description = nil;
    self.request = nil;
    self.data = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.taskState = UPLoadstatusWait;
    }
    return self;
}
- (NSURL *)asseetUrl
{
    NSLog(@"%s : AssetURL is Write property",__FUNCTION__);
    return nil;
}

- (void)getImageSucess:(void (^)(NSData * imageData,SCPTaskUnit * unit))resultBlock failture:(void(^)(NSError * error,SCPTaskUnit * unit))myfailtureBlock;
{
    if (self.data) {
        resultBlock(self.data,self);
        return;
    }
    ALAssetsLibrary * lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:_asseetUrl resultBlock:^(ALAsset *asset) {
        CGImageRef  cgimage =[[asset defaultRepresentation] fullResolutionImage];
        UIImage * image = [UIImage imageWithCGImage:cgimage];
        NSNumber * num = [[NSUserDefaults standardUserDefaults] objectForKey:@"JPEG"];
        NSData * data = nil;
        if (!num || ![num boolValue]) {
            //PNG
            data = UIImagePNGRepresentation(image);
        }else{
            //JPEG
           data = UIImageJPEGRepresentation(image, 0.7f);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(data,self);
            [lib release];
        });
    } failureBlock:^(NSError *error) {
        myfailtureBlock(error,self);
        [lib release];
    }];
}
@end
