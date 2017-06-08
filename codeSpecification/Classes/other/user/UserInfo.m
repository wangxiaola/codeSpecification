//
//  UserInfo.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/8.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#define MDACCOUNT_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"UserInfo.data"]

#import "UserInfo.h"

@implementation UserInfo


+ (nonnull UserInfo *)account
{
    UserInfo *account = [NSKeyedUnarchiver unarchiveObjectWithFile:MDACCOUNT_PATH];
    return account ? : [[UserInfo alloc] init];
}

+ (void)saveAccount:(nullable UserInfo *)account
{
    [NSKeyedArchiver archiveRootObject:account ? : [[UserInfo alloc] init] toFile:MDACCOUNT_PATH];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userID": @"id"};
}


//类内部的两个属性变量分别转码
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.password forKey:@"password"];
}
//分别把两个属性变量根据关键字进行逆转码，最后返回一个Student类的对象
-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init])
    {
        self.name     = [aDecoder decodeObjectForKey:@"name"];
        self.ID       = [aDecoder decodeObjectForKey:@"ID"];
        self.account  = [aDecoder decodeObjectForKey:@"account"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
    }
    return self;
}

@end
