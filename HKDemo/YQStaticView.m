//
//  YQStaticView.m
//  HKDemo
//
//  Created by Yongqi on 15/7/3.
//  Copyright © 2015年 mobilenow. All rights reserved.
//
#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define kLineTypeCount 3 //有几种半径风格
#define kLinesCountMain 30 //有多少条主要线
#define kLinesCountMinor 10 //有多少条次级线
#import "YQStaticView.h"
#import "UIBezierPath+curved.h"
#import "YQHKStoreTool.h"
@interface YQStaticView()

@property (strong, nonatomic) NSArray *points;
@property (strong, nonatomic) NSMutableArray *lineLayers;
@property (nonatomic, strong) NSArray *modelArray;


@end
@implementation YQStaticView
- (NSArray *)points{
    if (_points) {
        return _points;
    }
    
    //点的个数
    NSInteger count = self.modelArray.count;
    //单位角度
    CGFloat angle = 360/count;
    //圆心点
    CGPoint center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
    //半径增量系数
    CGFloat add = 1;

    //创建主线条集合
    NSMutableArray *tempMainLineArray = [NSMutableArray array];
    for (int i = 0; i <kLinesCountMain ;i++) {
        NSMutableArray *pointsArray = [NSMutableArray array];
        [tempMainLineArray addObject:pointsArray];
    }
    
    //创建每一条线的点,根据角度
    for (int i = 0; i<count+1; i++) {

        CGFloat radiusBase = [self getRandomNumber:50 to:50+add];
        CGFloat pAngle = angle * i; //角度
        CGFloat x=0;
        CGFloat y=0;
        

        YQStepCountModel *model = nil;
        if (i<count) {
            model = self.modelArray[i];
        }
        for (int j = 0; j <kLinesCountMain ;j++) {
            NSMutableArray *pointsArray = tempMainLineArray[j];
            
            CGFloat radius = radiusBase + 1*j;
                CGFloat adds = [self getRandomNumber:1 to:1.1*model.stepRank];
                radius = radius*(1+adds*0.0003*j*j);
            
            CGFloat aAngle = 0;//弧度
        
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
            
            NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
            if (i!=count) {
                [pointsArray addObject:pointValue];
            }else{
                [pointsArray addObject:[pointsArray firstObject]];
            }
        }
    }
    
    _points = @[tempMainLineArray];
    return _points;
}
- (void)createLinesWithModelArray:(NSArray*)modelArray animated:(BOOL)animated{
    
//移除之前的涂层
    self.points = nil;
    self.modelArray = modelArray;
    
    [self.lineLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    self.lineLayers = [NSMutableArray array];
    
    NSArray *mainLineArr = [self.points firstObject];
    NSArray *colorArray = [self colorsFromGreenToWhiteWithCount:mainLineArr.count];
    
    for (int i = 0; i < mainLineArr.count; i ++) {
        
        //初始化路径
        UIBezierPath *bezPath = [UIBezierPath bezierPath];
        bezPath.lineCapStyle = kCGLineCapRound;//拐角处理
        bezPath.lineJoinStyle = kCGLineCapRound;//终点处理
        
        
        NSArray *pointArray = mainLineArr[i];
        
        
        for (int i = 0; i < pointArray.count; i ++) {
            NSValue * aPointValue = pointArray[i];
            CGPoint point = [aPointValue CGPointValue];
            if (i==0) {
                [bezPath moveToPoint:point];
            }else{
                [bezPath addLineToPoint:point];
            }
        }
        
        [bezPath closePath];
        bezPath = [bezPath smoothedPathWithGranularity:15];
        
        
        CAShapeLayer * contentLayer = [CAShapeLayer layer];
        contentLayer.fillColor = [UIColor clearColor].CGColor;
        contentLayer.frame = self.bounds;
        
        UIColor *desColor = colorArray[i];
        contentLayer.strokeColor = desColor.CGColor;
        contentLayer.lineWidth = 1;
        contentLayer.path = bezPath.CGPath;
        
        if (animated) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = @0;
            animation.toValue = @1;
            animation.duration = 3;
            animation.delegate=self;
            [contentLayer addAnimation:animation forKey:@"MPStroke"];
        }
        

        [self.layer addSublayer:contentLayer];
        [self.lineLayers addObject:contentLayer];
    }
}

- (void)drawRect:(CGRect)rect {
    
    //    //初始化路径
    //    UIBezierPath *bezPath = [UIBezierPath bezierPath];
    //    bezPath.lineCapStyle = kCGLineCapRound;//拐角处理
    //    bezPath.lineJoinStyle = kCGLineCapRound;//终点处理
}



-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}


- (NSArray*)colorsFromGreenToWhiteWithCount:(NSInteger)count{
    
    CGFloat add = 1/(CGFloat)count;
    
    CGFloat RB = 1;

    CGFloat G =  1;
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i<count; i++) {
       RB -= add*0.7;
       UIColor *color = [UIColor colorWithRed:RB green:G blue:RB alpha:1];
        [tempArray addObject:color];
    }
    NSArray *result = tempArray;
    return result;
}

@end
