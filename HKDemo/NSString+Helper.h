//
//  NSString+Helper.h
//  Created by ZPW on 14-3-5.
//  Copyright (c) 2014年 cn.www.dreamfactory. All rights reserved.

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, DateType)
{
    DateTypeYear,
    DateTypeYearMonth,
    DateTypeYearMonthDay,
    DateTypeAll
};
@interface NSString (Helper)

/**
 *删除空格
 */
+ (id)deleteWhiteSpace:(NSString *)str;
/**
 *删除特殊符号
 */
+ (id)deleteSymbolCharacterFrom:(NSString *)str;
/**
 删除0
 */
+ (id)deleteZeroCharacterFrom:(NSString *)str;
/**
 删除字母
 */
+ (id)deleteLetterCharacterFrom:(NSString *)str;

+ (id)getNumberFromStr:(NSString *)str;
/**
 *  截断收尾空白字符
 *
 *  @return 截断结果
 */
- (NSString *)trimString;

/**
 *  为指定文件名添加沙盒文档路径
 *
 *  @return 添加沙盒文档路径的完整路径字符串
 */
- (NSString *)appendToDocumentDir;

/**
 *  为指定文件名添加沙盒文档路径
 *
 *  @return 添加沙盒文档路径的完整路径字符串
 */
- (NSURL *)appendToDocumentURL;

/**
 *  在字符串末尾添加日期及时间
 *
 *  @return 添加日期及时间之后的字符串
 */
- (NSString *)appendDateTime;
/**
*  获取唯一的设备号
*
*  @return <#return value description#>
*/
+ (NSString *)getUUID;

+ (NSString *)getFormattedStrFrom:(NSString *)str;
+ (NSString *)stringFromDate:(NSDate *)date mode:(DateType)mode;
- (NSDate *)dateFromString:(NSString *)dateString mode:(DateType)mode;
/**
*  翻转字符
*
*  @param str <#str description#>
*
*  @return <#return value description#>
*/
+ (NSString *)convertStr:(NSString *)str;

/**
 *  下划线字符串
 */
//+ (NSMutableAttributedString*)AttributedUnderLineWithStr:(NSString *)str;

/**
 *  返回带颜色属性的文字
 */
//+ (NSMutableAttributedString*)AttributedStrWithStr:(NSString*)str Color:(UIColor *)color;
@end
