//
//  StaticDataTools.m
//  Mlife
//
//  Created by xuliang on 12-12-27.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件名： StaticDataTools.m
 // 文件功能描述：公共方法类
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/


#import "StaticDataTools.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"

@implementation StaticTools(StaticDataTools)

#pragma mark -
#pragma mark 文件(夹)操作
/*
 @abstract 检查Documents里是否有此文件
 */
+ (BOOL)fileExistsAtPath:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *DocumentsPath = [documentsDirectory stringByAppendingPathComponent:fileName];
	return [fileManager fileExistsAtPath:DocumentsPath];
}

/*
 获得相应文件路径
 */
+ (NSString *)getFilePath:(NSString *)fileName
{    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *DocumentsPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    return DocumentsPath;
}

/*
 @abstract 从ducument文件夹中的userInfo.plist提取UserName
 */
+ (NSString *)getUserNameFromPlist
{
    NSString *userName= @"";
	if ([self fileExistsAtPath:@"userInfo.plist"])
    {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userInfo.plist"];
		
		NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
		userName = [tempDic valueForKey:@"userName"];
        //internal memory
	}
	
	return userName;
}

/*
 @abstract 获取临时文件大小
 */
+ (unsigned long long)getCacheSize
{
    //TODO
    return 0;
}

/*
 @abstract 保存数据到缓存
 */
+ (void)saveData:(NSMutableArray *)dataArray
       cacheType:(NSString *)cacheType
         dataNum:(NSInteger)num
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	if([tempArray count] > num){
		NSRange range = NSMakeRange(num, [tempArray count] - num);
		[tempArray removeObjectsInRange:range];
	}
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path_ = [documentsDirectory stringByAppendingPathComponent:@"cacheArray.plist"];
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path_];
	if(!tempDictionary)
    {
        tempDictionary = [[NSMutableDictionary alloc] init];
    }
	[tempDictionary setObject:tempArray forKey:cacheType];
	[tempDictionary writeToFile:path_ atomically:YES];
}

/*
 @abstract 取出指定缓存数据
 */
+ (NSMutableArray *)getCacheArray:(NSString *)cacheType
{
    
    NSMutableArray *cacheArray = [[NSMutableArray alloc] init];//M_lxl
	if ([cacheType length] == 0)
    {
        return cacheArray;
    }
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path_ = [documentsDirectory stringByAppendingPathComponent:@"cacheArray.plist"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path_])
    {
		[cacheArray writeToFile:path_ atomically:YES];
		return cacheArray;
	}
	else
    {
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path_];
//		cacheArray = [[tempDictionary objectForKey:cacheType] retain];//D_liuxl20131010
        cacheArray = [tempDictionary objectForKey:cacheType];
		return cacheArray;
	}
}

/*
 @abstract 删除指定缓存数据
 */
+ (void)removeDataForKey:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path_ = [documentsDirectory stringByAppendingPathComponent:@"cacheArray.plist"];
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path_];
    
    if (!tempDictionary)
    {
        return;
    }
    
    [tempDictionary removeObjectForKey:key];
    [tempDictionary writeToFile:path_ atomically:YES];
}

/*
 @abstract 清空缓存数据
 */
+ (void)clearCacheArray
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *DocumentsPath = [documentsDirectory stringByAppendingPathComponent:@"cacheArray.plist"];
    
	if ([[NSFileManager defaultManager] fileExistsAtPath:DocumentsPath])
    {
		[[NSFileManager defaultManager] removeItemAtPath:DocumentsPath error:nil];
	}
}


#pragma mark -
#pragma mark 字符串操作
/*
 @abstract 校验字符串是否为空
 */
+ (BOOL)isEmptyString:(NSString *)string
{
    if (string == nil||[string isEqual:[NSNull null]])
    {
        return YES;
    }
    
	//去空格之后判断length是否为0
	NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSString *content = [string stringByTrimmingCharactersInSet:whitespace];
	if ([content length] == 0)
    {
        return YES;
    }
	
	return NO;
}

/*
 @abstract 判断邮政编码格式是否正确
 */
+ (BOOL)checkZipCode:(NSString *)coder
{
    if(coder.length != 6)
    {
        return NO;
    }
	
	NSError *error = NULL;
	NSString *ruleString = @"[0-9]\\d{5}(?!\\d)";
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:ruleString
																		   options:NSRegularExpressionCaseInsensitive
																			 error:&error];
	NSUInteger numberOfMatches = [regex numberOfMatchesInString:coder
														options:0
														  range:NSMakeRange(0, [coder length])];
	if(numberOfMatches == 1)
    {
        return YES;
    }
	else
    {
        return NO;
    }
}

