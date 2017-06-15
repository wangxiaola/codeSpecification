//
//  ZKFileProcessingMode.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/**
 代码验证类型
 
 - ValidationCodeTypeLeft:  验证左边
 - ValidationCodeTypeRight: 验证右边
 - ValidationCodeTypeAll:   两边都验证
 */
typedef NS_ENUM(NSInteger, ValidationCodeType) {
    
    ValidationCodeTypeLeft = 0,
    ValidationCodeTypeRight,
    ValidationCodeTypeAll
};
#import "ZKFileProcessingMode.h"
#import "ZKRowsEngine.h"
#import "ZKExceptionStatements.h"

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
@property (nonatomic, strong) NSArray <NSURL *>*filePathList;

@end
@implementation ZKFileProcessingMode
#pragma mark  ----懒加载----

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
 
 */
- (void)browseClickcompile;
{
    
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    // 设置默认打开路径
    //    panel.directoryURL = [NSURL URLWithString:NSHomeDirectory()];
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
- (void)startAnalyzeLanguageType:(CompileLanguageType)languageType;
{
    self.languageType = languageType;
    
    if (self.filePathList.count == 0)
    {
        [self addErrorMessage:@"没有找到要分析的文件，请选择文件。"];
        
        return;
    }
    // 开始检测
    [self addAnalyzeIsStart:YES];
    
    [[ZKRowsEngine rowsEngine] computeWithFilePath:self.filePathList completion:^(NSArray<NSDictionary *> *fileArrray) {
        [self filePathArrayGrouping:fileArrray];
    } error:nil];
    
}

/**
 分析文件分组判断
 
 @param fileArrray 文件路径数组
 */
- (void)filePathArrayGrouping:(NSArray <NSDictionary *> *)fileArrray;
{
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
}
#pragma mark  ----代码规范条件判断----

#pragma mark  ----根据语言类型来判断代码规范----
#pragma mark  --------

#pragma mark /**** Objective *****/
- (void)objectiveDetectionData:(NSArray <NSDictionary *> *)fileArrray;
{
    // 开始检查
    NSString *stateString = [NSString stringWithFormat:@"******检测完成 共%ld个类，开始分析******",fileArrray.count];
    [self addAnalysisLogDataModifyTime:stateString classSuffix:@""];
    //线程中遍历数据分发检测
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [fileArrray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self classHandleDictionary:obj];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (fileArrray.count == 0)
            {
                [self addErrorMessage:@"没有可检测的文件!"];
            }
            else
            {
                [self addAnalyzeIsStart:NO];
            }
        });
        
    });
    
}
/**
 类处理
 
 @param dictionary 类信息 path：路径  time:修改时间
 */
- (void)classHandleDictionary:(NSDictionary *)dictionary
{
    NSString *file = [dictionary valueForKey:@"path"];
    NSString *className = [file componentsSeparatedByString:@"/"].lastObject;
    NSString *time = [dictionary valueForKey:@"time"];
    
    [self addAnalysisLogDataModifyTime:[NSString stringWithFormat:@"修改时间：%@",time] classSuffix:[NSString stringWithFormat:@"开始分析文件：%@",className]];
    //获取文件信息
    NSString *content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    NSArray *contenArray = [content componentsSeparatedByString:@"\n"];
    
    __block NSInteger codeLines           = 0;//有效代码行数
    __block NSInteger commentLines        = 0;//有效注释行数
    __block NSInteger exceptionCodeNumber = 0;//异常代码数量
    
    [contenArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        http://www.cocoachina.com/ios/20160111/14926.html
        /*去掉左右两边的空格*/
        NSString *contenString = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (contenString.length > 0)
        {
            codeLines += 1;
            // 首字母判断 如果是函数类就是有效代码
            if ([self isFunctionCharacterString:contenString])
            {
                /*** - ****/
                if (![self isCodeSpaceString:contenString predicate:@"-" validationType:ValidationCodeTypeRight]) {
                    
                    [self addErrorInformationDataWhichLine:idx className:className errorDescription:@"'-' 右边要空格"];
                    exceptionCodeNumber += 1;
                }
                
            }
            else
            {
                //注释代码
                commentLines += 1;
            }
        }
        
    }];
}
#pragma mark  ----字符判断----
/**
 字符是否是函数字符
 
 @param key 字符
 @return yes
 */
