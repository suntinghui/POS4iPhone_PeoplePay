//
//  StaticTools+UIOperation.m
//  LivingService
//
//  Created by wenbin on 13-10-24.
//  Copyright (c) 2013年 wenbin. All rights reserved.
//

#import "StaticTools+UIOperation.h"


@implementation StaticTools (UIOperation)


/**
 *  检查开始时间、结束时间的正确性 开始时间必须早于结束时间且都不晚于当前日期 开始时间、结束时间跨度在三个月内
 *
 *  @param startTime 开始时间
 *  @param endTime   结束时间
 *
 *  @return
 */
+ (BOOL)checkTimeWithStart:(NSString*)startTime end:(NSString*)endTime
{
    //若日期只有年、月  都补全day后再进行比较
    if (startTime.length<8)
    {
        startTime = [NSString stringWithFormat:@"%@-1",startTime];
    }
    if (endTime.length<8)
    {
        endTime = [NSString stringWithFormat:@"%@-1",endTime];
    }
    
    NSDate *beginDate =[StaticTools getDateFromDateStr:startTime];
    NSDate *endDate = [StaticTools getDateFromDateStr:endTime];
    NSDate *frontDate = [StaticTools getDateFromDate:endDate withYear:0 month:-3 day:0];
    //取结束日期三个月前的日期 与开始日期比较 来判断是否在三个月跨度内
    NSDate *currentDate = [NSDate date];
    NSString *errStr = nil;
    if([[beginDate earlierDate:currentDate] isEqual:currentDate])
    {
        errStr = @"起始日期不能晚于今天的日期";
    }
    else if([[endDate earlierDate:currentDate] isEqual:currentDate])
    {
         errStr = @"结束日期不能晚于今天的日期";
    }
    else if ([[beginDate earlierDate:endDate] isEqual: endDate])
    {
        errStr = @"起始日期必须早于结束日期";
    }
   
    else if([[beginDate laterDate:frontDate] isEqual:frontDate]&&
            [beginDate compare:frontDate]!=NSOrderedSame)
    {
         errStr = @"查询的日期间隔不能超过三个月";
    }
    
    if (errStr!=nil)
    {
        [StaticTools showAlertWithTag:0
                                title:Nil
                              message:errStr
                            AlertType:CAlertTypeDefault
                            SuperView:nil];
        return NO;
        
    }
    
    return YES;
}


@end
