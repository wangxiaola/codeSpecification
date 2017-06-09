//
//  ZKLoginWindowController.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/9.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKLoginWindowController.h"
#import "ZKCodeValidationViewController.h"
#import "ZKUserConfigurationView.h"

@interface ZKLoginWindowController ()

@property (nonatomic, strong) ZKCodeValidationViewController *codeValidationViewController;

@property (strong) NSWindow                 *bottomWindow;

@property (strong) ZKUserConfigurationView  *contentView;

@property (weak) IBOutlet NSTextField       *accountTextField;

@property (weak) IBOutlet NSSecureTextField *passwordTextField;

@property (weak) IBOutlet NSButton          *sendButton;

@property (strong) UserInfo                 *userInfo;
@end

@implementation ZKLoginWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    
    [self setUI];
    [self setData];
    
}
#pragma mark -----界面设置-----
- (void)setUI
{
    // 设置背景色为白色
    self.window.contentView.wantsLayer = YES;
    self.window.contentView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    //有阴影
    [self.window setHasShadow:YES];
    //设置窗口为透明
    [self.window setOpaque:NO];
    //设置为点击背景可以移动窗口
    [self.window setMovableByWindowBackground:YES];
    
    //只保留关闭按钮
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    
    // 加载设置界面
    NSArray *nilArray;
    [[NSBundle mainBundle]loadNibNamed:@"ZKUserConfigurationView" owner:self topLevelObjects:&nilArray];
    // 找出ContentView
    [nilArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[ZKUserConfigurationView class]]) {
            
              self.contentView = (ZKUserConfigurationView *)nilArray[idx];
        }
    }];
    
    self.bottomWindow = [[NSWindow alloc]init];
    self.bottomWindow.styleMask = NSWindowStyleMaskBorderless;
    self.bottomWindow.backingType = NSBackingStoreNonretained;
    [self.bottomWindow setFrame:NSMakeRect(self.window.frame.origin.x, self.window.frame.origin.y, self.window.frame.size.width, 80) display:YES animate:YES];
    //设置ContentView
    self.bottomWindow.contentView = self.contentView;
    //添加childWindow
    [self.window addChildWindow:self.bottomWindow ordered:NSWindowBelow];
    
    // 隐藏titleBar
    [self.window setTitleVisibility:NSWindowTitleHidden];
    [self.window setTitlebarAppearsTransparent:YES];
    [self.window setStyleMask:NSWindowStyleMaskFullSizeContentView|NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable|NSWindowStyleMaskResizable];
    
}
- (void)setData
{
    self.userInfo = [UserInfo account];
    if (self.userInfo.account.length >0 && self.userInfo.password.length >0)
    {
        // 取出保存的账号并赋值
        [self.accountTextField setStringValue:self.userInfo.account];
        [self.passwordTextField setStringValue:self.userInfo.password];
    }
}
#pragma mark  ----点击事件----
- (IBAction)loginAuthentication:(NSButton *)sender
{
    if (self.accountTextField.stringValue.length == 0)
    {
        [NSObject showErrorAlertTitle:@"温馨提示" message:@"账号不能为空" forWindow:self.window completionHandler:nil];
        return;
    }
    if (self.passwordTextField.stringValue.length == 0)
    {
        [NSObject showErrorAlertTitle:@"温馨提示" message:@"密码不能为空" forWindow:self.window completionHandler:nil];
        return;
    }
    
    [self loginRequest];
}

- (IBAction)setStateButton:(NSButton *)sender
{
    CGRect frame = self.bottomWindow.frame;
    // 判断是否显示设置界面
    if (frame.origin.y == self.window.frame.origin.y)
    {
        [self.bottomWindow setFrame:NSMakeRect(self.window.frame.origin.x, self.window.frame.origin.y-78, self.window.frame.size.width, 80) display:YES animate:YES];
        [sender setImage:[NSImage imageNamed:@"topButton"]];
    }else{
        [self.bottomWindow setFrame:NSMakeRect(self.window.frame.origin.x, self.window.frame.origin.y, self.window.frame.size.width, 80) display:YES animate:YES];
        [sender setImage:[NSImage imageNamed:@"bottomButton"]];
    }
}
#pragma mark  ----逻辑处理----
/**
 设置view上控件的可交互性
 
 @param interaction 是否可交互 yes
 */
- (void)setViewUIInteraction:(BOOL)interaction
{
    [self.accountTextField setEnabled:interaction];
    [self.passwordTextField setEnabled:interaction];
    [self.sendButton setEnabled:interaction];
    
    if (interaction == YES)
    {
        [self.sendButton setTitle:@"登 录"];
    }
    else
    {
        [self.sendButton setTitle:@"正在登录"];
        
    }
}
/**
 开始请求登录
 */
- (void)loginRequest
{
    //http://192.168.0.88:81/dologins?account=tanghm&password=123456
//    https://github.com/jkpang/PPRows
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.accountTextField.stringValue forKey:@"account"];
    [dic setObject:self.passwordTextField.stringValue forKey:@"password"];
    [self setViewUIInteraction:NO];
    ZKWeakSelf
    [ZKRequestTool post:POST_REQUEST params:dic success:^(id responseObj) {
        
        [weakSelf setViewUIInteraction:YES];
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        if ([errcode isEqualToString:@"success"])
        {
            [weakSelf resultProcessingData:responseObj];
        }
        else
        {
            [NSObject showErrorAlertTitle:@"温馨提示" message:@"数据异常异常，请重新登录" forWindow:[self.window.contentView window] completionHandler:nil];
        }
        
    } failure:^(NSError *error) {
        [weakSelf setViewUIInteraction:YES];
        [NSObject showErrorAlertTitle:@"温馨提示" message:@"网络异常，请检查网络连接" forWindow:[self.window.contentView window] completionHandler:nil];
    }];
}

/**
 结果处理
 
 @param data 数据
 */
- (void)resultProcessingData:(NSDictionary *)data
{
    NSDictionary *dataDic = [data valueForKey:@"data"];
    NSString *ID = [dataDic valueForKey:@"id"];
    NSString *name = [dataDic valueForKey:@"name"];
    // 是否保存用户信息
    BOOL isRememberState = [ZKUtil obtainBoolForKey:RememberStateKey];
    if (isRememberState == YES)
    {
        // 记录账号密码
        self.userInfo.password = self.passwordTextField.stringValue;
        self.userInfo.account  = self.accountTextField.stringValue;
        self.userInfo.ID = ID;
        self.userInfo.name = name;
        [UserInfo saveAccount:self.userInfo];
    }
    ZKWeakSelf
    [HUD showMessenger:@"登录成功" fromView:self.window.contentView dismiss:^{
        
        [weakSelf goCodeController];
    }];
}
- (void)goCodeController
{
    
    self.codeValidationViewController = [[ZKCodeValidationViewController alloc] initWithWindowNibName:@"ZKCodeValidationViewController"];
    //显示需要跳转的窗口
    [self.codeValidationViewController.window orderFront:nil];
    // 设置动画样式
    [self.codeValidationViewController.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [self.codeValidationViewController.window center];
    //关闭当前窗口
    [self.window orderOut:nil];
    //    [self.window close];
}

@end
