//
//  ZKFileProcessingMode.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKFileProcessingMode.h"
#import "ZKRowsEngine.h"

@interface ZKFileProcessingMode()
{
    //将代理对象是否能响应相关协议方法缓存在结构体中
    struct {
    
        unsigned int startAnalyze                :1;
        unsigned int stopAnalyze                 :1;
        unsigned int fileAnalysisAbnormal        :1;
        unsigned int analysisOfDailyReturns      :1;
        unsigned int analysisResultsReturns      :1;
        unsigned int errorDescriptionReturn      :1;
    
    }_delegateFlags;
}

@property (nonatomic) CompileLanguageType languageType;

/** 文件路径数据源*/
@property (nonatomic, strong) NSMutableArray <NSString *> *dataSource;

@property (nonatomic, strong) NSArray <NSURL *>*filePathList;

@end
@implementation ZKFileProcessingMode
#pragma mark  ----懒加载----
- (NSMutableArray <NSString *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma mark  ----delegate----
/**
 记录代理协议状态

 @param delegate 代理
 */
- (void)setDelegate:(id<ZKFileProcessingModeDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateFlags.startAnalyze           = [delegate respondsToSelector:@selector(startAnalyzeData:)];
    _delegateFlags.stopAnalyze            = [delegate respondsToSelector:@selector(stopAnalyzeData:)];
    _delegateFlags.fileAnalysisAbnormal   = [delegate respondsToSelector:@selector(fileAnalysisAbnormalErrorMessage:)];
    _delegateFlags.analysisOfDailyReturns = [delegate respondsToSelector:@selector(analysisOfDailyReturnsData:)];
    _delegateFlags.analysisResultsReturns = [delegate respondsToSelector:@selector(analysisOfDailyReturnsData:)];
    _delegateFlags.errorDescriptionReturn = [delegate respondsToSelector:@selector(errorDescriptionReturnData:)];
    
}
#pragma mark  ----文件处理区域----
/**
 用户点击浏览文件
 
 @param languageType 语言类型
 */
- (void)browseClickcompileLanguageType:(CompileLanguageType)languageType;
{

    self.languageType = languageType;
    
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    // 设置默认打开路径
    panel.directoryURL = [NSURL URLWithString:NSHomeDirectory()];
    //是否可以选择目录
    panel.canChooseDirectories = YES;
    //是否允许多选
    panel.allowsMultipleSelection = YES;
    //允许选择的文件类型
    panel.allowedFileTypes = nil;
    ZKWeakSelf
    [panel beginWithCompletionHandler:^(NSInteger result)
     {
         // 点击了Open按钮
         if (result == NSModalResponseOK)
         {
            weakSelf.filePathList = panel.URLs;
         }
     }];
}
#pragma mark --分析文件--
/**
 开始分析文件
 */
- (void)startAnalyze;
{
    if (self.filePathList.count == 0)
    {
        [self addErrorMessage:@"没有找到要分析的文件，请选择文件。"];
        
        return;
    }
    // 开始检测
    [self addAnalyzeIsStart:YES];

    ZKWeakSelf
    [[ZKRowsEngine rowsEngine] computeWithFilePath:self.filePathList completion:^(NSArray<NSString *> *fileArrray) {
        
        [weakSelf filePathArrayGrouping:fileArrray];
        
    } error:^(NSString *errorInfo) {}];
}

/**
 分析文件分组判断

 @param fileArrray 文件路径数组
 */
- (void)filePathArrayGrouping:(NSArray <NSString *> *)fileArrray;
{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        switch (self.languageType)
        {
            case CompileLanguageTypeObjective:
                [self objectiveDetectionData:fileArrray];
                break;
            case CompileLanguageTypeSwift:
                [self swiftDetectionData:fileArrray];
                break;
            case CompileLanguageTypeJava:
                [self javaDetectionData:fileArrray];
                break;
                
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self addAnalyzeIsStart:NO];
            
        });
        
    });
    

}
#pragma mark  ----根据语言类型来判断代码规范----
/**** Objective *****/
- (void)objectiveDetectionData:(NSArray <NSString *> *)fileArrray;
{
    [fileArrray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
        //获取文件信息
        NSString *content = [NSString stringWithContentsOfFile:obj encoding:NSUTF8StringEncoding error:nil];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[content componentsSeparatedByString:@"\n"]];
        // 清除空行
        [array removeObjectsInArray:@[@"",@"    "]];
         
         NSLog(@"%@",array);

    }];

}
/**** Swift *****/
- (void)swiftDetectionData:(NSArray <NSString *> *)fileArrray;
{
    [self addErrorMessage:@"Swift语言暂未开放,请敬请期待！"];
}
/**** Java *****/
- (void)javaDetectionData:(NSArray <NSString *> *)fileArrray;
{
    [self addErrorMessage:@"Java语言暂未开放,请敬请期待！"];
}
#pragma mark  ----数据添加方法----

