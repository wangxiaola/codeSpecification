//
//  ZKHomeViewController.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/7.
//  Copyright © 2017年 王小腊. All rights reserved.
//


#import "ZKHomeViewController.h"
#import "NSButton+ButtonColor.h"

@interface ZKHomeViewController ()
@property (weak) IBOutlet NSImageView *backImageView;
@property (weak) IBOutlet NSView      *rightBackView;
@property (weak) IBOutlet NSTextField *accountTextField;
@property (weak) IBOutlet NSSecureTextField *passwordTextField;
@property (weak) IBOutlet NSButton          *sendButton;
@property (weak) IBOutlet NSImageView       *gifImageView;

@end

@implementation ZKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setUI];


}
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
    
   
   //http://192.168.0.88:81/dologins?account=tanghm&password=123456
}

- (IBAction)loginAuthentication:(NSButton *)sender
{

    if (self.accountTextField.stringValue.length == 0)
    {
        return;
    }
    if (self.passwordTextField.stringValue.length == 0)
    {
        return;
    }
    
    [self.sendButton setTitle:@"正在登录"];
    [self.sendButton setTextColor:UIColorFromRGB(0x3CAFFE)];
    self.gifImageView.image = [NSImage imageNamed:@"homeThree_Gif.gif"];
}

@end
