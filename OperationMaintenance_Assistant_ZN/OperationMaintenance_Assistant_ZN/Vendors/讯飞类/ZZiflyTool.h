//
//  ZZiflyTool.h
//  语音识别
//
//  Created by 王夏军 on 16/5/20.
//  Copyright © 2016年 ZZBelieve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iflyMSC/iflyMSC.h"

/**
 *  回调
 */
typedef void (^RecognizerBlock)(IFlySpeechError *error,NSString *result);


@protocol iflyToolDeletage <NSObject>

- (void)speakRecognizerError:(IFlySpeechError *)error result:(NSString *)result;

@end


@interface ZZiflyTool : NSObject

+ (instancetype)shareTool;


//- (void)startRecognizer:(RecognizerBlock)block;
- (void)startRecognizer;


@property (nonatomic,weak) id<iflyToolDeletage> delegate;

@end
