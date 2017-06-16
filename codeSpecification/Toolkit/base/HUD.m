//
//  HUD.m
//  codeSpecification
//
//  Created by 王小腊 on 2017/6/8.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "HUD.h"
#import "DJProgressHUD.h"

@implementation HUD
+ (void)showMessenger:(NSString *)messenger fromView:(NSView*)view dismiss:(void(^)())end;
{
    [DJProgressHUD dismiss];
    DJProgressHUD *hud = [DJProgressHUD instance];
    hud.indicatorSize = CGSizeZero;
    [DJProgressHUD showStatus:messenger FromView:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [DJProgressHUD dismiss];
        if (end)
        {
            end();
        }
    });
    
}
+ (void)showStatus:(NSString *)status fromView:(NSView*)view;
{
    [DJProgressHUD showStatus:status FromView:view];
}
+ (void)dismiss;
{
    [DJProgressHUD dismiss];
}
@end
