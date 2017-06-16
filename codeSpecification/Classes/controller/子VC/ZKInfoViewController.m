//
//  ZKInfoViewController.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKInfoViewController.h"

@interface ZKInfoViewController ()
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end

@implementation ZKInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    NSString *text = @"驼峰命名法\n * 类名所有单词首字母都要大写\n* 变量名第一个单词首字母小写\n* 方法名采用动宾结构,也就是'动词'+'名词'的形式;第一个单词首字母小写\n\n空格的使用方式\n* 声明变量时,指针符号*与变量名无间隔,与类名有一个空格间隔\n* 使用,, ;时, 与前方单词无间隔,后面加一个空格\n* 运算符=, ==, +, -, *, /, %, +=, -=, *=, /=, %=前后加空格\n\n方法的声明\n* 对象方法或者类方法的+, - 号后面加空格\n* 属性的声明,@property后面加空格\n\n常量的定义\n* 代码中尽量不要出现字符串或者数字, 因为后期维护时不方便.\n 习惯上通过把字符串, 数字声明为常量, 做到常量的统一管理.\n*常量定义的方式有以下两种:\n #define 宏定义\n static const 静态常量\n 不管声明哪种类型的常量,变量名都需要添加'k'开头,这样可以有效防止命名冲突问题\n\n代码分段#pragma mark -\n * 在代码中通常使用'#pragma mark - '来对代码进行分段,方便后期维护.\n\n成员变量的声明\n* 成员变量要使用'_'进行标示\n\n协议的使用\n* 协议的声明要跟’#import’关键词之间隔一行以上,否则没有代码提示";
    
    NSDictionary *dictAttr = @{NSForegroundColorAttributeName:[NSColor whiteColor]};
    NSAttributedString* attr = [[NSAttributedString alloc] initWithString:text attributes:dictAttr];

    [[self.textView textStorage] appendAttributedString:attr];
}

@end