/*
 @abstract 判断输入是否全部都是数字
 */
+ (BOOL)checkAllIsNumber:(NSString *)psw
{
    int length = [psw length];
	if(0 == length)
    {
        return NO;
    }
    
	//判断是否有汉字
	for (int i = 0; i < length; i++)
    {
		NSRange range = NSMakeRange(i, 1);
		NSString *subString = [psw substringWithRange:range];
		const char *cString = [subString UTF8String];
        
		if (strlen(cString) == 3)
        {
            return NO;
        }
	}
    
	//判断是否是数字＋字母
	const char *s = [psw UTF8String];
	for(int i = 0;i < length; i++)
    {
		if(s[i] >= 'a' && s[i] <= 'z')
        {
            return NO;
        }
		else if(s[i] >= 'A' && s[i] <= 'Z')
        {
            return NO;
        }
	}
    return YES;
}

#pragma mark - 判断输入，只能输入数字
+ (BOOL)isContainsNum:(NSString *)string
{
    __block BOOL isNum = YES;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//        NSLog(@"subSting;%@",substring);
        if ([substring isEqualToString:@"0"] || [substring isEqualToString:@"1"] || [substring isEqualToString:@"2"] || [substring isEqualToString:@"3"] || [substring isEqualToString:@"4"] || [substring isEqualToString:@"5"] || [substring isEqualToString:@"6"] || [substring isEqualToString:@"7"] || [substring isEqualToString:@"8"] || [substring isEqualToString:@"9"] || [substring isEqualToString:@"."]) {
            isNum = YES;
        }
        else {
            isNum = NO;
        }
    }];
    return isNum;
}


/*
 @abstract 判断输入是否全部都是字符（不允许有汉字、数字等） 不能为空
 */
+ (BOOL)checkAllIsLetter:(NSString *)psw
{
    BOOL hasOther = NO;
	
	int length = [psw length];
	if(length == 0)
    {
        return NO;
    }
	
	//判断是否有汉字
	for (int i = 0; i < length; i++)
    {
		NSRange range = NSMakeRange(i, 1);
		NSString *subString = [psw substringWithRange:range];
		const char *cString = [subString UTF8String];
		if (strlen(cString) == 3)
        {
            return NO;
        }
	}
	
	//判断是否含有数字
	const char *s=[psw UTF8String];
	for(int i = 0;i < length; i++)
    {
		if(s[i] >= '0' && s[i] <= '9')
        {
            hasOther = YES;
        }
	}
	return !hasOther;
}

/*
 @abstract 判断用户名 1：小于30位。2：数字＋字母。3：不能包含其它字符
 */
+ (BOOL)checkUserName:(NSString *)psw
{
    BOOL hasOther = NO;
	int length = [psw length];
	
	//判断是否是小于30位
	if(length > 30)
    {
        return NO;
    }
	
	//判断是否有汉字
	for (int i = 0; i < length; i++)
    {
		NSRange range = NSMakeRange(i, 1);
		NSString *subString = [psw substringWithRange:range];
		const char *cString = [subString UTF8String];
		if (strlen(cString) == 3)
        {
            return NO;
        }
	}
    
	//判断是否是数字＋字母
	const char *s=[psw UTF8String];
	for(int i = 0;i < length; i++)
    {
		if(s[i] >= '0' && s[i] <= '9')
        {
            continue;
        }
		else if(s[i] >= 'a' && s[i] <= 'z')
        {
            continue;
        }
		else if(s[i] >= 'A' && s[i] <= 'Z')
        {
            continue;
        }
		else
        {
            hasOther = YES;
        }
	}
	
	if(hasOther)
    {
        return NO;
    }
	else
    {
        return YES;
    }
}

/*
 @abstract 判断密码 1：8－16位置。2：数字＋字母。3：不能全是数字或全是字母
 */
