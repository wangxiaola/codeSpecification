//
//  ZKBaseViewController.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/7.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKBaseViewController.h"

@interface ZKBaseViewController ()

@end

@implementation ZKBaseViewController

- (void)viewWillAppear
{
    [super viewWillAppear];
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
