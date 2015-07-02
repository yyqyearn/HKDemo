//
//  YQHKStore.h
//  OSE
//
//  Created by yyq on 15/7/2.
//  Copyright © 2015年 MobileNow. All rights reserved.
//



#import <Foundation/Foundation.h>
typedef void(^Completion)(NSArray *resultModelArray);

typedef void(^Faild)(NSError *error);


@interface YQHKStoreTool : NSObject
/**
 * 单例构造
 */
+ (instancetype)shareTool;

/**
 * 请求权限
 */
- (void)requestAuthorization;





- (void)saveStepCount;
- (void)getStepCountWithStartDate:(NSDate*)startDate EndDate:(NSDate*)endDate PerMinutes:(NSInteger)perMinutes Completion:(Completion)completion Faild:(Faild)faild;
@end


@interface YQStepCountModel : NSObject
@property (assign, nonatomic) float stepCount;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@end