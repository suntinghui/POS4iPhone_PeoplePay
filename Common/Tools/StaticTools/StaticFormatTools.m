//
//  StaticFormatTools.m
//  Mlife
//
//  Created by xuliang on 12-12-27.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件名： StaticFormatTools.m
 // 文件功能描述：公共方法类
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/


#import "StaticFormatTools.h"

@implementation StaticTools(StaticFormatTools)

/*
 @abstract 格式化电话号码
 */
+ (NSString *)formatPhoneNo:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}

//转换时区 输入时间 输出＋8时间
+(NSDate *)convertDateToLocalTime:(NSDate *)forDate
{
    
    NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
    
    int timeOffset = [nowTimeZone secondsFromGMTForDate:forDate];
    
    
    NSDate *newDate = [forDate dateByAddingTimeInterval:timeOffset];
    
    return newDate;
    
}
/**
 *	@brief	从指定日期字符串的初始化一个NSdate
 *
 *	@param 	dateStr 指定日期的字符串 注意分割线 支持 2012-12-12 和 2012/12/12 两种形式分隔
 *       可以带时间 如2012-12-12 10:12:12 若未带时间 则返回的date的时间为默认的08:00:00(系统默认时间为00:00:00 调用convertDateToLocalTime后变成 08:00:00)
 *	@return
 */
+ (NSDate*)getDateFromDateStr:(NSString*)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([dateStr rangeOfString:@"-"].location!=NSNotFound) {
        if (dateStr.length>10) {
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        else
        {
            [formatter setDateFormat:@"yyyy-MM-dd"];
        }
    }
    else
    {
        if (dateStr.length>10) {
            [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        }
        else
        {
            [formatter setDateFormat:@"yyyy/MM/dd"];
        }
    }
	NSDate *date = [formatter  dateFromString:dateStr];
    date = [StaticTools convertDateToLocalTime:date];
    return date;
}


/**
 *	@brief	获取指定日期的字符串表达式 需要当前日期时传入：[NSDate date] 即可 注意时区转换
 *
 *	@param 	someDate 	指定的日期 NSDate类型
 *	@param 	typeStr 	分割线类型 @"/" 或者@“-”  传nil时默认使用@“-”
 *  @param  hasTime     是否需要返回时间
 *	@return	返回的日期字符串  格式为 2012-13-23 或者 2013/13/23 或2012-12-12 12:11:11 或2102/12/12 12:12:12
 */
+ (NSString *)getDateStrWithDate:(NSDate*)someDate withCutStr:(NSString*)cutStr hasTime:(BOOL)hasTime
{
    if (cutStr == nil) {
        cutStr = @"-";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *str = nil;
    if (hasTime) {
        str = [NSString stringWithFormat:@"yyyy%@MM%@dd HH:mm:ss",cutStr,cutStr];
    }
    else
    {
        str = [NSString stringWithFormat:@"yyyy%@MM%@dd",cutStr,cutStr];
    }
	[formatter setDateFormat:str];
	NSString *date = [formatter stringFromDate:someDate];
	return date;
}

/**
 *  /给一个没有分隔符的日期加入分隔符 如20131312变成 2013-13-12 或2013/12/12 日期可没有日 如：201212
 *
 *  @param dateStr 日期字符串
 *  @param seper   分隔符  "-"或者"/"
 *
 *  @return
 */
+ (NSString *)insertCharactorWithDateStr:(NSString*)dateStr andSeper:(kSeperType)type
{
    if (dateStr.length<6)
    {
        return dateStr;
    }
    NSMutableString *date = [NSMutableString stringWithString:dateStr];
    if (type == kSeperTypeRail)
    {
        [date insertString:@"-" atIndex:4];
        if (dateStr.length>7)
        {
            [date insertString:@"-" atIndex:7];
        }
        
    }
    else if(type == kSeperTypeSlash)
    {
        [date insertString:@"/" atIndex:4];
        if (dateStr.length>7)
        {
            [date insertString:@"/" atIndex:7];
        }
    }
    else if(type == kSeperTypeWord)
    {
        [date insertString:@"年" atIndex:4];
        [date insertString:@"月" atIndex:7];
        if (dateStr.length>=8)
        {
            [date insertString:@"日" atIndex:10];
        }
        
    }

    return date;
}

/**
 *  指定开始时间和间隔月数  返回从开始时间开始 months个月后的日期  若结束日期超过当前日期  则返回当前日期
 *
 *  @param time   开始日期 2013-12-12或者2013/12/12
 *  @param months 间隔月数
 *
 *  @return 结束日期
 */
+ (NSString*)getEndTimeWithStartTime:(NSString*) time Month:(int)months
{
    NSDate *date = [StaticTools getDateFromDate:[StaticTools getDateFromDateStr:time] withYear:0 month:months day:0];
    if ([date earlierDate:[NSDate date]]!=date)
    {
        date = [NSDate date];
    }
    
    return [StaticTools getDateStrWithDate:date withCutStr:@"-" hasTime:NO];
    
}

//根据日期获取到星期几
+ (NSString*)getWeakWithDate:(NSDate*)date
{
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    
    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
            
                       fromDate:date];
    int weak = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。
    if (weak==1)
    {
        return @"星期日";
    }
    else  if (weak==2)
    {
        return @"星期一";
    }
    else  if (weak==3)
    {
        return @"星期二";
    }
    else  if (weak==4)
    {
        return @"星期三";
    }
    else  if (weak==5)
    {
        return @"星期四";
    }
    else  if (weak==6)
    {
        return @"星期五";
    }
    else  if (weak==7)
    {
        return @"星期六";
    }
    
    return @"";
}

/**
 *	@brief	判断一个字符串是否为整型数字
 *
 *	@param 	string
 *
 *	@return	
 */
+ (BOOL) isPUreInt:(NSString*)string

{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val]&&[scan isAtEnd];
}

