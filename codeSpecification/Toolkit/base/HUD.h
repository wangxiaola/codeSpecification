//
//  HUD.h
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/8.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface HUD : NSObject

/**
 提示信息

 @param messenger 信息
 @param view view
 */
+ (void)showMessenger:(NSString *)messenger fromView:(NSView*)view dismiss:(void(^)())end;


#pragma mark  ----以下配合使用----
/**
 提示框

 @param status 信息
 @param view view
 */
+ (void)showStatus:(NSString *)status fromView:(NSView*)view;

/**
 消失
 */
+ (void)dismiss;

@end
