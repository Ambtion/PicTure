//
//  SCPTaskList.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPTaskList.h"

@implementation SCPTaskList

@synthesize taskList = _taskList;
@synthesize key = _key;
@synthesize albumId = _albumId;
@synthesize isFinished = _isFinished;

- (id)init
{
    self = [super init];
    if (self) {
        _taskList = [[NSMutableArray alloc] init];
        _isFinished = FALSE;
    }
    return self;
}

- (void)dealloc
{
    [_taskList release];
	self.albumId = nil;
    
    [super dealloc];
}

@end