/**
 *	@brief	判断一个字符串是否为浮点型数字
 *
 *	@param 	string 	
 *
 *	@return	
 */
+ (BOOL) isPUreFloat:(NSString*)string

{
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val]&&[scan isAtEnd];
}

/**
 *	@brief	判断邮箱格式是否正确
 *
 *	@param 	email
 *
 *	@return	
 */
+ (BOOL)isValidateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 *  判断密码格式是否正确（仅包含数字和字母）
 *
 *  @param psw
 *
 *  @return
 */
+ (BOOL)isValidatePassword:(NSString*)psw
{
    
    NSString *emailRegex = @"^[A-Za-z0-9]+$";
    NSPredicate *pswTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [pswTest evaluateWithObject:psw];
}
/**
 *  判断邮政编码是否正确
 *
 *  @param post
 *
 *  @return
 */
+ (BOOL)isValidatePostCode:(NSString*)post
{
   // NSString *postRegex = @"[1-9]d{5}(?!d)"; 貌似不行
      NSString *postRegex = @"/^d{6}$/";
    NSPredicate *postTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",postRegex];
    return [postTest evaluateWithObject:post];
}
/**
 *  将一个数据项为字典的数组按照字典里某个键的值相同的进行分组
 *
 *  @param array  需要分组的数组
 *  @param theKey 比较的key
 *
 *  @return 返回一个数组 数组项为保存了比较的键的值相同的项的数组
 */
+ (NSArray*)componentsSeparatedArray:(NSArray*)theArray byKey:(NSString*)theKey
{

    NSArray *sortDes = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:theKey ascending:YES]];
    NSArray *sortArray  = [theArray sortedArrayUsingDescriptors:sortDes];
    
    int beg = 0;
    NSMutableArray *listArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i=0;i<sortArray.count-1;i++)
    {
        NSDictionary *fronDict = sortArray[i];
        NSDictionary *behandDict = sortArray[i+1];
        
        if (![fronDict[theKey] isEqualToString:behandDict[theKey]])
        {
            NSArray *temArray = [NSArray arrayWithArray:[sortArray subarrayWithRange:NSMakeRange(beg, i+1-beg)]];
            [listArray addObject:temArray];
            beg = i+1;
        }
    }
    
    NSArray *temArray = [NSArray arrayWithArray:[sortArray subarrayWithRange:NSMakeRange(beg, sortArray.count-1+1-beg)]];
    [listArray addObject:temArray];
    
    return listArray;
    
}


/**
 *  给一个金额字符串插入逗号分隔 保留两位有效数字
 *
 *  @param number 金额字符串
 *
 *  @return
 */
+ (NSString*)insertCommaInNumStr:(NSString*)number
{
    NSMutableString *resultStr = [NSMutableString stringWithFormat:@"%.2f",[number doubleValue]];
    
    BOOL bellowZearo = NO;
    if ([number doubleValue]<0)
    {
        bellowZearo = YES;
        [resultStr replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    int count = ([resultStr length]-1)/3-2;
    int mod = [resultStr length]%3==0?3:[resultStr length]%3;
    
    for (int i=0; i<=count; i++)
    {
       [resultStr insertString:@"," atIndex:mod+3*(count-i)];
    }
    
    if (bellowZearo)
    {
        [resultStr insertString:@"-" atIndex:0];
    }
    
    return resultStr;
}

//给一个银行卡号插入星号
+ (NSString*)insertComaInCardNumber:(NSString*)number
{
    if (number.length<5)
    {
        return number;
    }
    return [NSString stringWithFormat:@"%@*****%@",[number substringToIndex:4],[number substringFromIndex:number.length-4]];
}
@end
