//
//  TradeDetailViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-11.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "TradeDetailViewController.h"
#import "StringUtil.h"
#import "DeviceHelper+SwipeCard.h"
#import "SwipeCardNoticeViewController.h"
#import "DeviceSearchViewController.h"

#define Alert_Tag_TradeCancel  100

@interface TradeDetailViewController ()

@end

@implementation TradeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"交易明细详情";
    
    self.stateLabel.text =  [StaticTools getTradeMessWithCode:self.infoDict[@"TXNCD"] state:self.infoDict[@"TXNSTS"]];
    
    self.moneyLabel.text = [StringUtil string2SymbolAmount:self.infoDict[@"TXNAMT"]];
    self.dateLabel.text = [NSString stringWithFormat:@"%@    %@",[StaticTools insertCharactorWithDateStr:self.infoDict[@"LOGDAT"] andSeper:kSeperTypeRail],[StaticTools getWeakWithDate:[StaticTools getDateFromDateStr:[StaticTools insertCharactorWithDateStr:self.infoDict[@"LOGDAT"] andSeper:kSeperTypeRail]]]];
    self.cardLabel.text = [StaticTools insertComaInCardNumber:self.infoDict[@"CRDNO"]];
    self.merchantNameLabel.text = self.infoDict[@"MERNAM"];
    
    //消费撤销隐藏撤销操作的按钮
    if ([self.infoDict[@"TXNCD"] isEqualToString:@"0200200000"])
    {
        self.candleBtn.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        [[AppDataCenter sharedAppDataCenter].leveyTabBar hidesTabBar:YES animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - http请求
///**
// *  消费撤销
// */
//- (void)tradeCancel
//{
//    if (![[DeviceHelper shareDeviceHelper] ispluged])
//    {
//        [SVProgressHUD showErrorWithStatus:@"请插入刷卡设备"];
//        return;
//    }
//    
//    NSString *money = [StringUtil string2AmountFloat:self.infoDict[@"TXNAMT"]];
//                       
//    [[DeviceHelper shareDeviceHelper]swipeCardWithControler:self money:money sucBlock:^(id mess) {
//        
//        NSString *dateStr = [StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:YES];
//        NSString *date = [dateStr substringWithRange:NSMakeRange(5, 5)];
//        date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        NSString *time = [dateStr substringFromIndex:11];
//        time = [time stringByReplacingOccurrencesOfString:@":" withString:@""];
//        
//        //        NSString *posNum = [[AppDataCenter sharedAppDataCenter] getTradeNumber];
//        
//        NSDictionary *dict = @{kTranceCode:@"199006",
//                               kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
//                                            @"TERMINALNUMBER":[DeviceHelper shareDeviceHelper].tidStr,
//                                            @"PSAMCARDNO":[DeviceHelper shareDeviceHelper].pidStr,
//                                            @"TSEQNO":mess[@"TSEQNO"],
//                                            @"PCSIM":@"获取不到",
//                                            @"TRACK":[mess[kCardTrac] substringFromIndex:2],
//                                            @"CTXNAT":self.infoDict[@"TXNAMT"], //消费金额
//                                            @"TPINBLK":mess[kCardPin],//支付密码
//                                            @"CRDNO":@"",  //卡号
//                                            @"CHECKX":@"0.0", //横坐标
//                                            @"APPTOKEN":@"APPTOKEN",
//                                            @"TTXNTM":mess[@"TTXNTM"], //交易时间
//                                            @"TTXNDT":mess[@"TTXNDT"], //交易日期
//                                            @"MAC": [StringUtil stringFromHexString:mess[kMacKey]],
//                                            @"LOGNO":self.infoDict[@"CRDNO"]
//                                            }};
//        
//        AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
//                                                                                       prompt:nil
//                                                                                      success:^(id obj)
//                                             {
//                                                 
//                                                 
//                                                 if ([obj[@"RSPCOD"] isEqualToString:@"00"])
//                                                 {
//                                                     
//                                                 }
//                                                 else
//                                                 {
//                                                     //                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
//                                                     [StaticTools showErrorPageWithMess:obj[@"RSPMSG"] clickHandle:nil];
//                                                 }
//                                                 
//                                             }
//                                                                                      failure:^(NSString *errMsg)
//                                             {
//                                                 //                                                 [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
//                                                 
//                                                 [StaticTools showErrorPageWithMess:@"操作失败，请稍后再试!" clickHandle:nil];
//                                                 
//                                             }];
//        
//        [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在加载..." completeBlock:^(NSArray *operations) {
//        }];
//        
//    }];
//
//}

#pragma mark -按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    [StaticTools showAlertWithTag:Alert_Tag_TradeCancel
                            title:nil
                          message:@"确定要撤销改交易吗"
                        AlertType:CAlertTypeCacel
                        SuperView:self];
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == Alert_Tag_TradeCancel)
    {
        if (buttonIndex!=alertView.cancelButtonIndex)
        {
//            [self doTradeCancel];
            [self swipeCard];
        }
    }
}

