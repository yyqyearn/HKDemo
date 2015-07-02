//
//  ViewController.m
//  HKDemo
//
//  Created by yyq on 15/7/2.
//  Copyright © 2015年 mobilenow. All rights reserved.
//

#import "ViewController.h"
#import "YQHKStoreTool.h"
@interface ViewController ()
@property (nonatomic,weak) YQHKStoreTool *yqHKStore;


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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    } Faild:^(NSError *error) {
        NSLog(@"读取错误 错误 = %@",error);
    }];
}

@end
