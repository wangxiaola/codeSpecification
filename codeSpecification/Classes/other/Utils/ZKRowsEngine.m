//
//  ZKRowsEngine.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKRowsEngine.h"

@interface ZKRowsEngine ()

@property (nonatomic, copy) ZKRowsError       error;
/** 当前时间 **/
@property (nonatomic, strong) NSString        *currentTime;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSDateFormatter *timeFormatter;

@property (nonatomic, strong) NSMutableArray  *dataArray;

@end
@implementation ZKRowsEngine

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (instancetype)init
{
    if (self = [super init])
    {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyyMMdd"];
        
        self.timeFormatter = [[NSDateFormatter alloc] init];
        [self.timeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
    }
    return self;
}
+ (instancetype)rowsEngine
{
    return [[ZKRowsEngine alloc] init];
}

/**
 计算拖入/输入的文件夹内所有的代码文件以及代码行数
 
 @param filePath 文件路径数组
 @param completion 计算完成的回调
 @param error 文件不存在的错误回调
 */
- (void)computeWithFilePath:(NSArray <NSURL *>*)filePath
                 completion:(ZKRowsCompletion)completion
                      error:(ZKRowsError)error;
{
    _error = error;
    [self.dataArray removeAllObjects];
   // 每次获取最新时间
    self.currentTime = [[self.dateFormatter stringFromDate:[NSDate new]] lowercaseString];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [filePath enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *path = [obj path];
            [self computeFileInfoWithPath:path];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion ? completion(self.dataArray) : nil;
        });
        
    });
}

- (void)computeFileInfoWithPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 标记是否为文件夹
    BOOL isFolder = NO;
    // 标记文件路径是否存在
    BOOL isExist = [manager fileExistsAtPath:path isDirectory:&isFolder];
    
    if(!isExist) {
        // 当拖入或输入的文件路径不存在时才会回调错误信息
        NSString *err = [NSString stringWithFormat:@"%@:文件不存在",path];
        _error ? _error(err) : nil;
        return;
    }
    // 是否只分析当日修改
    BOOL isNewModifiedAnalysis  = [ZKUtil obtainBoolForKey:IsNewModifiedAnalysis];
    // 要监测的文件后缀类名的数组
    NSArray *fileTypes = [ZKUtil getUserDataForKey:ZKRowsCheckFileTypes];
    //  要忽略的文件名数组
    NSArray *ignoreFolders  = [ZKUtil getUserDataForKey:ZKRowsIgnoreFolders];
    
    // 1.文件夹
    if (isFolder)
    {
        NSArray *subFileArray = [manager contentsOfDirectoryAtPath:path error:nil];
        
        for (NSString *subFileName in subFileArray) {
            // 如果不是要过滤的文件夹
            if (![ignoreFolders containsObject:subFileName])
            {
                NSString *subFilePath = [NSString stringWithFormat:@"%@/%@", path,subFileName];
                [self computeFileInfoWithPath:subFilePath];
            }
        }
        
        // 2.文件
    } else {
        // 判断文件的拓展名
        NSString *extension = [[path pathExtension] lowercaseString];
        
        // 非处理文件过滤
        if (!fileTypes.count || ![fileTypes containsObject:extension])
        {
            return;
        }
        
        //获取文件信息
        NSDictionary *firstFileInfo = [manager attributesOfItemAtPath:path error:nil];
        //文件修改日期
        NSDate *modifyTimeData = [firstFileInfo objectForKey:NSFileModificationDate];
        // 获取一个文件修改时间字符串
        NSString *modifyTime = [self.timeFormatter stringFromDate:modifyTimeData];
        //获取一个文件修改时间的int值
        NSString *modifyTimeString = [[self.dateFormatter stringFromDate:modifyTimeData] lowercaseString];
        
        if (isNewModifiedAnalysis == YES)
        {
             // 当天修改的
            if (modifyTimeString.integerValue == self.currentTime.integerValue)
            {
                [self.dataArray addObject:@{@"path":path,@"time":modifyTime}];
            }
        }
            // 全部文件
        else
        {
            [self.dataArray addObject:@{@"path":path,@"time":modifyTime}];

        }
        
    }
    
}

@end
