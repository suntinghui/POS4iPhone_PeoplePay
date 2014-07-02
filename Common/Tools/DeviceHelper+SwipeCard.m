//
//  DeviceHelper+SwipeCard.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-22.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "DeviceHelper+SwipeCard.h"
#import "DeviceSearchViewController.h"
#import "SwipeCardNoticeViewController.h"
#import "StringUtil.h"


@implementation DeviceHelper (SwipeCard)

/**
 *  刷卡操作
 *
 *  @param viewController 需进行刷卡操作的controller
 *  @param type           刷卡的操作类型
 *  @param money          刷卡金额
  * @param other          刷卡的额外参数  如交易号等
 *  @param block          刷卡成功后的回调
 */
- (void)swipeCardWithControler:(UIViewController*)viewController
                          type:(CSwipteCardType)type
                         money:(NSString*)money
                 otherParamter:(NSDictionary*)other
                      sucBlock:(OnePramaBlock)block
{
    if (![[DeviceHelper shareDeviceHelper] ispluged])
    {
        [SVProgressHUD showErrorWithStatus:@"请插入刷卡设备"];
        return;
    }
    
   
    
    self.controller = viewController;
    self.swipeCardType = type;
    self.moneyCount = money;
    self.otherDict = other;
    self.sucBlock = block;
    
    NSString *lastSignTime = [UserDefaults objectForKey:kLastSignTime];
    NSString *currentTime = [StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:NO];
    //一天内只用签到一次
    if (lastSignTime==nil||![currentTime isEqualToString:lastSignTime])
    {
        [self deviceOperatWithType:0];
    }
    else
    {
        [self deviceOperatWithType:1];
    }
}

#pragma mark -http请求

/**
 *  读取设备id和psamdid  然后根据type做处理
 *
 *  @param type 0：发送签到请求  1：发送消费请求
 */
- (void)deviceOperatWithType:(int)type
{
    //加载雷达转圈页面
    DeviceSearchViewController *deviceSearchController = [[DeviceSearchViewController alloc]init];
    deviceSearchController.hidesBottomBarWhenPushed = YES;
    [self.controller.navigationController pushViewController:deviceSearchController animated:YES];
    
    [[DeviceHelper shareDeviceHelper] getTerminalIDWithComplete:^(id mess) {
        
        NSArray *arr = [mess componentsSeparatedByString:@"#"];
        self.tidStr = arr[0];
        self.pidStr = arr[1];
        self.pidStr = [self.pidStr stringByReplacingOccurrencesOfString:@"554E" withString:@"UN"];
        
        if (type==0)
        {
            [self doSign];
        }
        else if(type==1)
        {
            [self doSwipeCard];
        }
    } Fail:^(id mess) {
        
           [StaticTools showErrorPageWithMess:mess clickHandle:^{
            
            //移除雷达转圈页面
            [self.controller.navigationController popViewControllerAnimated:NO];
        }];
        
    }];
}

/**
 *  签到请求
 */
- (void)doSign
{
    NSDictionary *dict = @{kTranceCode:@"199020",
                           kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                                        @"TERMINALNUMBER":self.tidStr,
                                        @"PSAMCARDNO":self.pidStr,
                                        @"TERMINALSERIANO":[[AppDataCenter sharedAppDataCenter] getTradeNumber]}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                             {
                                                 [UserDefaults setObject:obj[@"PINKEY"] forKey:kPinKey];
                                                 [UserDefaults setObject:obj[@"MACKEY"] forKey:kMacKey];
                                                 [UserDefaults setObject:obj[@"ENCRYPTKEY"] forKey:kEncryptKey];
                                                 
                                                 //记录本次签到时间 一天内只用签到一次
                                                 [UserDefaults setObject:[StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:NO] forKey:kLastSignTime];
                                                 [UserDefaults synchronize];
                                                 
                                                 NSString *key = [NSString stringWithFormat:@"%@%@%@",obj[@"ENCRYPTKEY"],obj[@"PINKEY"],obj[@"MACKEY"]];
                                                 [[DeviceHelper shareDeviceHelper]doSignInWithMess:key Complete:^(id mess) {
                                                     
                                                     [self doSwipeCard];
                                                     
                                                 } Fail:^(id mess) {
                                                     
                                                     [StaticTools showErrorPageWithMess:mess clickHandle:^{
                                                         
                                                         //移除刷卡提示动画页面
                                                         [self.controller.navigationController popViewControllerAnimated:NO];
                                                        
                                                     }];
                                                     
                                                 }];
                                                 
                                             }
                                             else
                                             {
                                                 [StaticTools showErrorPageWithMess:obj[@"RSPMSG"] clickHandle:^{
                                                     
                                                     //移除刷卡提示动画页面
                                                     [self.controller.navigationController popViewControllerAnimated:NO];
                                                     
                                                 }];
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             
                                             [StaticTools showErrorPageWithMess:@"操作失败，请稍后再试。" clickHandle:nil];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:nil completeBlock:^(NSArray *operations) {
    }];
    
}

/**
 *  刷卡
 */
- (void)doSwipeCard
{
    
    //移除雷达转圈页面
    [self.controller.navigationController popViewControllerAnimated:NO];
    
    //加载刷卡提示动画页面
    SwipeCardNoticeViewController *swipeCardNoticeController = [[SwipeCardNoticeViewController alloc]init];
    swipeCardNoticeController.hidesBottomBarWhenPushed = YES;
    [self.controller.navigationController pushViewController:swipeCardNoticeController animated:NO];
    
    NSString *dateStr = [StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:YES];
    NSString *date = [dateStr substringWithRange:NSMakeRange(5, 5)];
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *time = [dateStr substringFromIndex:11];
    time = [time stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSString *posNum = [[AppDataCenter sharedAppDataCenter] getTradeNumber];
    NSString *moneyStr = [StringUtil amount2String:self.moneyCount];
    
    NSString *mac = [NSString stringWithFormat:@"%@%@%@%@%@%@",self.otherDict[kTranceCode],moneyStr,posNum,time,date,[StringUtil stringToHexStr:[self.pidStr stringByReplacingOccurrencesOfString:@"UN" withString:@""]]];
    NSLog(@"self.pidStr is %@ self.tidStr is %@",self.pidStr,self.tidStr);
    NSLog(@"mac is %@",mac);
    
    float count = [self.moneyCount floatValue]*100;
    int numcount = count;
    NSString *num = [NSString stringWithFormat:@"%d",numcount];
    
    [[DeviceHelper shareDeviceHelper] doTradeEx:num andType:1 Random:nil extraString:mac TimesOut:30 Complete:^(id mess) {
        
        //移除刷卡提示动画页面
        [self.controller.navigationController popViewControllerAnimated:NO];
        
        if (self.sucBlock)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:mess];
            [dict setObject:posNum forKey:@"TSEQNO"];
            [dict setObject:date forKey:@"TTXNDT"];
            [dict setObject:time forKey:@"TTXNTM"];
            
            self.sucBlock(dict);
        }

    } andFail:^(id mess) {
        
        
        [StaticTools showErrorPageWithMess:mess clickHandle:^{
            //移除刷卡提示动画页面
            [self.controller.navigationController popViewControllerAnimated:NO];
        }];
        
        
    }];
    
}
@end
