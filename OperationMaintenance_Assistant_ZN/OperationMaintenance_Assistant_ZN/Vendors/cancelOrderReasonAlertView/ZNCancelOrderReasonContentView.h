//
//  ZNCancelOrderReasonContentView.h
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/20.
//  Copyright © 2019年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZNCancelOrderReasonContentView : UIView


@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (copy, nonatomic) void(^SureCompletion)(BOOL sure, int index);

@property (nonatomic ,strong) NSArray *array;

@property (nonatomic ,assign) int selectedIndex;




@end

NS_ASSUME_NONNULL_END
