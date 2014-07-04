//
//  StaticFormatTools.h
//  Mlife
//
//  Created by xuliang on 12-12-27.
//
//

#import <Foundation/Foundation.h>
#import "StaticTools.h"

typedef enum  //给无分隔符日期如：20121212 插入的分割符的类型
{
    kSeperTypeRail,  //横杠 如2013-12-12
    kSeperTypeSlash, //斜杠 如2013/12/12
    kSeperTypeWord   //文字 如2013年12月12日
}kSeperType;

@interface StaticTools(StaticFormatTools)

/*
 @abstract 格式化电话号码
 */
+ (NSString *)formatPhoneNo:(NSString *)phoneNo;
+(NSDate *)convertDateToLocalTime:(NSDate *)forDate;
//从指定日期字符串的初始化一个NSdate
+ (NSDate*)getDateFromDateStr:(NSString*)dateStr;

//获取指定日期的字符串表达式 需要当前日期时传入：[NSDate date] 即可 注意时区转换
+ (NSString *)getDateStrWithDate:(NSDate*)someDate withCutStr:(NSString*)cutStr hasTime:(BOOL)hasTime;

//给一个没有分隔符的日期加入分隔符 如20131312变成 2013-13-12 或2013/12/12 日期可没有日 如：201212
+ (NSString *)insertCharactorWithDateStr:(NSString*)dateStr andSeper:(kSeperType)type;

//指定开始时间和间隔月数  返回从开始时间开始 months个月后的日期  若结束日期超过当前日期  则返回当前日期
+ (NSString*)getEndTimeWithStartTime:(NSString*) time Month:(int)months;

//根据日期获取到星期几
+ (NSString*)getWeakWithDate:(NSDate*)date;

//判断一个字符串是否为整型数字
+ (BOOL) isPUreInt:(NSString*)string;

//判断一个字符串是否为浮点型数字
+ (BOOL) isPUreFloat:(NSString*)string;

//判断邮箱格式是否正确
+ (BOOL)isValidateEmail:(NSString*)email;

//判断密码是否正确（仅包含数字和字母）
+ (BOOL)isValidatePassword:(NSString*)psw;

//判断邮政编码是否正确
+ (BOOL)isValidatePostCode:(NSString*)post;

//将一个数据项为字典的数组按照字典里某个键的值相同的进行分组
+ (NSArray*)componentsSeparatedArray:(NSArray*)theArray byKey:(NSString*)theKey;

//给一个金额字符串插入逗号分隔
+ (NSString*)insertCommaInNumStr:(NSString*)number;

//给一个银行卡号插入星号
+ (NSString*)insertComaInCardNumber:(NSString*)number;
@end

