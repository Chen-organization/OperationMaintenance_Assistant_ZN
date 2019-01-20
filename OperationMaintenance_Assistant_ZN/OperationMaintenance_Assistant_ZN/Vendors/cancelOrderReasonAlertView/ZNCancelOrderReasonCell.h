//
//  ZNCancelOrderReasonCell.h
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/20.
//  Copyright © 2019年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const ZNCancelOrderReasonCell_id = @"ZNCancelOrderReasonCell";

NS_ASSUME_NONNULL_BEGIN

@interface ZNCancelOrderReasonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (weak, nonatomic) IBOutlet UIImageView *selectImg;



@end

NS_ASSUME_NONNULL_END
