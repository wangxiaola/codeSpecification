//
//  ZKFileMode.h
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKCodeResults.h"

@interface ZKFileMode : NSObject

/** 文件路径*/
@property (nonatomic ,copy  ) NSString   *filePath;
/** 文件数量*/
@property (nonatomic ,assign) NSUInteger fileNumber;
/** 代码行数*/
@property (nonatomic ,assign) NSUInteger codeRows;
/** 是否已经计算完成*/
@property (nonatomic ,assign) BOOL       countFinished;

/**
 类监测结果属性
 */
@property (nonatomic, strong) NSMutableArray <ZKCodeResults *>*results;

@end
