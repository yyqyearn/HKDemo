//
//  NSString+Helper.m
//
//  Created by ZPW on 14-3-5.
//  Copyright (c) 2014年 cn.www.dreamfactory. All rights reserved.
//

#import "NSString+Helper.h"
#import "NSDate+Calendar.h"
@implementation NSString (Helper)

- (NSString *)trimString
{
    // 截断字符串中的所有空白字符（空格,\t,\n,\r）
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)appendToDocumentDir
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docDir stringByAppendingPathComponent:self];
}

- (NSURL *)appendToDocumentURL
{
    return [NSURL fileURLWithPath:[self appendToDocumentDir]];
}
+ (id)getNumberFromStr:(NSString *)str
{
    NSString *regex = @"[0-9]";
    
    NSError *error = nil;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
    
    NSArray* match = [reg matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, [str length])];
    NSMutableString *results = [NSMutableString string];
    
    for (NSUInteger i = 0; i < match.count; ++i) {
        
        NSRange range = [match[i] range];
        [results appendString:[str substringWithRange:NSMakeRange(range.location
                                                                  , range.length)]];
    }

    return results;
}
- (NSString *)appendDateTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyyMMddHHmmss";
    
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"%@%@", self, str];
}

+ (NSString *)getUUID
{
    CFUUIDRef puuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, puuid);
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy(kCFAllocatorDefault, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString); return result;
}


+ (NSString *)getFormattedStrFrom:(NSString *)str
{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
     return [numberFormatter stringFromNumber: [NSNumber numberWithInteger: [str intValue]]];
}

+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}
- (NSDate *)dateFromString:(NSString *)dateString mode:(DateType)mode{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatStr = nil;
    if(mode == DateTypeAll)
    {
       formatStr = @"yyyy-MM-dd HH:mm:ss";
    }else if(mode == DateTypeYear)
    {
        formatStr = @"yyyy";
    }else if(mode == DateTypeYearMonthDay)
    {
        formatStr = @"yyyy-MM-dd";
    }
    
    [dateFormatter setDateFormat:formatStr];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    
    return destDate;
    
}
+ (NSString *)stringFromDate:(NSDate *)date mode:(DateType)mode
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit|NSMinuteCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSUInteger hour = [comps hour];
    NSUInteger year = [comps year];
    NSUInteger month = [comps    month];
    NSUInteger day = [comps day];
    NSUInteger minute = [comps minute];
    
    if(mode == DateTypeAll)
    {
        
        return [NSString stringWithFormat:@"%ld-%ld-%ld-%ld-%ld",(unsigned long)year,(unsigned long)month,(unsigned long)day,(unsigned long)hour,(unsigned long)minute];
    }else if(mode == DateTypeYear)
    {
        return [NSString stringWithFormat:@"%ld",(unsigned long)year];
    }else if(mode == DateTypeYearMonth)
    {
        return [NSString stringWithFormat:@"%ld",(unsigned long)month];
    }else if(mode == DateTypeYearMonthDay)
    {
        return [NSString stringWithFormat:@"%ld-%ld-%ld",(unsigned long)year,(unsigned long)month,(unsigned long)day];
    }
    return nil;
}


+(id)deleteWhiteSpace:(NSString *)str
{
    return  [[str stringByReplacingOccurrencesOfString:@" " withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (id)deleteSymbolCharacterFrom:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet symbolCharacterSet]];
}
+ (id)deleteLetterCharacterFrom:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
}
+ (id)deleteZeroCharacterFrom:(NSString *)str
{
    NSString *regex = @"[1-9]";
    
    NSError *error = nil;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
    
    NSArray* match = [reg matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, [str length])];
    if (match.count != 0)
    {
        
        NSRange range = [match[0] range];
        //            str = [str substringWithRange:NSMakeRange(range.location + range.length, str.length)];
        NSLog(@"%lu,%lu,%@",(unsigned long)range.location,(unsigned long)range.length,str);
        
    }
    
    return str;
}

+ (NSString *)convertStr:(NSString *)str
{
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableString *tempStr = [NSMutableString string];
    for (NSUInteger i = 0; i < str.length; ++i) {
        [tempArray addObject:[str substringWithRange:NSMakeRange(i, 1)]];
    }
    for (NSUInteger j = tempArray.count - 1; j > 0; --j) {
        [tempStr appendString:[tempArray objectAtIndex:j]];
        [tempStr appendString:@"\n"];
    }
    [tempStr appendString:tempArray[0]];
    [tempStr appendString:@"\n"];
    return [tempStr copy];
}

/*
 *随机生成15位订单号,外部商户根据自己情况生成订单号
 */
//+ (NSString *)generateTradeNO
//{
//	const int N = 15;
//	
//	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//	NSMutableString *result = [[NSMutableString alloc] init];
//	srand(time(0));
//	for (int i = 0; i < N; i++)
//	{
//		unsigned index = rand() % [sourceString length];
//		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
//		[result appendString:s];
//	}
//	return result;
//}

+ (NSString *)getCurrentLanguage
{
//    NSLocale *locale = [NSLocale currentLocale];
//    NSString *country = [locale localeIdentifier];
//    NSLog(@"国家：%@", country); //en_US
    
    NSArray *langueages = [NSLocale preferredLanguages];
    return [langueages objectAtIndex:0];
}

