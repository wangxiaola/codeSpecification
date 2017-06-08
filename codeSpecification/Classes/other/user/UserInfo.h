//
//  UserInfo.h
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/8.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding>

@property (nonatomic, copy, nullable) NSString *account;
@property (nonatomic, copy, nullable) NSString *password;
@property (nonatomic, copy, nullable) NSString *ID;
@property (nonatomic, copy, nullable) NSString *name;

+ (nonnull UserInfo *)account;

+ (void)saveAccount:(nullable UserInfo *)account;

@end
