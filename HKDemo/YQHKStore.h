//
//  YQHKStore.h
//  OSE
//
//  Created by yyq on 15/7/2.
//  Copyright © 2015年 MobileNow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQHKStore : NSObject
/**
 * 构造
 */
+ (instancetype)shareTool;

/**
 * 请求权限
 */
- (void)requestAuthorization;





- (void)saveStepCount;
- (void)getStepCount;
@end
