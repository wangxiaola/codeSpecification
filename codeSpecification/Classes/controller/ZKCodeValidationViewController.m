//
//  ZKCodeValidationViewController.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/8.
//  Copyright © 2017年 王小腊. All rights reserved.
//

NSString *const kIsEdit = @"kIsEdit";
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

@interface ZKCodeValidationViewController ()<NSTokenFieldDelegate,ZKFileProcessingModeDelegate>
// 语音类型
@property (nonatomic)     CompileLanguageType languageType;
// 文件处理工具
@property (nonatomic, strong) ZKFileProcessingMode                *fileProcessingMode;

@property (nonatomic, strong) ZKLoginWindowController             *loginWindowController;
/* tableView加载的vc*/
// 错误描述vc
@property (nonatomic, strong) ZKErrorDescriptionViewController    *errorDescriptionViewController;
// 规则说明
@property (nonatomic, strong) ZKInfoViewController                *infoViewController;
// 输出日志vc
@property (nonatomic, strong) ZKLogViewController                 *logViewController;
// 结果vc
@property (nonatomic, strong) ZKResultsAnalysisViewController     *resultsAnalysisViewController;
@property (strong)        NSWindow      *rightSetWindow;
/** 需要检测的文件类型*/
@property (weak) IBOutlet NSTokenField *checkFileType;
/** 需要忽略检测的文件夹*/
@property (weak) IBOutlet NSTokenField *ignoreFolder;
// 用户信息
@property (strong)        UserInfo      *userInfo;
// 是否正在运行<文件编译中>
@property (nonatomic, assign) BOOL      isRun;
// 是否分析当前文件按钮
@property (weak) IBOutlet NSButton      *currentFileButton;
// 语言选择按钮
@property (weak) IBOutlet NSPopUpButton *voiceChoice;
// 表格
@property (weak) IBOutlet NSTabView     *listTableView;
// 名字
@property (weak) IBOutlet NSTextField   *nameTextField;

@end

@implementation ZKCodeValidationViewController

