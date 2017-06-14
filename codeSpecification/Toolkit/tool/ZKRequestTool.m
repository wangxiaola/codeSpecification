//
//  ZKRequestTool.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/7.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKRequestTool.h"
#import "AFNetworking.h"

@interface ZKRequestTool ()

@end
@implementation ZKRequestTool

#pragma mark -Getters-
+ (AFHTTPSessionManager *)sessionManager
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置接受的类型
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //设置请求超时
    sessionManager.requestSerializer.timeoutInterval = 5;
    return sessionManager;
}
#pragma mark -tool-
/**
 post请求
 
 @param requestUrl 请求的API地址
 @param params 参数
 @param success 成功回调Block
 @param failure 失败回调Block
 */
+ (void)post:(NSString *)requestUrl params:(NSMutableDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;
{
    AFHTTPSessionManager *sessionManager = [self sessionManager];
    NSLog(@"\n请求链接URL:%@ \n参数params:%@",requestUrl,params);
    
    [sessionManager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (success) {
            id response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSLog(@"\n结果打印: %@",response);
            success(response);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}
@end
