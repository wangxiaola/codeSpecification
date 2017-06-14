//
//  ZKLogViewController.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKLogViewController.h"

@interface ZKLogViewController ()<NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *logTableView;

@end

@implementation ZKLogViewController

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
#pragma mark  ----NSTableViewDataSource----
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    return 4;
}

#pragma mark  ----NSTableViewDelegate----
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"logCell" owner:self];
    cell.textField.stringValue = @"123456";
    return cell;
}


@end
