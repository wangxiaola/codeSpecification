//
//  ZKResultsAnalysisViewController.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKResultsAnalysisViewController.h"
#import "ZKCodeResults.h"

@interface ZKResultsAnalysisViewController ()<NSTableViewDelegate,NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *resultsTableView;

@property (nonatomic, strong) NSMutableArray <ZKCodeResults *>*dataArray;

@end

@implementation ZKResultsAnalysisViewController
- (NSMutableArray<ZKCodeResults *> *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setUI];
}
#pragma mark -----界面设置-----
- (void)setUI
{
    self.resultsTableView.delegate   = self;
    self.resultsTableView.dataSource = self;
}
#pragma mark  ----数据----
/**
 添加数据
 
 @param list 数据
 @param start 是否开始
 */
- (void)addTableViewData:(ZKCodeResults *)list isStart:(BOOL)start;
{
    
    if (start == YES)
    {
        [self.dataArray removeAllObjects];
        [self.resultsTableView reloadData];
    }
    else
    {
        NSInteger row = self.dataArray.count;
        [self.dataArray addObject:list];
        //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃
        [self.resultsTableView beginUpdates];//开始操作
        // 插入数据
        [self.resultsTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectNone];
        [self.resultsTableView endUpdates];// 结束操作
        // 让某一行显示在界面中
        [self.resultsTableView scrollRowToVisible:self.dataArray.count-1];
    }
}
#pragma mark  ----NSTableViewDataSource----
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    
    return self.dataArray.count;
}

#pragma mark  ----NSTableViewDelegate----
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if (self.dataArray.count >row)
    {
        ZKCodeResults *mode = [self.dataArray objectAtIndex:row];
        
        if ([tableColumn.identifier isEqualToString:@"columen0"])
        {
            cell.textField.stringValue = mode.filePath;
        }
        else if ([tableColumn.identifier isEqualToString:@"columen1"])
        {
            cell.textField.stringValue = [NSString stringWithFormat:@"%.2f%%",mode.annotationProportion];
        }
        else if ([tableColumn.identifier isEqualToString:@"columen2"])
        {
            
            cell.textField.stringValue = [NSString stringWithFormat:@"%.0f",mode.codeNumber];
        }
        else if ([tableColumn.identifier isEqualToString:@"columen3"])
        {
            cell.textField.stringValue = [NSString stringWithFormat:@"%.0f",mode.noteNumber];
        }
        else if ([tableColumn.identifier isEqualToString:@"columen4"])
        {
            cell.textField.stringValue = mode.codeQuality;
        }
        else if ([tableColumn.identifier isEqualToString:@"columen5"])
        {
            cell.textField.stringValue = [NSString stringWithFormat:@"%.0f处",mode.errorCodeNumber];
        }
    }
    return cell;
}

@end
