//
//  ZKErrorCodeInformation.h
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKErrorCodeInformation : NSObject

/**第几行代码**/
@property (nonatomic, assign) NSInteger whichLine;

/**文件类名**/
@property (nonatomic, copy)   NSString  *className;

/**错误描述**/
@property (nonatomic, copy)   NSString  *errorDescription;
@end