- (ZKFileProcessingMode *)fileProcessingMode
{
    
    if (!_fileProcessingMode)
    {
        _fileProcessingMode = [[ZKFileProcessingMode alloc] init];
        _fileProcessingMode.delegate = self;
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
    self.checkFileType.tokenStyle = NSTokenStyleSquared;
    self.ignoreFolder.tokenStyle = NSTokenStyleSquared;
    self.checkFileType.delegate = self;
    self.ignoreFolder.delegate = self;
    
    // 初始化语音类型
    self.languageType = CompileLanguageTypeObjective;
    // 获取个人信息
    self.userInfo = [UserInfo account];
    // 赋值姓名
    self.nameTextField.stringValue = self.userInfo.name;
    // 如果设置未更改
    if ([ZKUtil obtainBoolForKey:kIsEdit] == NO)
    {
        [ZKUtil cacheUserValue:self.defaultFileTypes key:ZKRowsCheckFileTypes];
        [ZKUtil cacheUserValue:self.defaultIgnoreFolders key:ZKRowsIgnoreFolders];
        [ZKUtil saveBoolForKey:IsNewModifiedAnalysis valueBool:YES];
    }
    self.checkFileType.objectValue = [ZKUtil getUserDataForKey:ZKRowsCheckFileTypes];
    self.ignoreFolder.objectValue  = [ZKUtil getUserDataForKey:ZKRowsIgnoreFolders];
    self.currentFileButton.state   = [ZKUtil obtainBoolForKey:IsNewModifiedAnalysis];
}
#pragma mark - getter

- (NSArray *)defaultFileTypes
{
    NSArray *array = @[@"h",@"m"];
    return array;
}

- (NSArray *)defaultIgnoreFolders
{
    NSArray *array = @[@"Pods",@".svn",@".git"];
    return array;
}
#pragma mark  ----按钮点击事件----
- (IBAction)voiceChoiceButton:(NSPopUpButton *)sender
{
    self.languageType = sender.selectedTag;
}
- (IBAction)toAnalyze:(NSButton *)sender
{
    if (self.isRun == NO)
    {
        [self.fileProcessingMode startAnalyzeLanguageType:self.languageType];
    }
    else
    {
        [HUD showMessenger:@"文件正在检测中,请稍后再试!" fromView:self.window.contentView dismiss:nil];
    }
    
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
    if (self.isRun == NO)
    {
        [self.fileProcessingMode browseClickcompile];
    }
    else
    {
        [HUD showMessenger:@"文件正在检测中,请稍后再试!" fromView:self.window.contentView dismiss:nil];
    }
}
- (IBAction)setFile:(NSButton *)sender
{
    [NSObject showErrorAlertTitle:@"温馨提示" message:@"该功能暂未开放，请敬请等待。" forWindow:[self window] completionHandler:nil];
}
- (IBAction)checkTheUpdate:(NSButton *)sender
{
    [NSObject showErrorAlertTitle:@"温馨提示" message:@"当前版本已是最新的版本。" forWindow:self.window completionHandler:nil];
}
- (IBAction)currentFileButtonClick:(NSButton *)sender
{
    [ZKUtil saveBoolForKey:IsNewModifiedAnalysis valueBool:sender.state];
    [ZKUtil saveBoolForKey:kIsEdit valueBool:YES];
}
#pragma mark  ----ZKFileProcessingModeDelegate----
/**
 开始分析
 
 @param mode 数据
 */
- (void)startAnalyzeData:(ZKAnalysisLogMode *)mode;
{
    self.isRun = YES;
    
    [self.logViewController addTableViewData:mode isStart:YES];
}
/**
 结束分析
 
 @param mode 数据
 */
- (void)stopAnalyzeData:(ZKAnalysisLogMode *)mode;
{

    [self.logViewController addTableViewData:mode isStart:NO];
    
    // 提示是否上传
    [NSObject showPromptAlertTitle:@"温馨提示" message:@"亲，是否上传本次检测结果？" forWindow:self.window completionHandler:^(NSModalResponse returnCode) {
        NSLog(@"----上传完成----");
      self.isRun = NO;
    }];
}
/**
 文件分析异常
 
 @param message 错误消息
 */
- (void)fileAnalysisAbnormalErrorMessage:(NSString *)message;
{
    self.isRun = NO;
    [NSObject showErrorAlertTitle:@"温馨提示" message:message forWindow:self.window completionHandler:nil];
}
/**
 分析日志返回
 
 @param mode 数据
 */
- (void)analysisOfDailyReturnsData:(ZKAnalysisLogMode *)mode;
{
    [self.logViewController addTableViewData:mode isStart:NO];
}
/**
 分析结果返回
 
 @param mode 数据
 */
- (void)analysisResultsReturnsData:(ZKCodeResults *)mode;
{
    
}
/**
 错误描述返回
 
 @param mode 数据
 */
- (void)errorDescriptionReturnData:(ZKErrorCodeInformation *)mode;
{
    
}
#pragma mark --NSTokenFieldDelegate--
/**
 存储最新的文件检测配置
 */
- (void)controlTextDidChange:(NSNotification *)obj
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 标记配置是否已更改
    [userDefaults setBool:YES forKey:kIsEdit];
    
    if ([obj.object isEqual:self.checkFileType]) {
        [userDefaults setObject:self.fileTypes forKey:ZKRowsCheckFileTypes];
    } else {
        [userDefaults setObject:self.ignoreFolder.objectValue forKey:ZKRowsIgnoreFolders];
    }
    [userDefaults synchronize];
}
- (NSArray *)fileTypes
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.checkFileType.objectValue];
    // 将文件类型名称全部转化成小写
    for (NSString *fileType in self.checkFileType.objectValue) {
        [fileType lowercaseString];
    }
    return array;
}

@end
