//
//  ZKFileProcessingMode.h
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKAnalysisLogMode.h"
#import "ZKCodeResults.h"
#import "ZKErrorCodeInformation.h"
#import "ZKResultsAnalysis.h"

@protocol ZKFileProcessingModeDelegate <NSObject>
@optional

/**
 开始分析
 
 @param mode 数据
 */
- (void)startAnalyzeData:(ZKAnalysisLogMode *)mode;

/**
 结束分析
 
 @param mode 数据
 */
- (void)stopAnalyzeData:(ZKAnalysisLogMode *)mode;

/**
 分析完所有文件结果回调

 @param mode 数据
 */
- (void)analysisResultsCallback:(ZKResultsAnalysis *)mode;

/**
 文件分析异常

 @param message 错误消息
 */
- (void)fileAnalysisAbnormalErrorMessage:(NSString *)message;

/**
 分析日志返回

 @param mode 数据
 */
- (void)analysisOfDailyReturnsData:(ZKAnalysisLogMode *)mode;

/**
 分析结果返回

 @param mode 数据
 */
- (void)analysisResultsReturnsData:(ZKCodeResults *)mode;

/**
 错误描述返回

 @param mode 数据
 */
- (void)errorDescriptionReturnData:(ZKErrorCodeInformation *)mode;

@end


/**
 文件编译语言类型

 - CompileLanguageTypeObjective: Objective-OC
 - CompileLanguageTypeSwift: swift
 - CompileLanguageTypeJava: Java
 */
typedef NS_ENUM(NSInteger, CompileLanguageType) {

    CompileLanguageTypeObjective = 0,
    CompileLanguageTypeSwift,
    CompileLanguageTypeJava
};

@interface ZKFileProcessingMode : NSObject


/**
 用户点击浏览文件


 */
- (void)browseClickcompile;

/**
 开始分析文件
 
 @param languageType 语言类型
 */
- (void)startAnalyzeLanguageType:(CompileLanguageType)languageType;
/**
 数据处理代理
 */
@property(nonatomic, weak) id <ZKFileProcessingModeDelegate> delegate;

@end
