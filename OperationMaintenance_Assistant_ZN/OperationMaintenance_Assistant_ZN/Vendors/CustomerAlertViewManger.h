//
//  CustomerAlertViewManger.h
//  FengYunDiYin_Student
//
//  Created by Chen on 16/8/5.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerAlertViewManger : NSObject



+ (instancetype)handleVerson:(NSString *)verson Tip:(NSString *)content completion:(void(^)(NSString *curTweet, BOOL sendSucess))block;


+ (void)dismiss;


@end
