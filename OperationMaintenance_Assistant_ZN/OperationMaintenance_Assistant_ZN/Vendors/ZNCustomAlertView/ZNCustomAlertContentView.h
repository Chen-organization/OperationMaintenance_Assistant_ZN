//
//  ZNCustomAlertContentView.h
//  MonitoringAssistant_ZN
//
//  Created by Apple on 2018/4/3.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNCustomAlertContentView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (copy, nonatomic) void(^SureCompletion)(BOOL sure);

@end