+ (NSArray *)getMonthsByYear:(NSString *)year
{
    return @[[NSString stringWithFormat:@"%@ %@",@"January",year],[NSString stringWithFormat:@"%@ %@",@"February",year],
             [NSString stringWithFormat:@"%@ %@",@"March",year],
             [NSString stringWithFormat:@"%@ %@",@"April",year],
             [NSString stringWithFormat:@"%@ %@",@"May",year],
             [NSString stringWithFormat:@"%@ %@",@"June",year],
             [NSString stringWithFormat:@"%@ %@",@"July",year],
             [NSString stringWithFormat:@"%@ %@",@"August",year],
             [NSString stringWithFormat:@"%@ %@",@"September",year],
             [NSString stringWithFormat:@"%@ %@",@"October",year],
             [NSString stringWithFormat:@"%@ %@",@"November",year],
             [NSString stringWithFormat:@"%@ %@",@"December",year]];
}

+ (NSString *)getCallendarYearFromDate:(NSDate *)currentDate
{
//    PWLog(@"%ld",(unsigned long)currentDate.month);
    switch (currentDate.month) {
        case 1:
        {
            return   [NSString stringWithFormat:@"%@ %ld, %ld",@"January",(unsigned long)currentDate.day,(unsigned long)currentDate.year];
        }
        case 2:
        {
            return   [NSString stringWithFormat:@"%@ %ld, %ld",@"February",(unsigned long)currentDate.day,(unsigned long)currentDate.year];
        }
            break;
        case 3:
        {
            return    [NSString stringWithFormat:@"%@ %ld, %ld",@"March",(unsigned long)currentDate.day,(unsigned long)currentDate.year];
        }
            break;
        case 4:
        {
           return  [NSString stringWithFormat:@"%@ %ld, %ld",@"April",(unsigned long)currentDate.day,(unsigned long)currentDate.year];
        }
            break;
        case 5:
        {
           return  [NSString stringWithFormat:@"%@ %ld, %ld",@"May",(unsigned long)currentDate.day,(unsigned long)currentDate.year];
        }
            break;
        case 6:
        {
           return  [NSString stringWithFormat:@"%@ %ld, %ld",@"June",(unsigned long)currentDate.day,(unsigned long)currentDate.year];
        }
            break;
        case 7:
        {
           return  [NSString stringWithFormat:@"%@ %ld, %ld",@"July",(unsigned long)currentDate.day,(unsigned long)currentDate.year];
        }
            break;
        case 8:
        {
            return [NSString stringWithFormat:@"%@ %ld, %ld",@"August",(unsigned long)currentDate.day,(unsigned long)currentDate.year];
        }
            break;
        case 9:
        {
           return  [NSString stringWithFormat:@"%@ %ld, %ld",@"September",(unsigned long)currentDate.day,(unsigned long)currentDate.year];
        }
            break;
        case 10:
        {
           return  [NSString stringWithFormat:@"%@ %ld, %ld",@"October",(unsigned long)currentDate.day,(unsigned long)currentDate.year];
        }
            break;
        case 11:
        {
           return  [NSString stringWithFormat:@"%@ %ld,%ld",@"November",(unsigned long)currentDate.day,(unsigned long)currentDate.year];
        }
            break;
        case 12:
        {
            return  [NSString stringWithFormat:@"%@ %ld,%ld",@"December",(unsigned long)currentDate.day,(unsigned long)currentDate.year];
        }
            break;
    }
    return nil;
//             [NSString stringWithFormat:@"%@ %ld,%ld",@"January",currentDate.day,currentDate.year],
//             [NSString stringWithFormat:@"%@ %ld,%ld",@"February",currentDate.day,currentDate.year],
//             [NSString stringWithFormat:@"%@ %ld,%ld",@"March",currentDate.day,currentDate.year],
//              [NSString stringWithFormat:@"%@ %ld,%ld",@"April",currentDate.day,currentDate.year],
//              [NSString stringWithFormat:@"%@ %ld,%ld",@"May",currentDate.day,currentDate.year],
//             [NSString stringWithFormat:@"%@ %ld,%ld",@"June",currentDate.day,currentDate.year],
//              [NSString stringWithFormat:@"%@ %ld,%ld",@"July",currentDate.day,currentDate.year],
//             [NSString stringWithFormat:@"%@ %ld,%ld",@"August",currentDate.day,currentDate.year],
//             [NSString stringWithFormat:@"%@ %ld,%ld",@"September",currentDate.day,currentDate.year],

    //            [NSString stringWithFormat:@"%@ %ld,%ld",@"October",currentDate.day,currentDate.year],
//               [NSString stringWithFormat:@"%@ %ld,%ld",@"November",currentDate.day,currentDate.year],
//        [NSString stringWithFormat:@"%@ %ld,%ld",@"December",currentDate.day,currentDate.year],
}



+ (NSString *)getDateWithFormatter:(NSString *)formatter date:(NSDate *)date
{
    NSDateFormatter *fot = [[NSDateFormatter alloc] init];
    fot.dateFormat = formatter;
    return [fot stringFromDate:date];
}


//+ (NSMutableAttributedString*)AttributedUnderLineWithStr:(NSString *)str
//{
//    //设置下划线
//    NSMutableAttributedString * mtStr = [[NSMutableAttributedString alloc]initWithString:str];
//    NSRange range = NSMakeRange(0, str.length);
//    [mtStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
//    
//    return mtStr;
//}
//+ (NSMutableAttributedString*)AttributedStrWithStr:(NSString*)str Color:(UIColor *)color
//{
//    
//    NSDictionary *dic = @{NSForegroundColorAttributeName:color};
//    NSMutableAttributedString * mtStr = [[NSMutableAttributedString alloc]initWithString:str attributes:dic];
//    return mtStr;
//    
//}


@end
