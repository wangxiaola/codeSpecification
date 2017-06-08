//
//  NSObject+Tools.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/7.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "NSObject+Tools.h"
@implementation NSObject (Tools)

+ (void)showErrorWindowAlertTitle:(NSString *)name message:(NSString *)message buttonTitle:(NSString *)buttonTitle;
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


+ (void)showPromptAlertTitle:(NSString *)name message:(NSString *)message forWindow:(NSWindow *)window completionHandler:(void (^)(NSModalResponse returnCode))handler;
{
    //产生提示信息
    NSAlert *alert = [NSAlert new];
    [alert addButtonWithTitle:@"确定"];
    [alert addButtonWithTitle:@"取消"];
    [alert setMessageText:NSLocalizedString(name, nil)];
    [alert setInformativeText:NSLocalizedString(message, nil)];
    [alert setAlertStyle:NSAlertStyleWarning];
    
    [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode)
     {
         if (handler)
         {
             handler(returnCode);
         }
     }];
    
}
+ (void)showErrorAlertTitle:(NSString *)name message:(NSString *)message forWindow:(NSWindow *)window completionHandler:(void (^)(NSModalResponse returnCode))handler;
{
    //产生错误信息
    NSAlert *alert = [NSAlert new];
    [alert addButtonWithTitle:@"确定"];
    [alert setMessageText:NSLocalizedString(name, nil)];
    [alert setInformativeText:NSLocalizedString(message, nil)];
    [alert setAlertStyle:NSAlertStyleWarning];
    
    [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode)
     {
         if (handler)
         {
             handler(returnCode);
         }
     }];
}

@end
