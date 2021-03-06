//
//  AppDelegate.h
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/7.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZKLoginWindowController.h"
#import "ZKCodeValidationViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) ZKCodeValidationViewController *codeValidationViewController;

@property (nonatomic, strong) ZKLoginWindowController *loginWindowController;
@end

