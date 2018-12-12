//
//  CustomerAlertViewManger.m
//  FengYunDiYin_Student
//
//  Created by Chen on 16/8/5.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "CustomerAlertViewManger.h"
#import <UIKit/UIKit.h>
#import "Masonry.h"
//#import "UIView+BlocksKit.h"

@interface CustomerAlertViewManger () <UITextViewDelegate>

//@property (strong, nonatomic) Tweet *curTweet;
@property (copy, nonatomic) void(^completion)(NSString *curTweet, BOOL sendSucess);
@property (strong, nonatomic) NSString *tipStr;


@property (strong, nonatomic) UIView *bgView, *contentView;
//@property (strong, nonatomic) UIImageView *userImgV;
@property (strong, nonatomic) UIButton *closeBtn, *submitBtn, *tipBgView;
@property (strong, nonatomic) UILabel *titleL, *tipL/*, *bottomL*/;
@property (strong, nonatomic) UITextView *bottomTextView;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) BOOL isSubmitting;


@end

@implementation CustomerAlertViewManger

+ (instancetype)shareManager{
    static CustomerAlertViewManger *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}


+ (instancetype)handleVerson:(NSString *)verson Tip:(NSString *)content completion:(void(^)(NSString *curTweet, BOOL sendSucess))block{


    CustomerAlertViewManger *manager = [self shareManager];
//    if (manager.curTweet) {//还有未处理完的冒泡，此次调用无效
//        return nil;
//    }
    
//    NSString *tipStr = nil;
//    User *loginUser = [Login curLoginUser];
//    if (curTweet.rewarded.boolValue) {
//        tipStr = @"您已经打赏过了";
//    }else if ([curTweet.owner.global_key isEqualToString:loginUser.global_key]){
//        tipStr = @"不可以打赏自己哟";
//    }else if (loginUser.points_left.floatValue < 0.01){
//        tipStr = @"您的余额不足";
//    }
//    if (tipStr.length > 0) {
//        [NSObject showHudTipStr:tipStr];
//        return nil;
//    }else{
        manager.completion = block;
        [manager p_setupWithTipStr:verson animate:NO];
        [manager p_show:content];
        manager.titleL.text = verson;

        return manager;
//    }

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat buttonHeight = 44;
        CGFloat userIconWidth = 100;
        //层级关系
        _bgView = [UIView new];
        _contentView = [UIView new];
        _closeBtn = [UIButton new];
        _titleL = [UILabel new];
//        _userImgV = [UIImageView new];
//        _userImgV.image = [UIImage imageNamed:@"logo"];
//        _userImgV.contentMode = UIViewContentModeScaleAspectFill;
        
        [_closeBtn setTitle:@"稍后再说" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor colorWithRed:71/255.0 green:143/255.0 blue:183/255.0 alpha:1.0] forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_closeBtn addTarget:self action:@selector(p_dismiss) forControlEvents:UIControlEventTouchUpInside];
//        [_closeBtn.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:_submitBtn.titleLabel.font.pointSize]];
        
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_submitBtn setTitle:@"立即下载" forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        _submitBtn.layer.borderWidth = 1;
//        [_submitBtn setAdjustsImageWhenHighlighted:NO];
        [_submitBtn setTitleColor:[UIColor colorWithRed:71/255.0 green:143/255.0 blue:183/255.0 alpha:1.0] forState:UIControlStateNormal];
//        [_submitBtn.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:_submitBtn.titleLabel.font.pointSize]];
        
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        _bottomTextView = [UITextView new];
        _tipBgView = [UIButton new];
        [_tipBgView addTarget:self action:@selector(errorTapped) forControlEvents:UIControlEventTouchUpInside];
        _tipL = [UILabel new];
        [_contentView addSubview:_closeBtn];
//        [_contentView addSubview:_userImgV];
        [_contentView addSubview:_titleL];
        [_contentView addSubview:_submitBtn];
        [_contentView addSubview:_activityIndicator];
        [_contentView addSubview:_bottomTextView];
        [_contentView addSubview:_tipBgView];
        [_contentView addSubview:_tipL];
        [_bgView addSubview:_contentView];
        
        //属性设置
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 6;
       
