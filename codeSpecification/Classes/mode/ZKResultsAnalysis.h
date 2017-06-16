//
//  ZKResultsAnalysis.h
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/16.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 分析结果保存
 */
@interface ZKResultsAnalysis : NSObject
// 有效代码行数
@property (nonatomic, assign) CGFloat  validLines;
// 有效注释行数
@property (nonatomic, assign) CGFloat  noteValidLines;
// 注释占比
@property (nonatomic, assign) CGFloat  proportion;
// 不规范代码数量
@property (nonatomic, assign) CGFloat  onStandard;
// 文件数量
@property (nonatomic, assign) CGFloat  fileNumber;
// 提交代码IP
@property (nonatomic, strong) NSString *commitIp;
// 提交代码人
@property (nonatomic, strong) NSString *commitName;
// 代码质量
@property (nonatomic, strong) NSString *quality;

@property (nonatomic, strong) NSMutableArray *dataArray;


@end
