//
//  StaticTools+UIOperation.h
//  LivingService
//
//  Created by wenbin on 13-10-24.
//  Copyright (c) 2013年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 // 版权所有。
 //
 // 文件功能描述：具体业务相关的工具函数
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import "StaticTools.h"
#import "ErrorViewController.h"
#import "CaculateViewController.h"
#import "CustomSelectViewController.h"
#import "DateSelectViewController.h"
#import "SuccessViewController.h"

@interface StaticTools (UIOperation)

/**
 *  检查开始时间、结束时间的正确性 开始时间必须早于结束时间且都不晚于当前日期   开始时间、结束时间跨度在三个月内
 */
+ (BOOL)checkTimeWithStart:(NSString*)startTime end:(NSString*)endTime;

//显示宫格解锁页面
+ (void)showLockView;

//显示错误提示页面
+ (void)showErrorPageWithMess:(NSString*)mess clickHandle:(ButtonClickBlock)block;

//显示成功提示页面
+ (void)showSuccessPageWithMess:(NSString*)mess clickHandle:(ButtonClickBlock)block;

//根据交易码和交易状态获取交易信息
+ (NSString*)getTradeMessWithCode:(NSString*)code state:(NSString*)state;

//弹出选择页面
+ (void)showCustomSelectWithControl:(UIViewController*)control
                              title:(NSString*)title
                               Data:(NSArray*)data
                         selectType:(CSelectType)type
                      finishiOpeare:(FinishSelectBlock)finish;

//显示日期选择页面  可包含年、月、日  也可只包含年、月
+ (void)showDateSelectInViewController:(UIViewController*)viewController
                             indexDate:(NSString*)dateStr
                                  type:(kDatePickerType)pickerType
                               clickOk:(DateSelectAction)block;
@end