//        _userImgV.layer.masksToBounds = YES;
//        _userImgV.layer.cornerRadius = userIconWidth/2;
        _titleL.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont boldSystemFontOfSize:16];
 
        _bottomTextView.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _bottomTextView.editable = NO;
        _bottomTextView.delegate = self;
//        _bottomL.textAlignment = NSTextAlignmentCenter;
//        _tipBgView.backgroundColor = [UIColor colorWithHexString:@"0xF2DEDE"];
//        _tipBgView.layer.masksToBounds = YES;
//        _tipBgView.layer.cornerRadius = 3;
//        _tipL.font = [UIFont systemFontOfSize:15];
//        _tipL.textColor = [UIColor colorWithHexString:@"0xC55351"];
//        _tipL.textAlignment = NSTextAlignmentCenter;
//        _tipL.numberOfLines = 0;
        
        //位置大小
        //align top

//        [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_contentView).offset(20);
//            make.centerX.equalTo(_contentView);
//            make.height.width.mas_equalTo(userIconWidth);
//        }];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentView);
            make.top.equalTo(self.contentView).offset(15);
        }];
        //align bottom
        [_bottomTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView).offset(20);
            make.right.equalTo(_contentView).offset(-20);
            make.top.equalTo(_titleL.mas_bottom).offset(15);
            make.bottom.equalTo(_contentView).offset(-(buttonHeight+15));
        }];
//        [_tipBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(_bottomL.mas_top).offset(-15);
//            make.left.equalTo(_contentView).offset(25);
//            make.right.equalTo(_contentView).offset(-25);
//            make.height.mas_equalTo(60);
//        }];
//        [_tipL mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(_tipBgView).insets(UIEdgeInsetsMake(10, 15, 10, 15));
//        }];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_contentView);
            make.height.mas_equalTo(buttonHeight);
            make.width.mas_equalTo((UIScreen.mainScreen.bounds.size.width - 80)/2.0);
        }];
        [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_contentView).offset(0);
            make.right.equalTo(_contentView).offset(0);
            make.height.mas_equalTo(buttonHeight);
            make.width.mas_equalTo((UIScreen.mainScreen.bounds.size.width - 80)/2.0);
        }];
//        [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(_submitBtn);
//        }];
        
        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        [_contentView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentView).offset(0);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(_contentView).offset(-buttonHeight);
        }];
        
        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor =  [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        [_contentView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1).offset(0);
            make.centerX.equalTo(_contentView);
            make.width.mas_equalTo(0.5);
            make.bottom.equalTo(_contentView).offset(0);
        }];
        
        
        
        //关联事件 密码
//        [_passwordF.rac_textSignal subscribeNext:^(NSString *password) {
//            if (_isNeedPassword) {
//                self.submitBtn.enabled = password.length > 0;
//            }
//        }];
//        [_bgView bk_whenTapped:^{//在不需要密码的时候，tap 就消失
//
//            [self p_dismiss];
//
//        }];
    }
    return self;
}



//- (void)setCurTweet:(Tweet *)curTweet{
////    _curTweet = curTweet;
//    
//    CGFloat userIconWidthDesgin = 50.0;
//    [_userImgV sd_setImageWithURL:[_curTweet.owner.avatar urlImageWithCodePathResize:userIconWidthDesgin * [UIScreen mainScreen].scale crop:NO] placeholderImage:kPlaceholderMonkeyRoundWidth(userIconWidthDesgin)];
//}

- (void)setIsSubmitting:(BOOL)isSubmitting{
    _isSubmitting = isSubmitting;
    if (_isSubmitting) {
        _submitBtn.enabled = NO;
        [_activityIndicator startAnimating];
    }else{
        [_activityIndicator stopAnimating];
        _submitBtn.enabled = YES;
    }
}

