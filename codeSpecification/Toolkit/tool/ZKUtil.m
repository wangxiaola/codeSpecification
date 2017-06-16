//
//  ZKUtil.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/9.
//  Copyright © 2017年 王小腊. All rights reserved.
//


/**
 *  沙盒Cache路径
 */
#define kCachePath ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject])
#import "ZKUtil.h"

@implementation ZKUtil
#pragma mark  ----保存&&获取 状态----

+ (void)cacheUserValue:(id )value key:(NSString *)key;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}
+ (id )getUserDataForKey:(NSString *)key;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id data = [defaults objectForKey:key];
    return data;
}

+ (void)cacheForData:(NSData *)data fileName:(NSString *)fileName
{
    NSString *path = [kCachePath stringByAppendingPathComponent:fileName];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data writeToFile:path atomically:YES];
    });
}

+ (NSData *)getCacheFileName:(NSString *)fileName
{
    NSString *path = [kCachePath stringByAppendingPathComponent:fileName];
    return [[NSData alloc] initWithContentsOfFile:path];
}


+ (void)saveBoolForKey:(NSString *)key valueBool:(BOOL)value;
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)obtainBoolForKey:(NSString *)key;
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}
+ (void)openSafarlUrl:(NSString *)url;
{
    if ([url isKindOfClass:[NSString class]]&&url.length >0)
    {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    }
}
+ (NSString*)jsonStringToJson:(id)dic;
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
