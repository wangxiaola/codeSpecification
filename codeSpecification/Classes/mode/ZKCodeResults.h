//
//  ZKCodeResults.h
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKCodeResults : NSObject

/**文件路径**/
@property (nonatomic, copy) NSString     *filePath;
/**类名**/
@property (nonatomic, copy) NSString     *className;
/**有效代码行数**/
@property (nonatomic, assign) CGFloat    codeNumber;
/**有效注释行数**/
@property (nonatomic, assign) CGFloat    noteNumber;
/**注释占比**/
@property (nonatomic, assign) CGFloat    annotationProportion;
/**代码质量**/
@property (nonatomic, copy) NSString     *codeQuality;
/**不规范代码数量**/
@property (nonatomic, assign) CGFloat    errorCodeNumber;
@end
