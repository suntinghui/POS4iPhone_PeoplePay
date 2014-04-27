//
//  StaticTools+UIOperation.h
//  LivingService
//
//  Created by wenbin on 13-10-24.
//  Copyright (c) 2013年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
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


@interface StaticTools (UIOperation)

/**
 *  检查开始时间、结束时间的正确性 开始时间必须早于结束时间且都不晚于当前日期   开始时间、结束时间跨度在三个月内
 */
+ (BOOL)checkTimeWithStart:(NSString*)startTime end:(NSString*)endTime;

@end
