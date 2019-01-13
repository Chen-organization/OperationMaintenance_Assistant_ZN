//
//  personDataAddPicCollectionCell.m
//  YunDiPiano_Teacher
//
//  Created by Apple on 2018/3/22.
//  Copyright © 2018年 Chen. All rights reserved.
//


#import "personDataAddPicCollectionCell.h"

#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface personDataAddPicCollectionCell ()

@property (nonatomic,strong) CAShapeLayer *progressShapLayer;

@property (nonatomic,strong) CAShapeLayer *dashedLineLayer;

@property (nonatomic,weak) UILabel *tipL;


@end

@implementation personDataAddPicCollectionCell



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.contentView.backgroundColor = [UIColor blueColor];
//
//        self.imgView.backgroundColor = [UIColor yellowColor];
        
//        CAShapeLayer *add = [CAShapeLayer layer];
//        add.strokeColor =  [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0].CGColor;
//        UIBezierPath *addpath = [UIBezierPath bezierPath];
//        [addpath moveToPoint:CGPointMake(Cell_Width / 2.0, Cell_Height / 2.0 - 15)];
//        [addpath addLineToPoint:CGPointMake(Cell_Width / 2.0, Cell_Height / 2.0 + 15)];
//
//        [addpath moveToPoint:CGPointMake(Cell_Width / 2.0 - 15, Cell_Height / 2.0)];
//        [addpath addLineToPoint:CGPointMake(Cell_Width / 2.0 + 15, Cell_Height / 2.0)];
//        add.path = addpath.CGPath;
//        add.lineWidth = 1.f;
//        [self.contentView.layer addSublayer:add];
//
//
//
//        CAShapeLayer *border = [CAShapeLayer layer];
//        self.dashedLineLayer = border;
//        border.strokeColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0].CGColor;
//        border.fillColor = [UIColor clearColor].CGColor;
//        border.path = [UIBezierPath bezierPathWithRect:self.imgView.frame].CGPath;
//        border.lineWidth = 1.f;
//        border.lineDashPattern = @[@5, @3];
//        [self.contentView.layer addSublayer:border];

        
        UIImageView *placeHolderImg = [[UIImageView alloc] init];
        placeHolderImg.contentMode = UIViewContentModeScaleAspectFill;
        placeHolderImg.clipsToBounds = YES;
        placeHolderImg.image = [UIImage imageNamed:@"拍照"];
        [self.contentView addSubview:placeHolderImg];
        
        [placeHolderImg mas_makeConstraints:^(MASConstraintMaker *make) {

            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 5, 5, 5));

        }];
        
//        UILabel *tipL = [[UILabel alloc]init];
//        self.tipL = tipL;
//        tipL.font = [UIFont systemFontOfSize:11];
//        tipL.text = @"上传中...";
//        tipL.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0].CGColor;
//        [self.contentView addSubview:tipL];
//        [tipL mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(self.imgView.mas_bottom).offset(0);
//            make.centerX.equalTo(self.imgView);
//            make.height.mas_equalTo(40);
//        }];
//        
//        
//        CAShapeLayer *progress = [CAShapeLayer layer];
//        self.progressShapLayer = progress;
//        progress.strokeColor = RGBCOLOR(215, 49, 53).CGColor;
//        progress.fillColor = [UIColor clearColor].CGColor;
//        progress.path = [UIBezierPath bezierPathWithRect:self.imgView.frame].CGPath;
//        progress.lineWidth = 2.f;
//        progress.strokeStart = 0;
//        progress.strokeEnd = 0;
//        [self.contentView.layer addSublayer:progress];
        
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (void)setCurTweetImg:(UIImage *)curTweetImg{
    
    _curTweetImg = curTweetImg;
    
    if (_curTweetImg) {

        self.deleteBtn.hidden = NO;
        self.dashedLineLayer.hidden = YES;
        
        self.imgView.image = curTweetImg;
        
//        [self.imgView sd_setImageWithURL:[NSURL URLWithString:curTweetImg] placeholderImage:[UIImage imageNamed:@"headImage"]];
        
    }else{
        self.imgView.image = [UIImage imageNamed:@""];
        self.deleteBtn.hidden = YES;
        
        self.progressShapLayer.hidden = YES;
        self.dashedLineLayer.hidden = NO;
    }
}
- (void)deleteBtnClicked:(id)sender{
    if (_deleteTweetImageBlock) {
        _deleteTweetImageBlock(_curTweetImg);
    }
}
+(CGSize)ccellSize{
    return CGSizeMake(Cell_Width, Cell_Height);
}

- (void)startAnimation{
    
    self.progressShapLayer.hidden = NO;
    self.progressShapLayer.strokeEnd = 0;
    
    self.tipL.text = @"上传中...";
    
    [CATransaction begin];
    
     //显式事务默认开启动画效果,kCFBooleanTrue关闭
     [CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
     //动画执行时间
     [CATransaction setValue:[NSNumber numberWithFloat:10.0f] forKey:kCATransactionAnimationDuration];

     //[CATransaction setAnimationDuration:[NSNumber numberWithFloat:5.0f]];
    self.progressShapLayer.strokeEnd = 0.9;
    [CATransaction commit];
    
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    animation.fromValue = @0;
//    animation.toValue = @0.8;
//    animation.duration = 2;
//    animation.removedOnCompletion = NO;
//    [self.progressShapLayer addAnimation:animation forKey:@"strokeEnd"];
//
//    [UIView animateWithDuration:5 delay:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
//
//        self.progressShapLayer.strokeEnd = 0.9;
//    } completion:^(BOOL finished) {
//
//    }];
    
//    [UIView animateWithDuration:5 animations:^{
//
//        self.progressShapLayer.strokeEnd = 0.9;
//    } completion:^(BOOL finished) {
//
//    }];
//
}

- (void)stopAnimation{
    
    self.progressShapLayer.hidden = YES;
    
    self.tipL.text = @"上传完成";
    
}


- (UIImageView *)imgView{
    
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        //        _imgView.layer.masksToBounds = YES;
        //        _imgView.layer.cornerRadius = 2.0;
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
    }
    
    return _imgView;
    
}

- (UIButton *)deleteBtn{
    
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"pic_deletel"] forState:UIControlStateNormal];
//        _deleteBtn.backgroundColor = [UIColor blackColor];
        _deleteBtn.layer.cornerRadius = CGRectGetWidth(_deleteBtn.bounds)/2;
        _deleteBtn.layer.masksToBounds = YES;
        
        //            _deleteBtn.backgroundColor = [UIColor blueColor];
        
        [_deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.right.equalTo(self.contentView).offset(0);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
    }
    return _deleteBtn;
}

@end
