//
//  ZKResultsAnalysis.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/16.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKResultsAnalysis.h"

@implementation ZKResultsAnalysis

- (NSMutableArray *)dataArray
{
    if (!_dataArray.count)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