/**
 是否开始  或者结束

 @param statrt yes开始 no结束
 */
- (void)addAnalyzeIsStart:(BOOL)statrt
{
 
    ZKAnalysisLogMode *mode = [[ZKAnalysisLogMode alloc] init];
    if (statrt == YES)
    {
        if (_delegateFlags.startAnalyze)
        {
            mode.modifyTime = @"正在检测需要分析的文件。。。";
            mode.classSuffix = @"";
            
            [self.delegate startAnalyzeData:mode];
        }
    }
    else
    {
    
        if (_delegateFlags.stopAnalyze)
        {
            mode.modifyTime = @"***************分析完成***************";
            mode.classSuffix = @"";
            
            [self.delegate stopAnalyzeData:mode];
        }
    }
}

/**
 发送错误消息

 @param message 消息
 */
- (void)addErrorMessage:(NSString *)message
{
    if (_delegateFlags.fileAnalysisAbnormal&&message.length>0)
    {
        [self.delegate fileAnalysisAbnormalErrorMessage:message];
    }
}
/**
 分析日志添加

 @param modifyTime 修改时间
 @param classSuffix 类后缀名
 */
- (void)addAnalysisLogDataModifyTime:(NSString *)modifyTime
                         classSuffix:(NSString *)classSuffix;
{
    if (_delegateFlags.analysisOfDailyReturns)
    {
        ZKAnalysisLogMode *mode = [[ZKAnalysisLogMode alloc] init];
        mode.modifyTime  = modifyTime;
        mode.classSuffix = classSuffix;
        
        [self.delegate analysisOfDailyReturnsData:mode];
    }
}

/**
 分析结果添加

 @param filePath 文件路径
 @param className 类名
 @param codeNumber 有效代码行数
 @param noteNumber 有效注释行数
 @param annotationProportion 注释占比
 @param codeQuality 代码质量
 @param errorCodeNumber 不规范代码数量
 */
- (void)addResultsAnalysisDataFilePath:(NSString *)filePath
                             className:(NSString *)className
                            codeNumber:(NSString *)codeNumber
                            noteNumber:(NSInteger)noteNumber
                  annotationProportion:(CGFloat)annotationProportion
                           codeQuality:(NSString *)codeQuality
                       errorCodeNumber:(NSInteger)errorCodeNumber
{
    if (_delegateFlags.analysisResultsReturns)
    {
        
        ZKCodeResults *mode = [[ZKCodeResults alloc] init];
        mode.filePath              = filePath;
        mode.className             = className;
        mode.codeNumber            = codeNumber;
        mode.noteNumber            = noteNumber;
        mode.annotationProportion  = annotationProportion;
        mode.codeQuality           = codeQuality;
        mode.errorCodeNumber       = errorCodeNumber;
        
        [self.delegate analysisResultsReturnsData:mode];
    }
}

/**
 错误描述添加

 @param whichLine 第几行代码
 @param className 文件类名
 @param errorDescription 错误描述
 */
- (void)addErrorInformationDataWhichLine:(NSInteger)whichLine
                               className:(NSString *)className
                        errorDescription:(NSString *)errorDescription
{
    if (_delegateFlags.errorDescriptionReturn)
    {
        ZKErrorCodeInformation *mode = [[ZKErrorCodeInformation alloc] init];
        mode.whichLine        = whichLine;
        mode.className        = className;
        mode.errorDescription = errorDescription;
        
        [self.delegate errorDescriptionReturnData:mode];
    }
}
@end
