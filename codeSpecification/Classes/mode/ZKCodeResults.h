//
//  ZKCodeResults.h
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKErrorCodeInformation.h"
@interface ZKCodeResults : NSObject

/**修改时间**/
@property (nonatomic, copy) NSString  *modifyTime;
/**类后缀名**/
@property (nonatomic, copy) NSString  *classSuffix;
/**类名**/
@property (nonatomic, copy) NSString  *className;
/**代码行数**/
@property (nonatomic, copy) NSString  *codeNumber;
/**有效注释行数**/
@property (nonatomic, copy) NSString  *noteNumber;
/**注释占比**/
@property (nonatomic, assign) CGFloat *annotationProportion;
/**代码质量**/
@property (nonatomic, copy) NSString  *codeQuality;
/**不规范代码**/
@property (nonatomic, copy) NSArray   <ZKErrorCodeInformation *>*errorCode;



@end
