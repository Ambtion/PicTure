//
//  SCPAlbum.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPAlbum.h"

@implementation SCPAlbum

@synthesize isUploading = _isUploading;

@synthesize creatorId = _user_id;
@synthesize albumId = _albumId;
@synthesize coverShowId = _cover;
@synthesize coverURL = _coverURL;

@synthesize name = _title;
@synthesize permission = _permission;
@synthesize updatedAtDesc = _updatedAtDesc;
@synthesize photoNum = _count;
@synthesize viewCount = _visits;

- (void)dealloc
{
	self.creatorId = nil;
	self.coverShowId = nil;
	self.coverURL = nil;
	self.albumId = nil;
	self.name = nil;
	self.updatedAtDesc = nil;
	
    [super dealloc];
}

@end
