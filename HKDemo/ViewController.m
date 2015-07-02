//
//  ViewController.m
//  HKDemo
//
//  Created by yyq on 15/7/2.
//  Copyright © 2015年 mobilenow. All rights reserved.
//

#import "ViewController.h"
#import "YQHKStore.h"
@interface ViewController ()
@property (nonatomic,weak) YQHKStore *yqHKStore;


@end

@implementation ViewController
- (YQHKStore *)yqHKStore
{
    if (!_yqHKStore) {
        _yqHKStore = [YQHKStore shareTool];
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
    [self.yqHKStore getStepCount];
}

@end
