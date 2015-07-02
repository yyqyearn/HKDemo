//
//  YQStaticView.m
//  HKDemo
//
//  Created by Yongqi on 15/7/3.
//  Copyright © 2015年 mobilenow. All rights reserved.
//
#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式

#import "YQStaticView.h"
#import "UIBezierPath+curved.h"
@interface YQStaticView()

@property (strong, nonatomic) NSArray *points;
@property (strong, nonatomic) NSMutableArray *lineLayers;
@property (assign, nonatomic) int linesCount;

@end
@implementation YQStaticView
- (NSArray *)points{
    if (_points) {
        return _points;
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    int count = 30;
    //单位角度
    CGFloat angle = 360/count;
    //圆心点
    CGPoint center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
    
    //半径增量系数
    CGFloat add = 20;
//    if (self.shakeRank>ShakeRankA) {
//        add = 3;
//    }else if (self.shakeRank>ShakeRankC){
//        add = 20;
//    }
    for (int i = 0; i < count+1; i ++) {
        //点半径
        CGFloat radius = [self getRandomNumber:50 to:(50+add)];
        CGFloat pAngle = angle * i;
        CGFloat x=0;
        CGFloat y=0;
        CGFloat aAngle = 0;
        if (pAngle<=90) {
            aAngle = degreesToRadians(pAngle);
            x = center.x + sin(aAngle) * radius;
            y = center.y - cos(aAngle) * radius;
        }else if (pAngle<=180){
            aAngle = degreesToRadians(pAngle-90);
            x = center.x + cos(aAngle) * radius;
            y = center.y + sin(aAngle) * radius;
        }else if (pAngle<=270){
            aAngle = degreesToRadians(pAngle-180);
            x = center.x - sin(aAngle) * radius;
            y = center.y + cos(aAngle) * radius;
        }else{
            aAngle = degreesToRadians(pAngle-270);
            x = center.x - cos(aAngle) * radius;
            y = center.y - sin(aAngle) * radius;
        }
        //        NSLog(@"第%i个点，角度 = %f, x = %f , y = %f",i ,pAngle,x,y );
        NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        if (i!=count) {
            [tempArr addObject:pointValue];
        }else{
            [tempArr addObject:[tempArr firstObject]];
        }
        
        
    }
    _points = tempArr;
    return _points;
}
- (void)addLines{
    
    //初始化路径
    UIBezierPath *bezPath = [UIBezierPath bezierPath];
    bezPath.lineCapStyle = kCGLineCapRound;//拐角处理
    bezPath.lineJoinStyle = kCGLineCapRound;//终点处理
    
    
    for (int i = 0; i < self.points.count; i ++) {
        NSValue * aPointValue = self.points[i];
        CGPoint point = [aPointValue CGPointValue];
        if (i==0) {
            [bezPath moveToPoint:point];
        }else{
            [bezPath addLineToPoint:point];
        }
    }
    
    [bezPath closePath];
    bezPath = [bezPath smoothedPathWithGranularity:20];

    for (int i = 0; i < 20; i ++) {
        CAShapeLayer * contentLayer = [CAShapeLayer layer];
        contentLayer.fillColor = [UIColor clearColor].CGColor;
        contentLayer.frame = self.bounds;
        contentLayer.strokeColor = [UIColor greenColor].CGColor;
        contentLayer.lineWidth = 1;
        contentLayer.path = bezPath.CGPath;
        
        CGFloat trans = 1+0.1*i;
        contentLayer.transform = CATransform3DMakeScale(trans, trans, 1);
        
        [self.layer addSublayer:contentLayer];
        [self.lineLayers addObject:contentLayer];
    }

}

- (void)drawRect:(CGRect)rect {

}



-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
