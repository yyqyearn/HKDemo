//
//  YQHKStore.m
//  OSE
//
//  Created by yyq on 15/7/2.
//  Copyright © 2015年 MobileNow. All rights reserved.
//

#import "YQHKStoreTool.h"
#import <HealthKit/HealthKit.h>
#import "NSDate+Calendar.h"
@interface YQHKStoreTool()

@property (nonatomic, strong)HKHealthStore *healthStore;

/** 定时器用于每10秒更新步数 */
@property (nonatomic, strong) NSTimer *timer;

@end
@implementation YQHKStoreTool
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
    YQHKStoreTool *tool = [[YQHKStoreTool alloc]init];
    return tool;
}

/**
 *  单例形式创建工具
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static YQHKStoreTool *tool;
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
    
    //1.定义存取类型
    NSSet *readTypes = [self getTypesToRead];
    NSSet *writeTypes = [self getTypesToWrite];
    
    //2.向HealthKit发出请求
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

- (void)getStepCountWithStartDate:(NSDate*)startDate EndDate:(NSDate*)endDate PerMinutes:(NSInteger)perMinutes Completion:(Completion)completion Faild:(Faild)faild{
    NSString *stepCountID = HKQuantityTypeIdentifierStepCount;
    HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier:stepCountID];
    HKStatisticsOptions sumoptions = HKStatisticsOptionCumulativeSum;
    
    //获得某一时间段的数
    NSDateComponents *stepDC = [[NSDateComponents alloc]init];
    stepDC.minute = perMinutes;
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    HKStatisticsCollectionQuery *collectionQuery ;
    collectionQuery = [[HKStatisticsCollectionQuery alloc]initWithQuantityType:stepCountType quantitySamplePredicate:predicate options:sumoptions anchorDate:startDate intervalComponents:stepDC];
    
    collectionQuery.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection * __nullable result, NSError * __nullable error){
        //        NSLog(@"result = %@， count = %i ",result,(int)result.statistics.count);
        if (error) {
            faild(error);
            return ;
        }
        NSMutableArray *tempArray = [NSMutableArray array];
        
        
        [result enumerateStatisticsFromDate:startDate toDate:endDate withBlock:^(HKStatistics * __nonnull result, BOOL * __nonnull stop) {
            
            HKQuantity *sum = [result sumQuantity];
            
            YQStepCountModel *model = [[YQStepCountModel alloc]init];
            model.stepCount = [sum doubleValueForUnit:[HKUnit countUnit]];
            model.startDate = result.startDate;
            model.endDate = result.endDate;
            
            [tempArray addObject:model];
            NSLog(@"steps : %lf, date = %@",[sum doubleValueForUnit:[HKUnit countUnit]],result.startDate);
            
            NSLog(@"开始时间：= %@ ，最后时间：= %@",startDate,endDate);
            
            if ((endDate.day==result.startDate.day)&&(endDate.hour==result.startDate.hour)&&(endDate.minute==result.startDate.minute)) {
                *stop = YES;
            }
            
            if (*stop==YES) {
                NSArray *desArray = tempArray;
                completion(desArray);
            }
        }];
    };
    
    [self.healthStore executeQuery:collectionQuery];
}


- (void)getStepCountInSeconds:(NSInteger)seconds Completion:(CompletionGSCIS)completion Faild:(Faild)faild{
    
    
   
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
    return nil;
}
@end



@implementation YQStepCountModel
@end