//
//  AppDelegate.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/7.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/**
 window加载类型vc
 
 - WindowTypeHomeViewController: home
 - WindowTypeCodeValidationViewController: code
 */
typedef NS_ENUM(NSInteger, WindowType)
{
    WindowTypeHomeViewController = 0,
    
    WindowTypeCodeValidationViewController
    
};
#import "AppDelegate.h"
#import "ZKHomeViewController.h"
#import "ZKCodeValidationViewController.h"
@interface AppDelegate ()



/**
 必须强引用一下 因为contentView是弱应用
 */
@property (nonatomic, strong) ZKHomeViewController *homeViewController;

@property (nonatomic, strong) ZKCodeValidationViewController *codeValidationViewController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    //只保留关闭按钮
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    
    // 登录过的直接加载监测界面
    if ([UserInfo account].name.length == 0)
    {
        [self rootContentView:WindowTypeHomeViewController];
    }
    else
    {
        [self rootContentView:WindowTypeCodeValidationViewController];
    }
}
/**
 加载代码监测界面
 */
- (void)rootCodeValidationViewController;
{
    [self.window close];
    ZKCodeValidationViewController *vc = [[ZKCodeValidationViewController alloc] initWithWindowNibName:@"ZKCodeValidationViewController"];
    
    [NSApp beginModalSessionForWindow:[vc window]];
    [NSApp runModalForWindow:[vc window]];
    //前置显示窗口
    [vc.window orderFront:nil];
}

/**
 加载登录主页
 */
- (void)rootHomeViewController
{
    self.homeViewController = [[ZKHomeViewController alloc] initWithNibName:@"ZKHomeViewController" bundle:nil];
    self.window.contentView = self.homeViewController.view;
    // 设置homeViewController窗口和window窗口一致
    self.homeViewController.view.frame = self.window.contentView.frame;
    [self.window orderFront:nil];
}

/**
 更加类型加载vc
 
 @param type vc类型
 */
- (void)rootContentView:(WindowType)type
{
    if (type == WindowTypeHomeViewController)
    {
        [self rootHomeViewController];
    }
    else
    {
        [self rootCodeValidationViewController];
    }
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
