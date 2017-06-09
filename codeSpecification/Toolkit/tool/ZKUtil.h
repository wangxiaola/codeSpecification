//
//  ZKUtil.h
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/9.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKUtil : NSObject

/**
 保存bool值

 @param key key
 @param value value
 */
+ (void)saveBoolForKey:(NSString *)key valueBool:(BOOL)value;

/**
 获取bool值

 @param key key
 @return value
 */
+ (BOOL)obtainBoolForKey:(NSString *)key;

/**
 跳转到浏览器

 @param url 地址
 */
+ (void)openSafarlUrl:(NSString *)url;

@end
