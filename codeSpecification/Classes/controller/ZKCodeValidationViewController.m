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

#define FileViewWidth 160

#import "ZKCodeValidationViewController.h"
#import "ZKLoginWindowController.h"
/** listTableView内容**/
#import "ZKLogViewController.h"
#import "ZKResultsAnalysisViewController.h"
#import "ZKErrorDescriptionViewController.h"
#import "ZKInfoViewController.h"
/* ---华丽分割线---- */
#import "ZKFileProcessingMode.h"
#import "AppDelegate.h"

@interface ZKCodeValidationViewController ()
// 语言选择按钮
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

@property (strong) NSWindow             *rightSetWindow;

@property (nonatomic, strong) ZKLoginWindowController *loginWindowController;
// 文件处理工具
@property (nonatomic, strong) ZKFileProcessingMode    *fileProcessingMode;
/* tableView加载的vc*/
// 输出日志vc
@property (nonatomic, strong) ZKLogViewController    *logViewController;
// 结果vc
@property (nonatomic, strong) ZKResultsAnalysisViewController     *resultsAnalysisViewController;
// 错误描述vc
@property (nonatomic, strong) ZKErrorDescriptionViewController    *errorDescriptionViewController;
// 规则说明
@property (nonatomic, strong) ZKInfoViewController                *infoViewController;


@end

@implementation ZKCodeValidationViewController

- (ZKFileProcessingMode *)fileProcessingMode
{

    if (!_fileProcessingMode)
    {
        _fileProcessingMode = [[ZKFileProcessingMode alloc] init];
    }
    return _fileProcessingMode;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    //    NSOpenPanel
    [self setData];
    [self setUI];
}
#pragma mark -----界面设置-----
- (void)setUI
{
      /**添加分析日子vc**/
    self.logViewController = [[ZKLogViewController alloc] initWithNibName:@"ZKLogViewController" bundle:nil];
    [[self.listTableView.tabViewItems objectAtIndex:0] setView:self.logViewController.view];
    ;
    /**添加分析结果vc**/
    self.resultsAnalysisViewController = [[ZKResultsAnalysisViewController alloc] initWithNibName:@"ZKResultsAnalysisViewController" bundle:nil];
    [[self.listTableView.tabViewItems objectAtIndex:1] setView:self.resultsAnalysisViewController.view];
    ;
    /**添加错误描述vc**/
    self.errorDescriptionViewController = [[ZKErrorDescriptionViewController alloc] initWithNibName:@"ZKErrorDescriptionViewController" bundle:nil];
    [[self.listTableView.tabViewItems objectAtIndex:2] setView:self.errorDescriptionViewController.view];
    ;
    /**添加说明vc**/
    self.infoViewController = [[ZKInfoViewController alloc] initWithNibName:@"ZKInfoViewController" bundle:nil];
    [[self.listTableView.tabViewItems objectAtIndex:3] setView:self.infoViewController.view];
    ;
    
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
    [NSObject showErrorAlertTitle:@"温馨提示" message:@"该功能暂未开放，请敬请等待。" forWindow:[self window] completionHandler:nil];
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
- (IBAction)browseFileClick:(NSButton *)sender
{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
       // 设置默认打开路径
    panel.directoryURL = [NSURL URLWithString:NSHomeDirectory()];
    //是否可以选择目录
    panel.canChooseDirectories = YES;
    //是否允许多选
    panel.allowsMultipleSelection = NO;
    //允许选择的文件类型
    panel.allowedFileTypes = nil;
    ZKWeakSelf
    [panel beginWithCompletionHandler:^(NSInteger result)
    {
        // 点击了Open按钮
        if (result == NSModalResponseOK)
        {
            NSURL *fileUrl = panel.URLs.firstObject;
            if (fileUrl)
            {
             [weakSelf.fileProcessingMode dragDropFilePathList:@[[fileUrl path]]];
            }
        }
    }];
    
}
- (IBAction)setFile:(NSButton *)sender
{
    [NSObject showErrorAlertTitle:@"温馨提示" message:@"该功能暂未开放，请敬请等待。" forWindow:[self window] completionHandler:nil];
}
- (IBAction)checkTheUpdate:(NSButton *)sender
{
    [NSObject showErrorAlertTitle:@"温馨提示" message:@"当前版本已是最新的版本。" forWindow:self.window completionHandler:nil];
}
@end
