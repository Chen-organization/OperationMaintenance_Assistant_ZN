//
//  PopSignatureView.m
//  EsayHandwritingSignature
//
//  Created by Liangk on 2017/11/9.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "PopSignatureView.h"
#import "EasySignatureView.h"
#import "Masonry.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width  //  设备的宽度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height //   设备的高度
#define RGB(__R, __G, __B) [UIColor colorWithRed:(__R) / 255.0f green:(__G) / 255.0f blue:(__B) / 255.0f alpha:1.0]
#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithRed:106/255.00f green:106/255.00f blue:106/255.00f alpha:0.8]

#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]

#define SignatureViewHeight ((ScreenWidth*(350))/(375))

@interface PopSignatureView () <SignatureViewDelegate> {
    UIView* _mainView;
    UIButton* _maskView;
    EasySignatureView *signatureView;
    UIButton *btn3;
}

@property (nonatomic,strong) UIView *backGroundView;

@end

@implementation PopSignatureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
//        self.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        
        
        [self setupView];
        
    }
    return self;
}
- (id)initWithMainView:(UIView*)mainView
{
    self = [super init];
    if(self)
    {
        self.userInteractionEnabled = YES;
        _mainView = mainView;
        [self setupView];
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}


- (void)setupView
{
    //蒙板背景
    _maskView = [UIButton buttonWithType:UIButtonTypeCustom];
    _maskView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _maskView.userInteractionEnabled = YES;
    [_maskView addTarget:self action:@selector(onTapMaskView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //背景
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    self.backGroundView.userInteractionEnabled = YES;
    [_maskView addSubview:self.backGroundView];
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(_maskView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UILabel *headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.textAlignment = NSTextAlignmentCenter;
    headView.textColor = [UIColor colorWithRed:0.3258 green:0.3258 blue:0.3258 alpha:1.0];
    headView.font = [UIFont systemFontOfSize:15];
    UIView *sepView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, 1)];
    sepView1.backgroundColor = RGB(238, 238, 238);
    [self.backGroundView addSubview:sepView1];
    headView.text = @"";
    [self.backGroundView addSubview:headView];
    
    signatureView = [[EasySignatureView alloc] initWithFrame:CGRectMake(0,46, ScreenWidth, SignatureViewHeight - 44 - 44)];
    signatureView.backgroundColor = [UIColor whiteColor];
    signatureView.delegate =self;
    signatureView.showMessage =@"";
    [self.backGroundView addSubview:signatureView];
    [signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.backGroundView).offset(0);
        make.bottom.equalTo(self.backGroundView).offset(50);
    }];
    
    CGFloat btnW = ScreenWidth / 2.0 - 40;
    
    CGFloat btnH = 30;
    
    UIButton *OKBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 50, 0, 44, 44)];
    [OKBtn setTitle:@"重签" forState:UIControlStateNormal];
    [OKBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    OKBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [OKBtn addTarget:self action:@selector(onClear) forControlEvents:UIControlEventTouchUpInside];
    [OKBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    OKBtn.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:112.0/255.0 blue:43.0/255.0 alpha:1.0];
    OKBtn.layer.cornerRadius = 3;
    [self.backGroundView addSubview:OKBtn];
    [OKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake( btnW, btnH));
        make.left.equalTo(self.backGroundView).offset(20);
        make.bottom.equalTo(self.backGroundView).offset(-10);
    }];
    
    
//    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, 0, 44, 44)];
//    [cancelBtn setTitle:@"签名" forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [cancelBtn setTitleColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0]forState:UIControlStateNormal];
//    [self.backGroundView addSubview:cancelBtn];

    
    btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, SignatureViewHeight-44, ScreenWidth, 44)];
    [btn3 setTitle:@"确定" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn3 addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    btn3.backgroundColor = [UIColor colorWithRed:31.0/255 green:181.0/255 blue:171.0/255 alpha:1.0];
    btn3.layer.cornerRadius = 3;
    [self.backGroundView addSubview:btn3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake( btnW, btnH));
        make.right.equalTo(self.backGroundView).offset(-20);
        make.bottom.equalTo(self.backGroundView).offset(-10);
    }];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-SignatureViewHeight, [UIScreen mainScreen].bounds.size.width, SignatureViewHeight)];
//    } completion:^(BOOL finished) {
//    }];
}

- (void)cancelAction {
//    [self hide];
}

//- (void)show {
//    [UIView animateWithDuration:0.5 animations:^{
//        UIWindow* window = [UIApplication sharedApplication].keyWindow;
//        [window addSubview:self];
//    }];
//}

- (void)onSignatureWriteAction {
    [btn3 setTitleColor:[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0] forState:UIControlStateNormal];
}

//- (void)hide {
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, SignatureViewHeight)];
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
//}


- (void)onTapMaskView:(id)sender {
//    [self hide];
}


//清除
- (void)onClear {
    [signatureView clear];
    [btn3 setTitleColor:[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.5] forState:UIControlStateNormal];
}


- (void)okAction
{
     [signatureView sure];
    if(signatureView.SignatureImg)
    {
        NSLog(@"haveImage");
//        self.hidden = YES;
//        [self hide];
        if (self.delegate != nil &&[self.delegate respondsToSelector:@selector(onSubmitBtn:)]) {
            [self.delegate onSubmitBtn:signatureView.SignatureImg];
        }
    }
    else
    {
        NSLog(@"NoImage");
    }

}


@end
