//
//  AppDelegate.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/7.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/**
 window加载类型vc
 
 - WindowTypeLoginViewController: login
 - WindowTypeCodeValidationViewController: code
 */
typedef NS_ENUM(NSInteger, WindowType)
{
    WindowTypeLoginViewController = 0,
    
    WindowTypeCodeValidationViewController
    
};
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    /*是否自动登录*/
    BOOL isAutomaticLoginState = [ZKUtil obtainBoolForKey:AutomaticLoginSateKey];
    
    // 登录过的直接加载监测界面
    if ([UserInfo account].name.length > 0 && isAutomaticLoginState == YES)
    {
        _codeValidationViewController = [[ZKCodeValidationViewController alloc] initWithWindowNibName:@"ZKCodeValidationViewController"];
        [_codeValidationViewController.window setFrame:NSMakeRect(0, 0, 935, 588) display:YES animate:NO];
        //让显示的位置居于屏幕的中心
        [[_codeValidationViewController window] center];
        //前置显示窗口
        [_codeValidationViewController.window orderFront:nil];
    }
    else
    {
        _loginWindowController = [[ZKLoginWindowController alloc] initWithWindowNibName:@"ZKLoginWindowController"];
        [_codeValidationViewController.window setFrame:NSMakeRect(0, 0, 230, 320) display:YES animate:NO];
        //让显示的位置居于屏幕的中心
        [[_loginWindowController window] center];
        //前置显示窗口
        [_loginWindowController.window orderFront:nil];
    }
}
// 当点击关闭按钮的时候结束APP进程
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}
- (IBAction)goJianShu:(NSMenuItem *)sender
{
    [ZKUtil openSafarlUrl:@"http://www.jianshu.com/u/a3a190b64408"];
}
- (IBAction)goGithub:(NSMenuItem *)sender
{
    [ZKUtil openSafarlUrl:@"https://github.com/wangxiaola"];
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