- (void)swipeCard
{
    
    if (![[DeviceHelper shareDeviceHelper] ispluged])
    {
        [SVProgressHUD showErrorWithStatus:@"请插入刷卡设备"];
        return;
    }
    
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
    [self.navigationController pushViewController:deviceSearchController animated:NO];
    
    [[DeviceHelper shareDeviceHelper] getTerminalIDWithComplete:^(id mess) {
        
        self.tidStr = mess;
        self.pidStr = @"UN201410000046"; //TODO
        if (type==0)
        {
            [self doSign];
        }
        else if(type==1)
        {
            [self doTradeCancel];
        }
    } Fail:^(id mess) {
        
        
        //           [SVProgressHUD showErrorWithStatus:mess];
        [StaticTools showErrorPageWithMess:mess clickHandle:^{
            
            //移除雷达转圈页面
            [self.navigationController popViewControllerAnimated:NO];
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
                                                     
                                                     [self doTradeCancel];
                                                     
                                                 } Fail:^(id mess) {
                                                     
                                                     
                                                     //                                                     [SVProgressHUD showErrorWithStatus:mess];
                                                     
                                                     [StaticTools showErrorPageWithMess:mess clickHandle:^{
                                                         
                                                         //移除刷卡提示动画页面
                                                         [self.navigationController popViewControllerAnimated:NO];
                                                         
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
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在签到..." completeBlock:^(NSArray *operations) {
    }];
    
}

/**
 *  撤销请求
 */
- (void)doTradeCancel
{
    
    //移除雷达转圈页面
    [self.navigationController popViewControllerAnimated:NO];
    
    //加载刷卡提示动画页面
    SwipeCardNoticeViewController *swipeCardNoticeController = [[SwipeCardNoticeViewController alloc]init];
    [self.navigationController pushViewController:swipeCardNoticeController animated:NO];
    
    NSString *dateStr = [StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:YES];
    NSString *date = [dateStr substringWithRange:NSMakeRange(5, 5)];
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *time = [dateStr substringFromIndex:11];
    time = [time stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSString *posNum = [[AppDataCenter sharedAppDataCenter] getTradeNumber];

    NSString *mac = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"199006",self.infoDict[@"TXNAMT"],posNum,time,date,[StringUtil stringToHexStr:[self.pidStr stringByReplacingOccurrencesOfString:@"UN" withString:@""]]];
    
    NSLog(@"self.pidStr is %@ self.tidStr is %@",self.pidStr,self.tidStr);
    NSLog(@"mac is %@",mac);
    
    NSString *num = [NSString stringWithFormat:@"%f",[[StringUtil string2AmountFloat:self.infoDict[@"TXNAMT"]] floatValue]];
    [[DeviceHelper shareDeviceHelper] doTradeEx:num andType:1 Random:nil extraString:mac TimesOut:30 Complete:^(id mess) {
        
        //移除刷卡提示动画页面
        [self.navigationController popViewControllerAnimated:NO];
        
        NSDictionary *dict = @{kTranceCode:@"199006",
                               kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                                            @"TERMINALNUMBER":self.tidStr,
                                            @"PSAMCARDNO":self.pidStr,
                                            @"TSEQNO":posNum,
                                            @"PCSIM":@"获取不到",
                                            @"TRACK":[mess[kCardTrac] substringFromIndex:2],
                                            @"CTXNAT":self.infoDict[@"TXNAMT"], //消费金额
                                            @"TPINBLK":mess[kCardPin],//支付密码
                                            @"CRDNO":@"",  //卡号
                                            @"CHECKX":@"0.0", //横坐标
                                            @"APPTOKEN":@"APPTOKEN",
                                            @"TTXNTM":time, //交易时间
                                            @"TTXNDT":date, //交易日期
                                            @"MAC": [StringUtil stringFromHexString:mess[kMacKey]],
                                            @"LOGNO":self.infoDict[@"CRDNO"]
                                            }};
        
        AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                       prompt:nil
                                                                                      success:^(id obj)
                                             {
                                                 
                                                 
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                 {
                                                     if ([self.fatherController respondsToSelector:@selector(refreshList)])
                                                     {
                                                         [self.fatherController performSelector:@selector(refreshList) withObject:nil];
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                         [SVProgressHUD showSuccessWithStatus:@"撤销成功"];
                                                     }
                                                 }
                                                 else
                                                 {
                                                     //                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                     [StaticTools showErrorPageWithMess:obj[@"RSPMSG"] clickHandle:nil];
                                                 }
                                                 
                                             }
                                                                                      failure:^(NSString *errMsg)
                                             {
                                                 //                                                 [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
                                                 
                                                 [StaticTools showErrorPageWithMess:@"操作失败，请稍后再试!" clickHandle:nil];
                                                 
                                             }];
        
        [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在加载..." completeBlock:^(NSArray *operations) {
        }];
        
    } andFail:^(id mess) {
        
        //        [SVProgressHUD showErrorWithStatus:mess];
        
        [StaticTools showErrorPageWithMess:mess clickHandle:^{
            //移除刷卡提示动画页面
            [self.navigationController popViewControllerAnimated:NO];
        }];
        
        
    }];
    
}

@end
