//
//  NSObject+Tools.h
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/7.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface NSObject (Tools)

/**
 开启一个提示窗口

 @param name 提示名称
 @param message 提示信息
 @param buttonTitle 按钮title
 */
+ (void)showErrorWindowAlertTitle:(NSString *)name message:(NSString *)message buttonTitle:(NSString *)buttonTitle;
/**
 提示信息框

 @param name 提示名称
 @param message 提示信息
 @param window window
 @param handler 电话回调
 */
+ (void)showPromptAlertTitle:(NSString *)name message:(NSString *)message forWindow:(NSWindow *)window completionHandler:(void (^)(NSModalResponse returnCode))handler;
/**
 错误信息框
 
 @param name 提示名称
 @param message 提示信息
 @param window window
 @param handler 电话回调
 */
+ (void)showErrorAlertTitle:(NSString *)name message:(NSString *)message forWindow:(NSWindow *)window completionHandler:(void (^)(NSModalResponse returnCode))handler;


@end
