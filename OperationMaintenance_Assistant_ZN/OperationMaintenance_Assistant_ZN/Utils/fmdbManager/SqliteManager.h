//
//  SqliteManager.h
//  YunDi_Student
//
//  Created by apple on 2017/6/7.
//  Copyright © 2017年 Fengyun Diyin Technologies (Beijing) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^completeBlock) (BOOL isSure);

typedef void (^completeWithQueryDicBlock) (BOOL isSure, NSDictionary *dic);


typedef void (^completeWithResultBlock) (BOOL isSure, NSArray *result);

@interface SqliteManager : NSObject

+ (instancetype)shareManager;

//下载字典表
- (void)saveDownloadAllMeterDics:(NSArray *)arr complete:(completeBlock)blcok;
//字典表查询
- (void)queryAllMeterDicsWithKey:(NSString *)key complete:(completeWithQueryDicBlock)bloack;



//保存抄表数据
- (void)saveMeterData:(NSDictionary *)dic;
//获取所有的抄表数据
- (void)getAllMeterReadingData:(NSArray *)dicArr;
//删除抄表数据
- (void)deleteOneMeterReadingData:(NSDictionary *)dic;



//- (void)insertNewHomeVideoListWithArray:(NSArray *)arr;
//- (NSArray *)cacheNewHomeVideoList;//:(IWRequestParameters *)parameters




@end
