//
//  ZNCancelOrderReasonView.h
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/20.
//  Copyright © 2019年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZNCancelOrderReasonView : UIView


+ (instancetype)handleTip:(NSString *)contentArray isShowCancelBtn:(BOOL)isShow completion:(void(^)(BOOL sure , int selectIndex))block;


+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
