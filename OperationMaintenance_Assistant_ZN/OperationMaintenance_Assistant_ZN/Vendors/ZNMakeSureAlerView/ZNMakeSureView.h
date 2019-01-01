//
//  ZNMakeSureView.h
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/1.
//  Copyright © 2019年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZNMakeSureView : NSObject

+ (instancetype)handleTip:(NSString *)content isShowCancelBtn:(BOOL)isShow completion:(void(^)(BOOL sure))block;


+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
