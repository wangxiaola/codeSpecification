//
//  ZKRowsEngine.h
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ZKRowsCompletion)(NSUInteger fileNumber, NSUInteger codeRows);
typedef void(^ZKRowsError)(NSString *errorInfo);

@interface ZKRowsEngine : NSObject

/**
 便利构造方法
 
 @return 返回一个PPRowsEngine的实例
 */
+ (instancetype)rowsEngine;

/**
 计算拖入/输入的文件夹内所有的代码文件以及代码行数
 
 @param filePath 文件路径
 @param completion 计算完成的回调
 @param error 文件不存在的错误回调 
 */
- (void)computeWithFilePath:(NSString *)filePath
                 completion:(ZKRowsCompletion)completion
                      error:(ZKRowsError)error;


@end