- (BOOL)isFunctionCharacterString:(NSString *)key
{
    if (key.length == 0)
    {
        return  NO;
    }
    NSString *regex = @"[A-Za-z]+";
    NSPredicate*predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    NSString *first = [key substringToIndex:1];//字符串开始
    NSArray  *array =@[@"-", @"_" , @"+", @"#", @"@", @"{", @"}", @";", @"&", @"|"];
    //匹配字符串，反回结果， SELF＝＝表示数组中每一个元素
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF == %@", first];
    BOOL isSpecialCharacters = [array filteredArrayUsingPredicate:predicate1].count >0;
    if ([predicate evaluateWithObject:key] || isSpecialCharacters == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 代码是否空格
 
 @param str       要处理的字符串
 @param predicate 匹配字符串
 @param type 验证代码类型
 
 @return yes 规范
 */
- (BOOL)isCodeSpaceString:(NSString *)str predicate:(NSString *)predicate validationType:(ValidationCodeType)type;
{
    NSPredicate *rules = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",predicate];
    BOOL isContains = [rules evaluateWithObject:str];
    
    if (isContains == NO)
    {
        return YES;
    }
    NSInteger predicateLength = predicate.length;
    //现获取要截取的字符串位置
    NSRange range = [str rangeOfString:predicate];
    
    if (type == ValidationCodeTypeLeft)
    {
        NSRange  leftRange = NSMakeRange(range.location - predicateLength, 1);
        NSString * leftResult = [str substringWithRange:leftRange];
        
        return [leftResult isEqualToString:@" "];
    }
    else if (type == ValidationCodeTypeRight)
    {
        NSRange rightRange = NSMakeRange(range.location + predicateLength, 1);
        NSString * rightResult  = [str substringWithRange:rightRange];
        return [rightResult isEqualToString:@" "];
    }
    else if (type == ValidationCodeTypeAll)
    {   // 截取左边
        NSRange  leftRange = NSMakeRange(range.location - predicateLength, 1);
        NSString * leftResult = [str substringWithRange:leftRange];
        // 截取右边
        NSRange rightRange = NSMakeRange(range.location + predicateLength, 1);
        NSString * rightResult  = [str substringWithRange:rightRange];
        
        return ([leftResult isEqualToString:@" "],[rightResult isEqualToString:@" "]);
    }
    return YES;
}
#pragma mark /**** Swift *****/
- (void)swiftDetectionData:(NSArray <NSDictionary *> *)fileArrray;
{
    [self addErrorMessage:@"Swift语言暂未开放,请敬请期待！"];
}
#pragma mark /**** Java *****/
- (void)javaDetectionData:(NSArray <NSDictionary *> *)fileArrray;
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
            mode.classSuffix = @"正在检测需要分析的文件。。。";
            mode.modifyTime  = @"";
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.delegate startAnalyzeData:mode];
            }];
            
        }
    }
    else
    {
        if (_delegateFlags.stopAnalyze)
        {
            mode.modifyTime  = @"***************分析完成***************";
            mode.classSuffix = @"";
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.delegate stopAnalyzeData:mode];
            }];
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
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.delegate fileAnalysisAbnormalErrorMessage:message];
        }];
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
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.delegate analysisOfDailyReturnsData:mode];
        }];
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
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.delegate analysisResultsReturnsData:mode];
        }];
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
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.delegate errorDescriptionReturnData:mode];
        }];
    }
}
@end
