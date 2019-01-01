//
//  personDataAddPicCollectionCell.h
//  YunDiPiano_Teacher
//
//  Created by Apple on 2018/3/22.
//  Copyright © 2018年 Chen. All rights reserved.
//

#define personDataAddPicCollectionCell_id @"personDataAddPicCollectionCell"


#define Cell_Width floorf(([UIScreen mainScreen].bounds.size.width - 45*2- 20)/3)
#define Cell_Height floorf(Cell_Width)


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface personDataAddPicCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UIImage *curTweetImg; //url
@property (copy, nonatomic) void (^deleteTweetImageBlock)(UIImage *toDelete);

- (void)startAnimation;
- (void)stopAnimation;


+(CGSize)ccellSize;

@end
