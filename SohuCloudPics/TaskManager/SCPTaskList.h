//
//  SCPTaskList.h
//  SohuCloudPics
//
//  Created by mysohu on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCPTaskList : NSObject

// 关于SCPTask的数组
@property (strong, nonatomic) NSMutableArray *taskList;

// 该任务列表的键
@property (assign, nonatomic) int key;

// 该任务列表所要上传到的相册的id
@property (strong, nonatomic) NSString *albumId;

// 该任务列表是否已经完成
@property (assign, nonatomic) BOOL isFinished;

@end
