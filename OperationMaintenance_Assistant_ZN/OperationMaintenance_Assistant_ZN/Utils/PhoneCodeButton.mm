//
//  PhoneCodeButton.m
//  CodingMart
//
//  Created by Ease on 15/12/15.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "PhoneCodeButton.h"

@interface PhoneCodeButton ()
@property (nonatomic, strong, readwrite) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval durationToValidity;
@property (strong, nonatomic) UIView *lineView;
@end

@implementation PhoneCodeButton

-(instancetype)init{

    self = [super init];
    
    if (self) {
        
//        _lineView = [[UIView alloc] initWithFrame:CGRectMake(-10, 5, 0.5, 25 - 2*5)];
//        _lineView.backgroundColor = [UIColor greenColor];
//        [self addSubview:_lineView];
        
        
        
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.enabled = YES;
        
//        _lineView = [[UIView alloc] initWithFrame:CGRectMake(-10, 5, 0.5, CGRectGetHeight(frame) - 2*5)];
//        _lineView.backgroundColor = [UIColor greenColor];
//        [self addSubview:_lineView];
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    UIColor *foreColor =  [UIColor whiteColor]; //enabled ? RedColor : [UIColor myColorWithHexString:@"#888888"];   //[UIColor colorWithHexString:enabled? @"0x3BBD79": @"0xCCCCCC"];
    [self setTitleColor:foreColor forState:UIControlStateNormal];
    if (enabled) {
        [self setTitle:@"重新发送" forState:UIControlStateNormal];
    }else if ([self.titleLabel.text isEqualToString:@"获取验证码"] || [self.titleLabel.text isEqualToString:@"重新发送"]){
        [self setTitle:@"正在发送..." forState:UIControlStateNormal];
    }
}

- (void)startUpTimer{
    _durationToValidity = 60;
    self.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
    if (self.isEnabled) {
        self.enabled = NO;
    }
    [self setTitle:[NSString stringWithFormat:@"重新发送(%.0f秒)", _durationToValidity] forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(redrawTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)invalidateTimer{
    if (!self.isEnabled) {
        self.enabled = YES;
    }
    [self.timer invalidate];
    self.timer = nil;
    self.backgroundColor = [UIColor colorWithRed:247/255.0 green:101/255.0 blue:1/255.0 alpha:1.0];

}

- (void)redrawTimer:(NSTimer *)timer {
    _durationToValidity--;
    if (_durationToValidity > 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"重新发送(%.0f秒)", _durationToValidity];//防止 button_title 闪烁
        [self setTitle:[NSString stringWithFormat:@"重新发送(%.0f秒)", _durationToValidity] forState:UIControlStateNormal];
    }else{
        [self invalidateTimer];
    }
}

@end