+ (BOOL)checkPsw:(NSString *)psw
{
    BOOL hasNum = NO;
	BOOL hasLetter = NO;
	BOOL hasOther = NO;
	
	int length = [psw length];
	
	//判断是否是8－16位
	if(length > 16 || length < 8)
    {
        return NO;
    }
	
	//判断是否有汉字
	for (int i = 0; i < length; i++)
    {
		NSRange range = NSMakeRange(i, 1);
		NSString *subString = [psw substringWithRange:range];
		const char    *cString = [subString UTF8String];
		if (strlen(cString) == 3)
        {
            return NO;
        }
	}
	
	//判断是否是数字＋字母
	const char *s=[psw UTF8String];
	for(int i = 0;i < length; i++)
    {
		if(s[i] >= '0' && s[i] <= '9')
        {
            hasNum = YES;
        }
		else if(s[i] >= 'a' && s[i] <= 'z')
        {
            hasLetter = YES;
        }
		else if(s[i] >= 'A' && s[i] <= 'Z')
        {
            hasLetter = YES;
        }
		else
        {
            hasOther = YES;
        }
	}
	
	if(hasNum && hasLetter && !hasOther)
    {
        return YES;
    }
	else
    {
        return NO;
    }
}

/*
 判断手机号码是否合法
 YES合法
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
	/**
	 * 手机号码
	 * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
	 * 联通：130,131,132,152,155,156,185,186
	 * 电信：133,1349,153,180,189
	 */
	//NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
	/**
	 10         * 中国移动：China Mobile
	 11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
	 12         */
	NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
	/**
	 15         * 中国联通：China Unicom
	 16         * 130,131,132,152,155,156,185,186
	 17         */
	NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
	/**
	 20         * 中国电信：China Telecom
	 21         * 133,1349,153,180,189
	 22         */
	NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
	
	//NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
	NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
	NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
	NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
	
    if (([regextestcm evaluateWithObject:mobileNum] == YES)
		|| ([regextestct evaluateWithObject:mobileNum] == YES)
		|| ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/*
 @function 判断固定电话号码是否合法
 @return YES:合法
 */
+ (BOOL)isTellPhoneNumber:(NSString *)mobileNum
{
    /**
	 25         * 大陆地区固话及小灵通
	 26         * 区号：010,020,021,022,023,024,025,027,028,029
	 27         * 号码：七位或八位
	 28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestphs =[NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    
    if (([regextestphs evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark  时间相关 Funcitons
/*
 @abstract 获取当前时间 精确到毫秒
 */
+ (NSString *)getCurrencyTime
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss-SSS"];
	NSString *dateTime = [formatter stringFromDate:[NSDate date]];
	return dateTime;
}

/*
 @abstract 判断两个时间的日期间隔  日期的格式必须是2011－01－01或者2011/01/01
 */
+ (double)checkTimeInterval:(NSString *)beginData endData:(NSString *)endData
{
    NSString *beginYearString = [beginData substringWithRange:NSMakeRange(0, 4)];
	NSString *beginMonthString = [beginData substringWithRange:NSMakeRange(5, 2)];
	NSString *beginDayString = [beginData substringWithRange:NSMakeRange(8, 2)];
	double beginYearDouble = [beginYearString doubleValue]*365;
	double beginMonthDouble = [beginMonthString doubleValue]*30;
	double beginDayDouble = [beginDayString doubleValue];
	
	NSString *endYearString = [endData substringWithRange:NSMakeRange(0, 4)];
	NSString *endMonthString = [endData substringWithRange:NSMakeRange(5, 2)];
	NSString *endDayString = [endData substringWithRange:NSMakeRange(8, 2)];
	double endYearDouble = [endYearString doubleValue]*365;
	double endMonthDouble = [endMonthString doubleValue]*30;
	double endDayDouble = [endDayString doubleValue];
	
	return (endYearDouble + endMonthDouble + endDayDouble) - (beginYearDouble + beginMonthDouble+beginDayDouble);
}

/*
 @abstract 取得今天的日期 yyyy-MM-dd
 */
+ (NSString *)getTodayDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	NSString *dateTime = [formatter stringFromDate:[NSDate date]];
	return dateTime;
}
/*
 @abstract 取得今天的日期 MM月dd日
 */
+ (NSString *)getDateNoYearWithStr:(NSString *)dateStr
{
    if (dateStr) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:dateStr];
        [formatter setDateFormat:@"MM月dd日"];
        NSString *dateTime = [formatter stringFromDate:date];
        return dateTime;
    }
    else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM月dd日"];
        NSString *dateTime = [formatter stringFromDate:[NSDate date]];
        return dateTime;
    }
}

+ (NSString *)getTodayYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy"];
	NSString *dateTime = [formatter stringFromDate:[NSDate date]];
	return dateTime;
}

