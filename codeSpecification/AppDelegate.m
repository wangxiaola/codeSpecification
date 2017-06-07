//
//  AppDelegate.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/7.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "AppDelegate.h"
#import "ZKHomeViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

/**
 必须强引用一下 因为contentView是弱应用
 */
@property (nonatomic, strong) ZKHomeViewController *homeViewController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
     self.homeViewController = [[ZKHomeViewController alloc] initWithNibName:@"ZKHomeViewController" bundle:nil];
    //将控制的view 添加到主窗口的容器视图（contentView）中。
    [self.window.contentView addSubview:self.homeViewController.view];
    // 设置homeViewController窗口和window窗口一致
    self.homeViewController.view.frame = self.window.contentView.frame;
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