- (void)submitBtnClicked{
    
    self.isSubmitting = YES;
    self.isSubmitting = NO;
    
    NSLog(@"按钮点击了");
    
    self.completion(@"成功", YES);
    
    [self p_dismiss];

    
    
}

- (void)errorTapped{

    [self p_dismiss];
}

- (void)p_setupWithTipStr:(NSString *)tipStr  animate:(BOOL)animate{
//    _tipStr = tipStr;
//
//    BOOL hasTip = _tipStr.length > 0;
//    _tipL.text = _tipStr; //[_tipStr stringByRemoveHtmlTag];
//    _tipBgView.hidden = !hasTip;
//    _tipL.hidden = !hasTip;
//    _submitBtn.hidden = hasTip;
    
    CGFloat contentHeight = 320 + (50 - 50);
    
#pragma  mark -------   动态高的话需要计算  ---------
    
    CGFloat contentY = (UIScreen.mainScreen.bounds.size.height - contentHeight)/2;
    
    CGRect contentFrame = CGRectMake(20, contentY, UIScreen.mainScreen.bounds.size.width - 40, contentHeight);
    if (animate) {
        [UIView animateWithDuration:0.3 animations:^{
            _contentView.frame = contentFrame;
        } completion:^(BOOL finished) {
            
            
        }];
    }else{
        _contentView.frame = contentFrame;
    }
}

    - (void)p_show:(NSString *)text{
    //初始状态
    _bgView.backgroundColor = [UIColor clearColor];
    _contentView.alpha = 0;
    _submitBtn.enabled = YES;
    _bgView.frame = [UIScreen mainScreen].bounds;
        
        if (text == nil) {
            
            text = @"";
        }
    
//    _bottomL.text = @"中能云管家新版本来了，内容更丰富，方便实用，马上体验。";
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7;// 字体的行间距
        
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:12],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        _bottomTextView.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        
        
        
//    @weakify(self);
//    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/account/points" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
//        @strongify(self);
//        if (data) {
//            [Login curLoginUser].points_left = data[@"data"][@"points_left"];
//            self.bottomL.attributedText = [self p_bottomStr];
//        }
//    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
        _contentView.alpha = 1;
    } completion:^(BOOL finished) {
        
        
    }];
}

+ (void)dismiss{
    
    CustomerAlertViewManger *manager = [self shareManager];
    [manager p_dismiss];
}


- (void)p_dismiss{
//    _curTweet = nil;
    _completion = nil;
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.backgroundColor = [UIColor clearColor];
        _contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
    }];
}

//- (void)p_sucessDone{
////    User *loginUser = [Login curLoginUser];
////    loginUser.points_left = @(loginUser.points_left.floatValue - 0.01);
////    
////    _curTweet.rewarded = @(YES);
////    _curTweet.rewards = @(_curTweet.rewards.integerValue +1);
////    if (_curTweet.reward_users.count > 0) {
////        [_curTweet.reward_users insertObject:[Login curLoginUser] atIndex:0];
////    }else{
////        _curTweet.reward_users = @[[Login curLoginUser]].mutableCopy;
////    }
////    if (self.completion) {
//        self.completion(@"成功", YES);
////    }
//    [self p_dismiss];
//}

//- (void)p_handleError:(NSError *)error{
//    NSDictionary *userInfo = error.userInfo;
//    NSArray *errorKeyList = [userInfo[@"msg"] allKeys];
//    NSString *errorMsg = userInfo[@"msg"][errorKeyList.firstObject];
//    if ([errorKeyList containsObject:@"password_error"]) {
//
//        [self p_setupWithTipStr:nil isNeedPassword:YES animate:YES];
//        
//        if (errorMsg.length > 0) {
////            [NSObject showHudTipStr:errorMsg];
//        }
//    }else{
//        if (errorMsg.length > 0) {
//            [self p_setupWithTipStr:errorMsg isNeedPassword:_isNeedPassword animate:YES];
//        }
//    }
//}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
    {
        return NO;
    }

@end
