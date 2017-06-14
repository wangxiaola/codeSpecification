//
//  ZKRowsEngine.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKRowsEngine.h"

@interface ZKRowsEngine ()

/** 拖入文件/文件夹的路径 **/
@property (nonatomic, copy) NSString          *superPath;

@property (nonatomic, copy) ZKRowsError       error;
/** 参与计算的代码文件数量 **/
@property (nonatomic, assign) NSUInteger      codeFileNumber;
/** 参与计算的代码行数 **/
@property (nonatomic, assign) NSUInteger      codeRows;

/** 当前时间 **/
@property (nonatomic, strong) NSString        *currentTime;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end
@implementation ZKRowsEngine

+ (instancetype)rowsEngine
{
    return [[ZKRowsEngine alloc] init];
}
- (void)computeWithFilePath:(NSString *)filePath
                 completion:(ZKRowsCompletion)completion
                      error:(ZKRowsError)error
{
    _error = error;
    _superPath = filePath;
    _codeFileNumber = 0;
    
    // 获取当天日期
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyyMMdd"];
    self.currentTime = [[self.dateFormatter stringFromDate:[NSDate new]] lowercaseString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        _codeRows = [self computeFileInfoWithPath:filePath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion ? completion(_codeFileNumber, _codeRows) : nil;
        });
        
    });
}

- (NSUInteger)computeFileInfoWithPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 标记是否为文件夹
    BOOL isFolder = NO;
    // 标记文件路径是否存在
    BOOL isExist = [manager fileExistsAtPath:path isDirectory:&isFolder];
    
    if(!isExist) {
        // 当拖入或输入的文件路径不存在时才会回调错误信息
        _error && [_superPath isEqualToString:path] ? _error(@"文件路径不存在!") : nil;
        return 0;
    }
    
    // 1.文件夹 <-> If folder
    if (isFolder) {
        NSUInteger codeRows = 0;
        NSArray *subFileArray = [manager contentsOfDirectoryAtPath:path error:nil];
        NSArray *ignoreFolders = [userDefaults objectForKey:ZKRowsIgnoreFolders];
        
        for (NSString *subFileName in subFileArray) {
            // 如果不是要过滤的文件夹
            if (![ignoreFolders containsObject:subFileName]) {
                NSString *subFilePath = [NSString stringWithFormat:@"%@/%@", path,subFileName];
                codeRows += [self computeFileInfoWithPath:subFilePath];
            }
        }
        
        return codeRows;
        
        // 2.文件
    } else {
        // 判断文件的拓展名
        NSString *extension = [[path pathExtension] lowercaseString];
        NSArray *fileTypes = [userDefaults objectForKey:ZKRowsCheckFileTypes];
        
       // 非处理文件过滤
        if (!fileTypes.count || ![fileTypes containsObject:extension])
        {
            return 0;
        }
        // 文件数量加1
        _codeFileNumber += 1;
       //获取文件信息
        NSDictionary *firstFileInfo = [manager attributesOfItemAtPath:path error:nil];
        //文件修改日期
        NSDate *modifyTimeData = [firstFileInfo objectForKey:NSFileModificationDate];//获取一个文件修改时间
        NSString *modifyTimeString = [[self.dateFormatter stringFromDate:modifyTimeData] lowercaseString];
        
        if (modifyTimeString.integerValue == self.currentTime.integerValue)
        {
            NSLog(@" 当天修改的");
            
        }
        else
        {
            NSLog(@"历史修改");
        }
        
        
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[content componentsSeparatedByString:@"\n"]];
        // 清除空行 
        [array removeObjectsInArray:@[@"",@"    "]];
        return array.count;
    }
    
}

@end
