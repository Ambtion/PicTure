//
//  SCPTask.h
//  SohuCloudPics
//
//  Created by mysohu on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"


typedef enum {
    TaskStatusBeforeUpload = 0,
    TaskStatusIsUploading = 1,
    TaskStatusFinishUpload = 2,
    TaskStatusFailedUpload = 3,
    TaskStatusNotUploadPhoto = 4,
} TaskStatus;

@interface SCPTask : NSObject

// 该任务的键
@property (assign, nonatomic) int key;

//
@property (strong, nonatomic) ASIHTTPRequest *request;

// 要上传的图片的路径
@property (strong, nonatomic) NSString *filePath;

// 要上传的图片的文字描述
@property (strong, nonatomic) NSString *description;

//任务状态
@property (assign, nonatomic) int uploadState;

@end
