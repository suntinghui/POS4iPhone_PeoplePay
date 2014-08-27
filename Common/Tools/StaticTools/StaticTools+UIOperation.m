//
//  StaticTools+UIOperation.m
//  LivingService
//
//  Created by wenbin on 13-10-24.
//  Copyright (c) 2013年 wenbin. All rights reserved.
//

#import "StaticTools+UIOperation.h"
#import "LockViewController.h"

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

/**
 *  显示宫格解锁页面
 */
+ (void)showLockView
{
    LockViewController *lockViewController = [[LockViewController alloc]initWithNibName:@"LockViewController" bundle:nil];
    lockViewController.view.frame = CGRectMake(0, IOS7_OR_LATER?20:0, 320, [[UIScreen mainScreen] bounds].size.height-20);
    [ApplicationDelegate.window addSubview:lockViewController.view];
}

/**
 *  显示错误提示页面
 *
 *  @param mess  错误信息
 *  @param block 点击确定按钮后的操作
 */
+ (void)showErrorPageWithMess:(NSString*)mess clickHandle:(ButtonClickBlock)block
{
    ErrorViewController *errController = [[ErrorViewController alloc]initWithNibName:@"ErrorViewController" bundle:nil];
    errController.clickBlock = block;
    errController.messStr = mess;
    UINavigationController *rootNav = (UINavigationController*)ApplicationDelegate.window.rootViewController;
    [rootNav pushViewController:errController animated:YES];
    
}

/**
 *  显示成功提示页面
 *
 *  @param mess  成提示信息
 *  @param block 点击确定按钮后的操作
 */
+ (void)showSuccessPageWithMess:(NSString*)mess clickHandle:(ButtonClickBlock)block;
{
    SuccessViewController *sucController = [[SuccessViewController alloc]initWithNibName:@"SuccessViewController" bundle:nil];
    sucController.clickBlock = block;
    sucController.messStr = mess;
    UINavigationController *rootNav = (UINavigationController*)ApplicationDelegate.window.rootViewController;
    [rootNav pushViewController:sucController animated:YES];
    
}

/**
 *  根据交易码和交易状态获取交易信息
 *
 *  @param code  交易码
 *  @param state 交易状态
 *
 *  @return
 */
+ (NSString*)getTradeMessWithCode:(NSString*)code state:(NSString*)state
{
    NSString *type = @"";
    if ([code isEqualToString:@"0200000000"])
    {
        type = @"消费";
    }
    else if([code isEqualToString:@"0200200000"])
    {
        type = @"消费撤销";
    }
    
    NSString *stateStr = @"";
    if ([state isEqualToString:@"0"])
    {
        stateStr = @"预计";
    }
    else if ([state isEqualToString:@"S"])
    {
        stateStr = @"成功";
    }
    else if ([state isEqualToString:@"R"])
    {
        stateStr = @"撤销";
    }
    else if ([state isEqualToString:@"C"])
    {
        stateStr = @"冲正";
    }
    else if ([state isEqualToString:@"T"])
    {
        stateStr = @"超时";
    }
    else if ([state isEqualToString:@"F"])
    {
        stateStr = @"失败";
    }
    else if ([state isEqualToString:@"E"])
    {
        stateStr = @"完成";
    }
    
    return [NSString stringWithFormat:@"%@%@",type,stateStr];
    
}

/**
 *  弹出选择页面
 *
 *  @param data   页面数据源 数组类型 元素为字典型 @{@"name":@"",@"code":"@""}
 *  @param title  导航栏标题
 *  @param type   选择类型
 *  @param finish 回调操作
 */
+ (void)showCustomSelectWithControl:(UIViewController*)control
                              title:(NSString*)title
                               Data:(NSArray*)data
                         selectType:(CSelectType)type
                      finishiOpeare:(FinishSelectBlock)finish
{
    CustomSelectViewController *customSelectController = [[CustomSelectViewController alloc]init];
    customSelectController.selectType = type;
    customSelectController.datas = data;
    customSelectController.finishSelect = finish;
    customSelectController.titleStr = title;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:customSelectController];
    if (IOS7_OR_LATER)
    {
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"ip_title_ios7"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }
    else
    {
        [StaticTools setNavigationBarBackgroundImage:nav.navigationBar withImg:@"ip_title"];
    }
    [control presentViewController:nav animated:YES completion:nil];
    
}

/**
 *	@brief	显示日期选择页面
 *
 *	@param 	viewController
 *	@param 	dateStr 	显示页面是默认的被选择的日期 格式为“2013-12-12” 或“2013-12” 或 @“2013”
 *	@param 	pickerType  picker类型
 *  @param  block  点击确定按钮时的回调 返回选择的日期字符串 格式为“2013-12-12” 或“2013-12” 或 @“2013”
 *	@return
 */
+ (void)showDateSelectInViewController:(UIViewController*)viewController
                             indexDate:(NSString*)dateStr
                                  type:(kDatePickerType)pickerType
                               clickOk:(DateSelectAction)block
{
    DateSelectViewController *dateSelectController = [[DateSelectViewController alloc]initWithNibName:@"DateSelectViewController" bundle:[NSBundle mainBundle]];
    dateSelectController.pageType = pickerType;
    dateSelectController.indexDate = dateStr;
    dateSelectController.clickOkAction = block;
    
    //若不设置此属性 推上去后背景会变黑色  必须是rootviewcontroller
    viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [viewController presentModalViewController:dateSelectController animated:YES];
}
@end
