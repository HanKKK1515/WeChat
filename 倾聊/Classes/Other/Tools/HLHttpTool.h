//
//  HLHttpTool.h
//  02-文件上传下载工具抽取
//
//  Created by Vincent_Guo on 14-6-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HLHttpToolProgressBlock)(CGFloat progress);
typedef void (^HLHttpToolCompletionBlock)(NSError *error);

@interface HLHttpTool : NSObject

- (void)uploadData:(NSData *)data
              url:(NSURL *)url
    progressBlock : (HLHttpToolProgressBlock)progressBlock
            completion:(HLHttpToolCompletionBlock) completionBlock;

- (void)downLoadFromURL:(NSURL *)url
        progressBlock : (HLHttpToolProgressBlock)progressBlock
            completion:(HLHttpToolCompletionBlock) completionBlock;

- (NSString *)fileSavePath:(NSString *)fileName;

@end
