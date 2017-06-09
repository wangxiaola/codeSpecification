//
//  ZKUtil.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/9.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKUtil.h"

@implementation ZKUtil
#pragma mark  ----保存&&获取 状态----
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
@end
