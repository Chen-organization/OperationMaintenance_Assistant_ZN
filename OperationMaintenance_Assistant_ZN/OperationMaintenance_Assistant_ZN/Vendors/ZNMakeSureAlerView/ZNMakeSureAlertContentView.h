//
//  ZNMakeSureAlertContentView.h
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/1.
//  Copyright © 2019年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZNMakeSureAlertContentView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (copy, nonatomic) void(^SureCompletion)(BOOL sure);

@end

NS_ASSUME_NONNULL_END
