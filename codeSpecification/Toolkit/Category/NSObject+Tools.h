//
//  NSObject+Tools.h
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/7.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Tools)

/**
 错误信息提示框

 @param name 名称
 @param message 内容
 @param buttonTitle 按钮名称
 */
+ (void)showErrorAlertTitle:(NSString *)name message:(NSString *)message buttonTitle:(NSString *)buttonTitle;

@end
