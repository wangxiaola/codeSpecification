//
//  ZKFileProcessingMode.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKFileProcessingMode.h"
#import "ZKFileMode.h"

@implementation ZKFileProcessingMode

/**
 用户选择的文件路径数组
 
 @param filePathList 文件路径数组
 */
- (void)dragDropFilePathList:(NSArray<NSString *> *)filePathList;
{

    for (NSString *filePath in filePathList)
    {
        
        ZKFileMode *model = [ZKFileMode new];
        model.filePath = filePath;
        
//        [self.dataSource addObject:model];
    }



}
@end
