//
//  SCPAlbum.h
//  SohuCloudPics
//
//  Created by mysohu on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


@interface SCPAlbum : NSObject

@property (assign, nonatomic) BOOL isUploading;

@property (strong, nonatomic) NSString *creatorId; 
@property (strong, nonatomic) NSString *albumId;
@property (strong, nonatomic) NSString *coverShowId;
@property (strong, nonatomic) NSString *coverURL;

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger permission;
@property (strong, nonatomic) NSString *updatedAtDesc;
@property (assign, nonatomic) NSInteger photoNum;
@property (assign, nonatomic) NSInteger viewCount;

@end
