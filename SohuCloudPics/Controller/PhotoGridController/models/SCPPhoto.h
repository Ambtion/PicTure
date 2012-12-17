//
//  SCPPhoto.h
//  SohuCloudPics
//
//  Created by Yingxue Peng on 12-9-25.
//  Copyright (c) 2012年 Sohu.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SCPPhoto : NSObject

@property (strong, nonatomic) NSString *photoID;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSString *photoUrl;

@end
