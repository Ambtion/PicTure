//
//  SCPPhoto.m
//  SohuCloudPics
//
//  Created by Yingxue Peng on 12-9-25.
//  Copyright (c) 2012年 Sohu.com. All rights reserved.
//

#import "SCPPhoto.h"

@implementation SCPPhoto

@synthesize photoID = _photoID;
@synthesize filePath = _filePath;
@synthesize photoUrl = _photoUrl;

- (void)dealloc
{
	self.photoID = nil;
	self.filePath = nil;
	self.photoUrl = nil;
	[super dealloc];
}

@end
