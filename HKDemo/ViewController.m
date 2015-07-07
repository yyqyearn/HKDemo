//
//  ViewController.m
//  HKDemo
//
//  Created by yyq on 15/7/2.
//  Copyright © 2015年 mobilenow. All rights reserved.
//

#import "ViewController.h"
#import "YQHKStoreTool.h"
#import "YQStaticView.h"
#import <CoreMotion/CoreMotion.h>
@interface ViewController ()
@property (nonatomic,weak) YQHKStoreTool *yqHKStore;

@property (weak, nonatomic) IBOutlet YQStaticView *staticView;

@property (weak, nonatomic) IBOutlet UILabel *stCountLB;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) CMPedometer *pedometer;

//@property (nonatomic, strong) CMStepCounter *stepCounter;

@end

@implementation ViewController
- (YQHKStoreTool *)yqHKStore
{
    if (!_yqHKStore) {
        _yqHKStore = [YQHKStoreTool shareTool];
    }
    return _yqHKStore;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupStepCounter];
//    [self setupTimer];
//    [self.staticView addLines];
}

- (void)setupTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateStepCount) userInfo:nil repeats:YES];
}
- (void)updateStepCount{
    [self.yqHKStore getStepCountInSeconds:60*2 Completion:^(YQStepCountModel *stepModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"步数= %lf , 开始时间 = %@ ，结束时间 = %@", stepModel.stepCount,stepModel.startDate,stepModel.endDate);
            self.stCountLB.text = [NSString stringWithFormat:@"%lf",stepModel.stepCount];
        });

    } Faild:^(NSError *error) {
        NSLog(@"获取步数错误 error = %@",error);
    }];
}


- (void)setupStepCounter{
    if ([CMPedometer isStepCountingAvailable]) {
        self.pedometer = [[CMPedometer alloc]init];
    }else{
        NSLog(@"不支持计步器");
        return;
    }
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-1000];
    [self.pedometer startPedometerUpdatesFromDate:startDate withHandler:^(CMPedometerData * __nullable pedometerData, NSError * __nullable error) {
        NSLog(@"步数：=%@ ， 开始时间=%@， 结束时间=%@",pedometerData.numberOfSteps,pedometerData.startDate,pedometerData.endDate);
    }] ;
    
//    if ([CMStepCounter isStepCountingAvailable]) {
//        self.stepCounter = [[CMStepCounter alloc]init];
//    }
//    NSOperationQueue *que = [NSOperationQueue mainQueue];
//    [self.stepCounter startStepCountingUpdatesToQueue:que updateOn:1 withHandler:^(NSInteger numberOfSteps, NSDate * __nonnull timestamp, NSError * __nullable error) {
//                NSLog(@"步数：=%i ， 时间=%@",(int)numberOfSteps,timestamp);
//
//    }];

    
    
}


- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag==0) {
        [self.yqHKStore requestAuthorization];
    }
}
- (IBAction)saveStepCount:(UIButton *)sender {
    [self.yqHKStore saveStepCount];
}
- (IBAction)getStepCountq:(UIButton *)sender {
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-3600*2];
        NSDate *endDate = [NSDate date];
    [self.yqHKStore getStepCountWithStartDate:startDate EndDate:endDate PerMinutes:10 Completion:^(NSArray *resultModelArray) {
        NSLog(@"读取成功 返回 = %@",resultModelArray);
        for (YQStepCountModel *model in resultModelArray) {
        NSLog(@"step = %i,开始时间 = %@",(int)model.stepCount,model.startDate);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.staticView createLinesWithModelArray:resultModelArray animated:YES];
        });

    } Faild:^(NSError *error) {
        NSLog(@"读取错误 错误 = %@",error);
    }];
}

@end
