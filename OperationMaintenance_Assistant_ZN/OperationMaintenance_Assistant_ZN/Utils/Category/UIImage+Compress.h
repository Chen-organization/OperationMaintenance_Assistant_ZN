//
//  UIImage+Compress.h
//  MonitoringAssistant_ZN
//
//  Created by Apple on 2018/4/19.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)

-(NSData *)compressWithMaxLength:(NSUInteger)maxLength;

@end
