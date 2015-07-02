//
//  YQHKStore.m
//  OSE
//
//  Created by yyq on 15/7/2.
//  Copyright © 2015年 MobileNow. All rights reserved.
//

#import "YQHKStore.h"
#import <HealthKit/HealthKit.h>
@interface YQHKStore()

@property (nonatomic, strong)HKHealthStore *healthStore;

@end
@implementation YQHKStore
#pragma mark - 初始化方法
- (HKHealthStore *)healthStore{
    if (!_healthStore) {
        _healthStore = [[HKHealthStore alloc]init];
    }
    return _healthStore;
}

/**
 * 构造
 */
+ (instancetype)shareTool{
    YQHKStore *tool = [[YQHKStore alloc]init];
    return tool;
}

/**
 *  单例形式创建工具
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static YQHKStore *tool;
    if (tool == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            tool = [super allocWithZone:zone]; // block里面的代码只会运行一次
        });
    }
    return tool;
}
#pragma mark - 公共方法
/**请求计步器读取权限*/
- (void)requestAuthorization{

    NSSet *readTypes = [self getTypesToRead];
    NSSet *writeTypes = [self getTypesToWrite];
    [self.healthStore requestAuthorizationToShareTypes:writeTypes readTypes:readTypes completion:^(BOOL success, NSError * __nullable error) {
        if (!success) {
            NSLog(@"You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"已经获得权限");
        });
        
    }];
}

- (void)saveStepCount{
    NSString *stepCountID = HKQuantityTypeIdentifierStepCount;
    HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier:stepCountID];
    HKQuantity *stepCount = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:988000];
    
    HKQuantitySample *stepCountSample = [HKQuantitySample quantitySampleWithType:stepCountType quantity:stepCount startDate:[NSDate dateWithTimeIntervalSinceNow:-300] endDate:[NSDate date]];
    
    [self.healthStore saveObject:stepCountSample withCompletion:^(BOOL success, NSError * __nullable error) {
        if (success) {
            NSLog(@"保存成功");
        }else{
            NSLog(@"保存失败 ，error = %@",error);
        }
    }];
}

- (void)getStepCount{
    NSString *stepCountID = HKQuantityTypeIdentifierStepCount;
    HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier:stepCountID];

    HKStatisticsOptions sumoptions = HKStatisticsOptionCumulativeSum;
    
    //获得一天的数据
    HKStatisticsQuery *query;
    query = [[HKStatisticsQuery alloc]initWithQuantityType:stepCountType quantitySamplePredicate:nil options:sumoptions completionHandler:^(HKStatisticsQuery * __nonnull query, HKStatistics * __nullable result, NSError * __nullable error) {
        HKQuantity *sum = [result sumQuantity];
        NSLog(@"setps : %lf",[sum doubleValueForUnit:[HKUnit countUnit]]);
        if (error) {
            NSLog(@"获取步数失败，错误= %@",error);
        }
    }];
    [self.healthStore executeQuery:query];
    
    //获得某一时间段的数据
    
    NSDateComponents *stepDC = [[NSDateComponents alloc]init];
    stepDC.minute = 10;
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-3600*10];
    NSDate *endDate = [NSDate date];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    HKStatisticsCollectionQuery *collectionQuery ;
    collectionQuery = [[HKStatisticsCollectionQuery alloc]initWithQuantityType:stepCountType quantitySamplePredicate:predicate options:sumoptions anchorDate:startDate intervalComponents:stepDC];

    collectionQuery.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection * __nullable result, NSError * __nullable error){
        NSLog(@"result = %@， count = %i ",result,(int)result.statistics.count);

        [result enumerateStatisticsFromDate:startDate toDate:endDate withBlock:^(HKStatistics * __nonnull result, BOOL * __nonnull stop) {
            HKQuantity *sum = [result sumQuantity];
            NSLog(@"代码块：steps : %lf, date = %@",[sum doubleValueForUnit:[HKUnit countUnit]],result.startDate);
        }];
    };
    [self.healthStore executeQuery:collectionQuery];
}




#pragma mark - 私有事务方法

- (NSSet*)getTypesToRead{
    NSString *stepCountID = HKQuantityTypeIdentifierStepCount;
    HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier:stepCountID];
    return [NSSet setWithObjects:stepCountType, nil];
}
- (NSSet*)getTypesToWrite{
    NSString *stepCountID = HKQuantityTypeIdentifierStepCount;
    HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier:stepCountID];
    return [NSSet setWithObjects:stepCountType, nil];
}
@end
