//
//  ZKErrorDescriptionViewController.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKErrorDescriptionViewController.h"
#import "ZKErrorCodeInformation.h"

@interface ZKErrorDescriptionViewController ()<NSTableViewDelegate,NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *errorTableView;

@property (nonatomic, strong) NSMutableArray <ZKErrorCodeInformation *>*dataArray;


@end

@implementation ZKErrorDescriptionViewController

- (NSMutableArray <ZKErrorCodeInformation *> *)dataArray
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
    self.errorTableView.delegate   = self;
    self.errorTableView.dataSource = self;
}
#pragma mark  ----数据----
/**
 添加数据
 
 @param list 数据
 @param start 是否开始
 */
- (void)addTableViewData:(ZKErrorCodeInformation *)list isStart:(BOOL)start;
{
    
    
    if (start == YES)
    {
        [self.dataArray removeAllObjects];
        [self.errorTableView reloadData];
    }
    else
    {
        NSInteger row = self.dataArray.count;
        [self.dataArray addObject:list];
        //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃
        [self.errorTableView beginUpdates];//开始操作
        // 插入数据
        [self.errorTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectNone];
        [self.errorTableView endUpdates];// 结束操作
        // 让某一行显示在界面中
        [self.errorTableView scrollRowToVisible:self.dataArray.count-1];
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
        ZKErrorCodeInformation *mode = [self.dataArray objectAtIndex:row];
        if ([tableColumn.identifier isEqualToString:@"columen0"])
        {
            cell.textField.stringValue = mode.className;
        }
        else if ([tableColumn.identifier isEqualToString:@"columen1"])
        {
            cell.textField.stringValue = [NSString stringWithFormat:@"第%.ld行",(long)mode.whichLine];
        }
        else if ([tableColumn.identifier isEqualToString:@"columen2"])
        {
            cell.textField.stringValue = mode.errorDescription;
        }
    }
    return cell;
}


@end