+ (NSString *)getTodayMonth
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM"];
	NSString *dateTime = [formatter stringFromDate:[NSDate date]];
	return dateTime;
}

/*
 @abstract 取得今天星期几
 */
+ (NSString *)getWeekdayWithStr:(NSString *)dateStr
{
    NSDate *dateTime;
    if (dateStr) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        dateTime = [formatter dateFromString:dateStr];
    }
    else {
        dateTime = [NSDate date];
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:dateTime];
    int week = [comps weekday];
    switch (week) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return @"星期一";
            break;
    }
}

/*
 @abstract 取得startDate后days的日期 yyyy-MM-dd
 */
+ (NSString *)getAfterDate:(NSDate *)startDate days:(int)days
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([startDate timeIntervalSinceReferenceDate] + 24 * 3600 * days)];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	NSString *dateTime = [formatter stringFromDate:date];
	return dateTime;
}

/**
 *	@brief	取得对指定日期进行年、月、日加减后的日期
 *
 *	@param 	someDate 	指定的日期
 *	@param 	changYear 	年份加减数
 *	@param 	changeMonth 	月份加减数
 *	@param 	changeDay 	日加减数
 *
 *	@return	
 */
+ (NSDate*)getDateFromDate:(NSDate*)someDate
                  withYear:(int)changYear
                     month:(int)changeMonth
                       day:(int)changeDay

{
    
   NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    [dateComponents setYear:changYear];
    [dateComponents setMonth:changeMonth];
    [dateComponents setDay:changeDay];
    
    NSDate *date = [gregorian dateByAddingComponents:dateComponents toDate:someDate options:0];
    return date;
    
}
/*
 @abstract 16进制颜色(html颜色值)字符串转为UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor blackColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor blackColor];
    }

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

/*
 @abstract 根据经纬度计算距离
 @param latitudeX 起点纬度
 latX 终点纬度
 longitudeX 起点经度
 lngX 终点经度
 */
+ (CGFloat)dist:(double)latitudeX
           latX:(double)latX
     longitudeX:(double)longitudeX
           lngX:(double)lngX
{
	double latY = latitudeX;
	double lngY = longitudeX;
    double radLat1 =latX * M_PI / 180.0;
    double radLat2 = latY * M_PI / 180.0;
    double a = radLat1 - radLat2;
    double b = lngX * M_PI / 180.0- lngY * M_PI / 180.0;
    double s = 2 * asin(sqrt(pow(sin(a / 2),2) +
                             cos(radLat1) * cos(radLat2)*pow(sin(b / 2),2)));
	
    double earthRadius = 6378.137; //地球半径，单位公里
    s = s * earthRadius;
    s = round(s * 10000) / 10000;
    return s;
}

/*
 @abstract 生成随机验证码
 @param codeLength验证码长度
 */
//+ (NSString *)randomCode:(int)codeLength
//{
//    CFUUIDRef uuidObj = CFUUIDCreate(nil);
//	NSString *radomString = [(NSString *)CFUUIDCreateString(nil, uuidObj)  substringToIndex:codeLength];
//	CFRelease(uuidObj);
//	return radomString;
//}

/*
 *截取string的第一个字母
 */
+ (BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT
{
	NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
											   range:NSMakeRange(0, searchT.length)];
	if (result == NSOrderedSame)
    {
        return YES;
    }
	else
    {
        return NO;
    }
}

/*
 *判定string第一位是否是从A-Z
 */
+ (BOOL)isAlphabet:(NSString *)firstAlphabet
{
    NSString *IDENTITYNUM = @"^[A-Z]$";
    NSPredicate *regextestBankNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",IDENTITYNUM];
    if ([regextestBankNum evaluateWithObject:firstAlphabet] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



#pragma mark -
#pragma mark MD5加密16位大写
/*
 *加密字符串
 *
 *@param md5Str
 *  要被加密的字符串
 *
 *@调用举例
 *   [StaticTools Md5For16:@"toMd5Str"];
 */
+ (NSString *)Md5For16:(NSString *)md5Str
{
    const char *original_str = [md5Str UTF8String];
    unsigned char result[16];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString* resultStr = [NSMutableString string];
    for (int i = 0; i <  16; i ++)
    {
        [resultStr appendFormat:@"%02X",result[i]];
    }
    NSString *str = [resultStr uppercaseString];
    return str;
    
}



@end
