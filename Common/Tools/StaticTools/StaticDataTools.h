//
//  StaticDataTools.h
//  Mlife
//
//  Created by xuliang on 12-12-27.
//
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 // 版权所有。
 //
 // 文件功能描述：数据存储和日期相关的工具函数
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "StaticTools.h"


@interface StaticTools(StaticDataTools)

typedef enum
{
	/** pList */
	DataModePlist,
	/** UserDefault */
	DataModeUserDefault,
	/** DB */
	DataModeDB
} DataMode;

#pragma mark -
#pragma mark 文件(夹)操作 Functions
/*
 @abstract 检查Documents里是否有此文件
 */
+ (BOOL)fileExistsAtPath:(NSString *)fileName;

/*
 获得相应文件路径
 */
+ (NSString *)getFilePath:(NSString *)fileName;

/*
 @abstract 从ducument文件夹中的userInfo.plist提取UserName
 */
+ (NSString *)getUserNameFromPlist;

/*
 @abstract 获取临时文件大小
 */
+ (unsigned long long)getCacheSize;

/*
 @abstract 保存数据到缓存
 */
+ (void)saveData:(NSMutableArray *)dataArray cacheType:(NSString *)cacheType dataNum:(NSInteger)num;

/*
 @abstract 取出指定缓存数据
 */
+ (NSMutableArray *)getCacheArray:(NSString *)cacheType;

/*
 @abstract 删除指定缓存数据
 */
+ (void)removeDataForKey:(NSString *)key;

/*
 @abstract 清空缓存数据
 */
+ (void)clearCacheArray;


#pragma mark -
#pragma mark 字符串操作 Functions
/*
 @abstract 校验字符串是否为空
 */
+ (BOOL)isEmptyString:(NSString *)string;

/*
 @abstract 判断邮政编码格式是否正确
 */
+ (BOOL)checkZipCode:(NSString *)coder;

/*
 @abstract 判断输入是否全部都是数字
 */
+ (BOOL)checkAllIsNumber:(NSString *)psw;

#pragma mark - 判断输入，只能输入数字和小数点
+ (BOOL)isContainsNum:(NSString *)string;

/*
 @abstract 判断输入是否全部都是字符（不允许有汉字、数字等） 不能为空
 */
+ (BOOL)checkAllIsLetter:(NSString *)psw;

/*
 @abstract 判断用户名 1：小于30位。2：数字＋字母。3：不能包含其它字符
 */
+ (BOOL)checkUserName:(NSString *)psw;

/*
 @abstract 判断密码 1：8－16位置。2：数字＋字母。3：不能全是数字或全是字母
 */
+ (BOOL)checkPsw:(NSString *)psw;

/*
 @abstract 正则判断手机号码地址格式
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/*
 @abstract 判断固定电话号码是否合法
 */
+ (BOOL)isTellPhoneNumber:(NSString *)mobileNum;


#pragma mark -
#pragma mark 时间相关 Funcitons
/*
 @abstract 获取当前时间 精确到毫秒
 */
+ (NSString *)getCurrencyTime;

/*
 @abstract 判断两个时间的日期间隔  日期的格式必须是2011－01－01或者2011/01/01
 */
+ (double)checkTimeInterval:(NSString *)beginData endData:(NSString *)endData;

/*
 @abstract 取得今天的日期 yyyy-MM-dd
 */
+ (NSString *)getTodayDate;

/*
 @abstract 取得今天的日期 MM月dd日
 */
+ (NSString *)getDateNoYearWithStr:(NSString *)dateStr;
+ (NSString *)getTodayYear;
+ (NSString *)getTodayMonth;

/*
 @abstract 取得今天星期几
 */
+ (NSString *)getWeekdayWithStr:(NSString *)dateStr;

/*
 @abstract 取得startDate后days的日期 yyyy-MM-dd
 */
+ (NSString *)getAfterDate:(NSDate *)startDate days:(int)days;

/**
 *	@brief	取得对指定日期进行年、月、日加减后的日期
 */
+ (NSDate*)getDateFromDate:(NSDate*)someDate
                  withYear:(int)changYear
                     month:(int)changeMonth
                       day:(int)changeDay;
/*
 @abstract 16进制颜色(html颜色值)字符串转为UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

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
           lngX:(double)lngX ;

/*
 @abstract 生成随机验证码
 @param codeLength验证码长度
 */
+ (NSString *)randomCode:(int)codeLength;

/*
 *截取string的第一个字母
 */
+ (BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT;

/*
 *判定string第一位是否是从A-Z
 */
+ (BOOL)isAlphabet:(NSString *)firstAlphabet;


#pragma mark -
#pragma mark MD5加密16位大写
+ (NSString *)Md5For16:(NSString *)md5Str;

//获取当前软件版本
+ (NSString*)getCurrentVersion;

@end


