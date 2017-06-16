//
//  ZKErrorDescriptionViewController.h
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ZKErrorCodeInformation;
/**
 错误描述vc
 */
@interface ZKErrorDescriptionViewController : NSViewController

/**
 添加数据
 
 @param list 数据
 @param start 是否开始
 */
- (void)addTableViewData:(ZKErrorCodeInformation *)list isStart:(BOOL)start;

@end
