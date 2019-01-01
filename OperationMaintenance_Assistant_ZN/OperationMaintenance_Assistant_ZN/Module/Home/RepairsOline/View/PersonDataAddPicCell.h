//
//  PersonDataAddPicCell.h
//  YunDiPiano_Teacher
//
//  Created by apple on 2017/11/9.
//  Copyright © 2017年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define kCellIdentifier_PersonDataAddPicCell @"PersonDataAddPicCell"


@interface PersonDataAddPicCell : UIView <UICollectionViewDataSource, UICollectionViewDelegate>


- (void)setDataArray:(NSArray *)array isLoading:(BOOL)isLoading;

@property (copy, nonatomic) void(^addPicturesBlock)();
@property (copy, nonatomic) void (^deleteTweetImageBlock)(int toDelete);

+ (CGFloat)cellHeightWithObj:(NSInteger)obj;

@end
