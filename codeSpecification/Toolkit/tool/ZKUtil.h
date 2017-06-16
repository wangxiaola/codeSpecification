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
 保存在NSUserDefaults
 
 @param value 值
 @param key 键
 */
+ (void)cacheUserValue:(id )value key:(NSString *)key;

/**
 取出NSUserDefaults的值
 
 @param key 键
 @return 值
 */
+ (id )getUserDataForKey:(NSString *)key;

/**
 *  缓存数据
 *
 *  @param fileName 缓存数据的文件名
 *
 *  @param data 需要缓存的二进制
 */
+ (void)cacheForData:(NSData *)data fileName:(NSString *)fileName;

/**
 *  取出缓存数据
 *
 *  @param fileName 缓存数据的文件名
 *
 *  @return 缓存的二进制数据
 */
+ (NSData *)getCacheFileName:(NSString *)fileName;

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

/**
 字典转json格式字符串：

 @param dic 数据
 @return 字符
 */
+ (NSString*)jsonStringToJson:(id)dic;

@end
