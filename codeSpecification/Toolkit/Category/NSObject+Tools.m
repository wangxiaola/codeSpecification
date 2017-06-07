//
//  NSObject+Tools.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/7.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "NSObject+Tools.h"
#import <Cocoa/Cocoa.h>
@implementation NSObject (Tools)

+ (void)showErrorAlertTitle:(NSString *)name message:(NSString *)message buttonTitle:(NSString *)buttonTitle;
{

    //产生错误信息
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(name, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The operation timed out.", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(message, nil)
                               };
    NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                         code:2
                                     userInfo:userInfo];
    
    NSAlert *alert = [NSAlert alertWithError:error];
    [alert addButtonWithTitle:buttonTitle];
    [alert runModal];

}
@end
