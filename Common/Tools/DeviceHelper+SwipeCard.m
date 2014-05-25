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


- (void)swipeCardWithControler:(UIViewController*)viewController
                         money:(NSString*)money
                      sucBlock:(OnePramaBlock)block
{
    self.controller = viewController;
    self.moneyCount = money;
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
    [self.controller.navigationController pushViewController:deviceSearchController animated:NO];
    [APPDataCenter.leveyTabBar hidesTabBar:YES animated:YES];
    
    [[DeviceHelper shareDeviceHelper] getTerminalIDWithComplete:^(id mess) {
        
        self.tidStr = mess;
        self.pidStr = @"UN201410000046"; //TODO
        if (type==0)
        {
            [self doSign];
        }
        else if(type==1)
        {
            [self doSwipeCard];
        }
    } Fail:^(id mess) {
        
        
        //           [SVProgressHUD showErrorWithStatus:mess];
        [StaticTools showErrorPageWithMess:mess clickHandle:^{
            
            //移除雷达转圈页面
            [self.controller.navigationController popViewControllerAnimated:NO];
            [APPDataCenter.leveyTabBar hidesTabBar:NO animated:YES];
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
                                                     
                                                     
                                                     //                                                     [SVProgressHUD showErrorWithStatus:mess];
                                                     
                                                     [StaticTools showErrorPageWithMess:mess clickHandle:^{
                                                         
                                                         //移除刷卡提示动画页面
                                                         [self.controller.navigationController popViewControllerAnimated:NO];
                                                         [APPDataCenter.leveyTabBar hidesTabBar:NO animated:YES];
                                                     }];
                                                     
                                                 }];
                                                 
                                             }
                                             else
                                             {
                                                 //                                                 [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                 
                                                 [StaticTools showErrorPageWithMess:obj[@"RSPMSG"] clickHandle:nil];
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             //                                             [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
                                             
                                             [StaticTools showErrorPageWithMess:@"操作失败，请稍后再试。" clickHandle:nil];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:nil completeBlock:^(NSArray *operations) {
    }];
    
}

/**
 *  刷卡消费请求
 */
- (void)doSwipeCard
{
    
    //移除雷达转圈页面
    [self.controller.navigationController popViewControllerAnimated:NO];
    
    //加载刷卡提示动画页面
    SwipeCardNoticeViewController *swipeCardNoticeController = [[SwipeCardNoticeViewController alloc]init];
    [self.controller.navigationController pushViewController:swipeCardNoticeController animated:NO];
    [APPDataCenter.leveyTabBar hidesTabBar:YES animated:YES];
    
    NSString *dateStr = [StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:YES];
    NSString *date = [dateStr substringWithRange:NSMakeRange(5, 5)];
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *time = [dateStr substringFromIndex:11];
    time = [time stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSString *posNum = [[AppDataCenter sharedAppDataCenter] getTradeNumber];
    NSString *moneyStr = [StringUtil amount2String:self.moneyCount];
    NSString *mac = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"199005",moneyStr,posNum,time,date,[StringUtil stringToHexStr:[self.pidStr stringByReplacingOccurrencesOfString:@"UN" withString:@""]]];
    NSLog(@"self.pidStr is %@ self.tidStr is %@",self.pidStr,self.tidStr);
    NSLog(@"mac is %@",mac);
    NSString *num = [NSString stringWithFormat:@"%f",[self.moneyCount floatValue]];
    [[DeviceHelper shareDeviceHelper] doTradeEx:num andType:1 Random:nil extraString:mac TimesOut:30 Complete:^(id mess) {
        
        //移除刷卡提示动画页面
        [self.controller.navigationController popViewControllerAnimated:NO];
        
        [APPDataCenter.leveyTabBar hidesTabBar:NO animated:YES];
        
        if (self.sucBlock)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:mess];
            [dict setObject:posNum forKey:@"TSEQNO"];
            [dict setObject:date forKey:@"TTXNDT"];
            [dict setObject:time forKey:@"TTXNTM"];
            self.sucBlock(dict);
        }
        
        
        
        
    } andFail:^(id mess) {
        
        //        [SVProgressHUD showErrorWithStatus:mess];
        
        [StaticTools showErrorPageWithMess:mess clickHandle:^{
            //移除刷卡提示动画页面
            [self.controller.navigationController popViewControllerAnimated:NO];
            [APPDataCenter.leveyTabBar hidesTabBar:NO animated:YES];
        }];
        
        
    }];
    
}
@end
