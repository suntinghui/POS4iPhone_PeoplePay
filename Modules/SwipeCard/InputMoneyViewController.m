//
//  InputMoneyViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-29.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "InputMoneyViewController.h"
#import "DeviceSearchViewController.h"
#import "SwipeCardNoticeViewController.h"
#import "StringUtil.h"

#define Button_Tag_Zearo 100  //0
#define Button_Tag_One   101  //1
#define Button_Tag_Two   102  //2
#define Button_Tag_Three 103  //3
#define Button_Tag_Four  104  //4
#define Button_Tag_Five  105  //5
#define Button_Tag_Six   106  //6
#define Button_Tag_Seven 107  //7
#define Button_Tag_Eight 108  //8
#define Button_Tag_Nine  109  //9

#define Button_Tag_Plus         110 //加
#define Button_Tag_Minus        111 //减
#define Button_Tag_Multiply     112 //乘
#define Button_Tag_Division     113 //除
#define Button_Tag_Delete       114 //删除
#define Button_Tag_SwipeCard    115 //点击刷卡
#define Button_Tag_KeepAccount  116 //现金记账
#define Button_Tag_Point        117 //点


@interface InputMoneyViewController ()

@end

@implementation InputMoneyViewController

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
    self.navigationItem.hidesBackButton = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"刷卡";
    self.inputTxtField.text = @"0";
    if (IsIPhone5)
    {
        self.numView.frame = CGRectMake(0, self.numView.frame.origin.y+90, self.numView.frame.size.width, self.numView.frame.size.height);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [APPDataCenter.leveyTabBar hidesTabBar:NO animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Button_Tag_One: //数字输入 最多输入两位小数 最多输入12位（不包括小数部分）
        case Button_Tag_Two:
        case Button_Tag_Three:
        case Button_Tag_Four:
        case Button_Tag_Five:
        case Button_Tag_Six:
        case Button_Tag_Seven:
        case Button_Tag_Eight:
        case Button_Tag_Nine:
        case Button_Tag_Zearo:
        {
            if ([self.inputTxtField.text isEqualToString:@"0"])
            {
                self.inputTxtField.text = @"";
            }
            else if([self.inputTxtField.text rangeOfString:@"."].location!=NSNotFound)
            {
                NSString *end = [self.inputTxtField.text componentsSeparatedByString:@"."][1];
                if (end.length>=2)
                {
                    return;
                }
                
                if (self.inputTxtField.text.length>=15)
                {
                    return;
                }
            }
            else if([self.inputTxtField.text rangeOfString:@"."].location==NSNotFound)
            {
                if (self.inputTxtField.text.length>=12)
                {
                    return;
                }
            }
            
            self.inputTxtField.text = [NSString stringWithFormat:@"%@%d",self.inputTxtField.text, button.tag-100];
        }
            break;
        case Button_Tag_Point://小数点
        {
            if(![self.inputTxtField.text isEqualToString:@""] && ![self.inputTxtField.text isEqualToString:@"-"])
            {
                NSString *currentStr = self.inputTxtField.text;
                BOOL notDot = ([self.inputTxtField.text rangeOfString:@"."].location == NSNotFound);
                if (notDot)
                {
                    currentStr= [currentStr stringByAppendingString:@"."];
                    self.inputTxtField.text= currentStr;
                }
            }
        }
            break;
        case Button_Tag_Delete: //删除
        {
            if ([self.inputTxtField.text isEqualToString:@"0"])
            {
                return;
            }
            if (self.inputTxtField.text.length>0)
            {
                NSString *current = [NSString stringWithString:self.inputTxtField.text];
                self.inputTxtField.text = [current substringToIndex:current.length-1];
            }
            
            if (self.inputTxtField.text.length==0)
            {
                self.inputTxtField.text = @"0";
            }
         
        }
            break;
        case Button_Tag_SwipeCard: //刷卡
        {

//            [[DeviceHelper shareDeviceHelper] getPsamIDWithComplete:^(id mess) {
//                
//            } Fail:^(id mess) {
//                
//            }];
//            return;
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
                 [self deviceOperatWithType:0];
            }
            
        }
            break;
        case Button_Tag_KeepAccount: //现金记账
        {
            [SVProgressHUD showSuccessWithStatus:@"记账成功"];
            
        }
            break;
            
        default:
            break;
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
            [self doTrade];
        }
    } Fail:^(id mess) {
        
        
//           [SVProgressHUD showErrorWithStatus:mess];
        [StaticTools showErrorPageWithMess:mess clickHandle:^{
            
            //移除雷达转圈页面
            [self.navigationController popViewControllerAnimated:NO];
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
                                                     
                                                     [self doTrade];
                                                     
                                                 } Fail:^(id mess) {
                                                     
                                                    
//                                                     [SVProgressHUD showErrorWithStatus:mess];
                                                     
                                                     [StaticTools showErrorPageWithMess:mess clickHandle:^{
                                                         
                                                         //移除刷卡提示动画页面
                                                         [self.navigationController popViewControllerAnimated:NO];
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
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在签到..." completeBlock:^(NSArray *operations) {
    }];
    
}

/**
 *  刷卡消费请求
 */
- (void)doTrade
{
 
    //移除雷达转圈页面
    [self.navigationController popViewControllerAnimated:NO];
    
    //加载刷卡提示动画页面
    SwipeCardNoticeViewController *swipeCardNoticeController = [[SwipeCardNoticeViewController alloc]init];
    [self.navigationController pushViewController:swipeCardNoticeController animated:NO];
    [APPDataCenter.leveyTabBar hidesTabBar:YES animated:YES];

    NSString *dateStr = [StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:YES];
    NSString *date = [dateStr substringWithRange:NSMakeRange(5, 5)];
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *time = [dateStr substringFromIndex:11];
    time = [time stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSString *posNum = [[AppDataCenter sharedAppDataCenter] getTradeNumber];
    NSString *moneyStr = [StringUtil amount2String:self.inputTxtField.text];
    NSString *mac = [NSString stringWithFormat:@"%@%@%@%@%@UN%@",@"199005",moneyStr,posNum,time,date,[self.pidStr substringFromIndex:4]];
    [[DeviceHelper shareDeviceHelper] doTradeEx:@"1" andType:1 Random:@"123" extraString:mac TimesOut:30 Complete:^(id mess) {
    
        //移除刷卡提示动画页面
        [self.navigationController popViewControllerAnimated:NO];
        [APPDataCenter.leveyTabBar hidesTabBar:NO animated:YES];
        
       
        
        NSDictionary *dict = @{kTranceCode:@"199005",
                               kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                                            @"TERMINALNUMBER":self.tidStr,
                                            @"PSAMCARDNO":self.pidStr,
                                            @"TSEQNO":posNum,
                                            @"PCSIM":@"获取不到",
                                            @"TRACK":[mess[kCardTrac] substringFromIndex:2],
                                            @"CTXNAT":moneyStr, //消费金额
                                            @"TPINBLK":mess[kCardPin],//支付密码
                                            @"CRDNO":mess[kCardNum],  //卡号
                                            @"CHECKX":@"0.0", //横坐标
                                            @"APPTOKEN":@"APPTOKEN",
                                            @"TTXNTM":time, //交易时间
                                            @"TTXNDT":date, //交易日期
                                            @"MAC": [StringUtil longToHex:[mess[kCardMc] longLongValue]]
                                            }};
        
        AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                       prompt:nil
                                                                                      success:^(id obj)
                                             {
                                                 
                                                 
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                 {
                                                     
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
            [APPDataCenter.leveyTabBar hidesTabBar:NO animated:YES];
        }];
        
       
    }];


}


@end
