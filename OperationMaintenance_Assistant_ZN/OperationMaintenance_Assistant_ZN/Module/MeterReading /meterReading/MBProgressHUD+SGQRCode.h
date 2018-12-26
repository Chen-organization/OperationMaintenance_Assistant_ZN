//
//  MBProgressHUD+SGQRCode.h
//  MBProgressHUD+SGQRCode
//
//  Created by kingsic on 2015/7/13.
//  Copyright © 2015年 kingsic. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (SGQRCode)

/** MBProgressHUD修改后的样式 添加到self.navigationController.view上，导航栏不能被点击 */
+ (MBProgressHUD *)showMBProgressHUDWithModifyStyleMessage:(NSString *)message toView:(UIView *)view;
/** MBProgressHUD系统自带样式 添加到self.navigationController.view上，导航栏不能被点击 */
+ (MBProgressHUD *)showMBProgressHUDWithSystemComesStyleMessage:(NSString *)message toView:(UIView *)view;
/** 10s之后隐藏 */
+ (MBProgressHUD *)showMBProgressHUD10sHideWithModifyStyleMessage:(NSString *)message toView:(UIView *)view;

/** 显示加载成功的 MBProgressHUD */
+ (void)showMBProgressHUDOfSuccessMessage:(NSString *)message toView:(UIView *)view;

/** 显示加载失败的 MBProgressHUD */
+ (void)showMBProgressHUDOfErrorMessage:(NSString *)message toView:(UIView *)view;

/** 隐藏MBProgressHUD 要与添加的view保持一致 */
+ (void)hideHUDForView:(UIView *)view;

/** 只显示文字的 15 号字体（文字最好不要超过 14 个汉字） MBProgressHUD */
+ (void)showMBProgressHUDWithOnlyMessage:(NSString *)message delayTime:(CGFloat)time;

@end
