//
//  ZKLogViewController.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKLogViewController.h"
#import "ZKAnalysisLogMode.h"

@interface ZKLogViewController ()<NSTableViewDelegate,NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *logTableView;

@property (nonatomic, strong) NSMutableArray <ZKAnalysisLogMode *>*dataArray;

@end

@implementation ZKLogViewController

- (NSMutableArray<ZKAnalysisLogMode *> *)dataArray
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
    self.logTableView.delegate   = self;
    self.logTableView.dataSource = self;
}
#pragma mark  ----数据----
/**
 添加数据
 
 @param list 数据
 @param start 是否开始
 */
- (void)addTableViewData:(ZKAnalysisLogMode *)list isStart:(BOOL)start;
{
    if (start == YES)
    {
        [self.dataArray removeAllObjects];
        [self.logTableView reloadData];
    }
    NSInteger row = self.dataArray.count;
    [self.dataArray addObject:list];
    //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃
    [self.logTableView beginUpdates];//开始操作
    // 插入数据
    [self.logTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectNone];
    [self.logTableView endUpdates];// 结束操作
    // 让某一行显示在界面中
    [self.logTableView scrollRowToVisible:self.dataArray.count-1];
}
#pragma mark  ----NSTableViewDataSource----
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    return self.dataArray.count;
}

#pragma mark  ----NSTableViewDelegate----
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"logCell" owner:self];
    if (self.dataArray.count >row)
    {
        ZKAnalysisLogMode *mode = [self.dataArray objectAtIndex:row];
        NSString *mes = [NSString stringWithFormat:@"%@             %@",mode.classSuffix,mode.modifyTime];
        cell.textField.stringValue = mes;
    }
    return cell;
}

@end
