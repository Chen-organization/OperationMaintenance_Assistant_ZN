//
//  toTheSceneAddPhotoView.h
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/14.
//  Copyright © 2019年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface toTheSceneAddPhotoView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>


- (void)setDataArray:(NSArray *)array isLoading:(BOOL)isLoading;

@property (copy, nonatomic) void(^addPicturesBlock)();
@property (copy, nonatomic) void (^deleteTweetImageBlock)(int toDelete);

+ (CGFloat)cellHeightWithObj:(NSInteger)obj;


@end

NS_ASSUME_NONNULL_END
