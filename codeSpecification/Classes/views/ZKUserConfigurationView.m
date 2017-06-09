//
//  ZKUserConfigurationView.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/9.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKUserConfigurationView.h"

@interface ZKUserConfigurationView()

@property (weak) IBOutlet NSButton *rememberButton;

@property (weak) IBOutlet NSButton *automaticLoginButton;


@end
@implementation ZKUserConfigurationView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setWantsLayer:YES];
    self.layer.cornerRadius = 5;
    [self.layer masksToBounds];
    [self setData];
}
#pragma mark  ----UI配置----
/**
 参数配置
 */
- (void)setData;
{
    /*获取状态*/
    BOOL isRememberState = [ZKUtil obtainBoolForKey:RememberStateKey];
    BOOL isAutomaticLoginState = [ZKUtil obtainBoolForKey:AutomaticLoginSateKey];
    
    [self.rememberButton setState:isRememberState];
    [self.automaticLoginButton setState:isAutomaticLoginState];
    
}

#pragma mark  ----点击事件----
//记住密码
- (IBAction)rememberSelect:(NSButton *)sender
{
    [ZKUtil saveBoolForKey:RememberStateKey valueBool:sender.state];
}
//自动登录
- (IBAction)automaticLoginSelect:(NSButton *)sender
{
    [ZKUtil saveBoolForKey:AutomaticLoginSateKey valueBool:sender.state];
}
//忘记密码
- (IBAction)forgotPassword:(NSButton *)sender
{
    [NSObject showErrorAlertTitle:@"温馨提示" message:@"该功能暂未开放，请敬请等待。" forWindow:[self window] completionHandler:nil];
}
//注册账号
- (IBAction)registeredAccount:(NSButton *)sender
{
    [NSObject showErrorAlertTitle:@"温馨提示" message:@"该功能暂未开放，请敬请等待。" forWindow:[self window] completionHandler:nil];
}

@end
