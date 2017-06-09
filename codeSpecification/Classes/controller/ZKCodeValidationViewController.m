//
//  ZKCodeValidationViewController.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/8.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/**
 语音类型

 - VoiceTypeObjective: Objective-C
 - VoiceTypeSwift: Swift
 - VoiceTypeJava: Java
 */
typedef NS_ENUM(NSInteger, VoiceType) {

    VoiceTypeObjective = 0,
    VoiceTypeSwift,
    VoiceTypeJava
};

#import "ZKCodeValidationViewController.h"
#import "ZKLoginWindowController.h"
#import "AppDelegate.h"

@interface ZKCodeValidationViewController ()
//语音选择按钮
@property (weak) IBOutlet NSPopUpButton *voiceChoice;
// 是否分析当前文件按钮
@property (weak) IBOutlet NSButton      *currentFileButton;
// 名字
@property (weak) IBOutlet NSTextField   *nameTextField;
// 表格
@property (weak) IBOutlet NSTabView     *listTableView;

@property (nonatomic)     VoiceType     voiceType;
// 用户信息
@property (strong)        UserInfo      *userInfo;

@property (strong) ZKLoginWindowController *loginWindowController;
@end

@implementation ZKCodeValidationViewController

- (void)windowDidLoad {
    [super windowDidLoad];
//    NSOpenPanel
    [self setData];
}
#pragma mark  ----数据加载----
- (void)setData
{
    // 初始化语音类型
    self.voiceType = VoiceTypeObjective;
    // 获取个人信息
    self.userInfo = [UserInfo account];
    // 赋值姓名
    self.nameTextField.stringValue = self.userInfo.name;
}
#pragma mark  ----按钮点击事件----
- (IBAction)voiceChoiceButton:(NSPopUpButton *)sender
{
    self.voiceType = sender.selectedTag;
    if (sender.selectedTag >0)
    {
        [HUD showMessenger:@"当前编程语言暂未开放" fromView:self.window.contentView dismiss:nil];
    }
    
}
- (IBAction)toAnalyze:(NSButton *)sender
{
    
}
- (IBAction)changeTheAccount:(NSButton *)sender
{
    [NSObject showPromptAlertTitle:@"温馨提示" message:@"亲！是否要更换账号？" forWindow:self.window completionHandler:^(NSModalResponse returnCode) {
        
        if (returnCode == NSAlertFirstButtonReturn)
        {
            _loginWindowController = [[ZKLoginWindowController alloc] initWithWindowNibName:@"ZKLoginWindowController"];
            //显示需要跳转的窗口
            [_loginWindowController.window orderFront:nil];
            [_loginWindowController.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
            [_loginWindowController.window center];
            //关闭当前窗口
            [self.window orderOut:nil];
            
        }
    }];

}
- (IBAction)checkTheUpdate:(NSButton *)sender
{
    [NSObject showErrorAlertTitle:@"温馨提示" message:@"当前版本已是最新的版本。" forWindow:self.window completionHandler:nil];
}

@end
