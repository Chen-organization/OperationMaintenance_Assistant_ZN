//
//  ZNCustomAlertView.h
//  MonitoringAssistant_ZN
//
//  Created by Apple on 2018/4/3.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNCustomAlertView : NSObject



+ (instancetype)handleTip:(NSString *)content isShowCancelBtn:(BOOL)isShow completion:(void(^)(BOOL sure))block;


+ (void)dismiss;


@end
