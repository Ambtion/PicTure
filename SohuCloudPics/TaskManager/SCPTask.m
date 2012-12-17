//
//  SCPTask.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPTask.h"

@implementation SCPTask

@synthesize request = _request;
@synthesize key = _key;
@synthesize filePath = _filePath;
@synthesize description = _description;
@synthesize uploadState = _uploadState;

- (id)init
{
    self = [super init];
    if (self) {
        self.uploadState = TaskStatusBeforeUpload;
    }
    return self;
}

- (void)dealloc
{
    self.request = nil;
    self.filePath = nil;
    self.description = nil;
    [super dealloc];
}

@end
