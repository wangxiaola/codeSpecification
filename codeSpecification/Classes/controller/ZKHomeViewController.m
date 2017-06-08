//
//  ZKHomeViewController.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/7.
//  Copyright © 2017年 王小腊. All rights reserved.
//


#import "ZKHomeViewController.h"
#import "ZKCodeValidationViewController.h"
#import "NSButton+ButtonColor.h"
#import "AppDelegate.h"

@interface ZKHomeViewController ()
@property (weak) IBOutlet NSImageView *backImageView;
@property (weak) IBOutlet NSView      *rightBackView;
@property (weak) IBOutlet NSTextField *accountTextField;
@property (weak) IBOutlet NSSecureTextField *passwordTextField;
@property (weak) IBOutlet NSButton          *sendButton;
@property (weak) IBOutlet NSImageView       *gifImageView;
@property (nonatomic, strong) UserInfo      *userInfo;
@end

@implementation ZKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setUI];
    [self setData];
    
}
#pragma mark -----界面设置-----
- (void)setUI
{
    
    // 设置颜色
    [self.backImageView.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
    
    [self.rightBackView setWantsLayer:YES];
    [self.rightBackView.layer setBackgroundColor:[UIColorFromRGB(0x3CAFFE) CGColor]];
    self.rightBackView.layer.cornerRadius = 3;
    
    [self.sendButton setTextColor:UIColorFromRGB(0x3CAFFE)];
    // 加载GIF动画
    [self.gifImageView setImageScaling:NSImageScaleNone];
    [self.gifImageView setAnimates:YES];
    self.gifImageView.image = [NSImage imageNamed:@"homeOne_Gif.gif"];
    
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
        self.gifImageView.image = [NSImage imageNamed:@"homeOne_Gif.gif"];
    }
    else
    {
        [self.sendButton setTitle:@"正在登录"];
        self.gifImageView.image = [NSImage imageNamed:@"homeThree_Gif.gif"];
    }
    [self.sendButton setTextColor:UIColorFromRGB(0x3CAFFE)];
}
#pragma mark  ----点击事件----
- (IBAction)loginAuthentication:(NSButton *)sender
{
    
    if (self.accountTextField.stringValue.length == 0)
    {
        [NSObject showErrorAlertTitle:@"温馨提示" message:@"账号不能为空" forWindow:[self.view window] completionHandler:nil];
        return;
    }
    if (self.passwordTextField.stringValue.length == 0)
    {
        [NSObject showErrorAlertTitle:@"温馨提示" message:@"密码不能为空" forWindow:[self.view window] completionHandler:nil];
        return;
    }
    
    [self loginRequest];
}

/**
 开始请求登录
 */
- (void)loginRequest
{
    //http://192.168.0.88:81/dologins?account=tanghm&password=123456
    
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
            [NSObject showErrorAlertTitle:@"温馨提示" message:@"数据异常异常，请重新登录" forWindow:[self.view window] completionHandler:nil];
        }
        
    } failure:^(NSError *error) {
        [weakSelf setViewUIInteraction:YES];
        [NSObject showErrorAlertTitle:@"温馨提示" message:@"网络异常，请检查网络连接" forWindow:[self.view window] completionHandler:nil];
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
    // 记录账号密码
    self.userInfo.password = self.passwordTextField.stringValue;
    self.userInfo.account  = self.accountTextField.stringValue;
    self.userInfo.ID = ID;
    self.userInfo.name = name;
    [UserInfo saveAccount:self.userInfo];
    
    [HUD showMessenger:@"登录成功" fromView:self.view dismiss:^{
        
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        [appDelegate rootCodeValidationViewController];
        
        
        
    }];
    
}
@end
