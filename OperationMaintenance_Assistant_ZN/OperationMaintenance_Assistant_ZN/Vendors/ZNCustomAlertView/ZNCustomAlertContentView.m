//
//  ZNCustomAlertContentView.m
//  MonitoringAssistant_ZN
//
//  Created by Apple on 2018/4/3.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

#import "ZNCustomAlertContentView.h"

@interface ZNCustomAlertContentView ()


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;



@end

@implementation ZNCustomAlertContentView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self.sureBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
    [self.cancelBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]] forState:UIControlStateHighlighted];

}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    
    if (self.SureCompletion) {
        
        self.SureCompletion(false);
    }
}

- (IBAction)sureBtnClick:(UIButton *)sender {
    
    if (self.SureCompletion) {
        
        self.SureCompletion(true);
    }
}

- (UIImage *)imageWithColor:(UIColor *)color

{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    return image;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
