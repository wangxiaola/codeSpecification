//
//  NSButton+ButtonColor.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/7.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "NSButton+ButtonColor.h"

@implementation NSButton (ButtonColor)

- (void)setTextColor:(NSColor *)textColor
{
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc]
                                            initWithAttributedString:[self attributedTitle]];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    [attrTitle addAttribute:NSForegroundColorAttributeName
                      value:textColor
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    
//    // 创建段落样式，主要是为了设置居中
//    NSMutableParagraphStyle *pghStyle = [[NSMutableParagraphStyle alloc] init];
//    pghStyle.alignment = NSTextAlignmentCenter;
//    // 创建Attributes，设置颜色和段落样式
//    NSDictionary *dicAtt = @{NSForegroundColorAttributeName: [NSColor whiteColor], NSParagraphStyleAttributeName: pghStyle};
//    // 创建NSAttributedString赋值给NSButton的attributedTitle属性；必需从NSButton.attributedTitle创建，否则会有内存泄漏；
//    // 给NSButton先赋值一个字符串，为的是后面替换，如果NSButton的title是空字符串的话，也会内存泄漏
//
//    // 用NSButton.attributedTitle属性创建一个NSMutableAttributedString对象
//    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedTitle];
//    // 替换文字
//    [attTitle replaceCharactersInRange:NSMakeRange(0, 1) withString:@"解绑"];
//    // 添加属性
//    [attTitle addAttributes:dicAtt range:NSMakeRange(0, 2)];
//    // 赋值给NSButton.attributedTitle属性，不会再有内存泄漏
//    self.attributedTitle = attTitle;
    
}

@end
