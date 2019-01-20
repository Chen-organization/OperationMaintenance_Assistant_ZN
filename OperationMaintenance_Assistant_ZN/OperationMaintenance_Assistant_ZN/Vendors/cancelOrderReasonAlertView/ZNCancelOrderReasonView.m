//
//  ZNCancelOrderReasonView.m
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/20.
//  Copyright © 2019年 Chen. All rights reserved.
//

#import "ZNCancelOrderReasonView.h"
#import "ZNCancelOrderReasonContentView.h"

@interface ZNCancelOrderReasonView ()

@property (copy, nonatomic) void(^completion)(BOOL sure , int selectIndex);
@property (nonatomic,strong) ZNCancelOrderReasonContentView *alertView;

@end


@implementation ZNCancelOrderReasonView



+ (instancetype)shareManager{
    static ZNCancelOrderReasonView *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}


+ (instancetype)handleTip:(NSString *)contentArray isShowCancelBtn:(BOOL)isShow completion:(void(^)(BOOL sure , int selectIndex))block{

    ZNCancelOrderReasonView *manager = [self shareManager];
    
    manager.completion = block;
    //    [manager p_setupWithTipStr:content animate:NO];
    [manager p_show];
    manager.alertView.array = [contentArray componentsSeparatedByString:@","];
    manager.alertView.cancelBtn.hidden = !isShow;
    __weak typeof(manager) weakManager = manager;
    
    manager.alertView.SureCompletion = ^(BOOL sure, int index) {
        
        manager.completion(sure, index);
        [weakManager p_dismiss];
        
    };
    
//    manager.alertView.SureCompletion = ^(BOOL sure) {
//
//
//    };
    
    return manager;
    
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _alertView = [[[NSBundle mainBundle]loadNibNamed:@"ZNCancelOrderReasonContentView" owner:self options:nil]objectAtIndex:0];
        
        
    }
    return self;
}

- (void)p_show{
    //初始状态
    _alertView.backgroundColor = [UIColor clearColor];
    _alertView.contentView.alpha = 0;
    _alertView.frame = [UIScreen mainScreen].bounds;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
    [UIView animateWithDuration:0.3 animations:^{
        _alertView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
        _alertView.contentView.alpha = 1;
    } completion:^(BOOL finished) {
        
        
    }];
}

+ (void)dismiss{
    
    ZNCancelOrderReasonView *manager = [self shareManager];
    [manager p_dismiss];
}


- (void)p_dismiss{
    //    _curTweet = nil;
    _completion = nil;
    [UIView animateWithDuration:0.3 animations:^{
        _alertView.backgroundColor = [UIColor clearColor];
        _alertView.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [_alertView removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
