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
#import "DeviceHelper+SwipeCard.h"
#import "CaculateViewController.h"

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

#define Button_Tag_Point        110 //点
#define Button_Tag_Delete       111 //删除
#define Button_Tag_SwipeCard    112 //点击刷卡
#define Button_Tag_KeepAccount  113 //现金记账
#define Button_Tag_Cacualte     114 //显示计算器


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
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.tag = Button_Tag_Cacualte;
    button.frame = CGRectMake(0, 5, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"calculator-5"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    //美工未提供点击的灰色背景图片 自己绘制一张图片
    UIGraphicsBeginImageContext(CGSizeMake(100, 100));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 100, 100));
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    for (int i=100; i<112; i++)
    {
        UIButton *button = (UIButton*)[self.numView viewWithTag:i];
        [button setBackgroundImage:newimg forState:UIControlStateHighlighted];
    }
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
                if (end.length>=4)
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
                if (self.inputTxtField.text.length>=10)
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
            [StaticTools tapAnimationWithView:self.moneyView];
            [self performSelector:@selector(swipeCard) withObject:nil afterDelay:0.5];

            
        }
            break;
        case Button_Tag_KeepAccount: //现金记账
        {
            if ([self.inputTxtField.text floatValue] ==0)
            {
                [SVProgressHUD showErrorWithStatus:@"输入的金额不合法"];
                return;
            }
            [self doCashAccount];
        }
            break;
        case Button_Tag_Cacualte: //计算器
        {
            CaculateViewController *caculateController = [[CaculateViewController alloc]init];
            caculateController.fatherController = self;
            caculateController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:caculateController animated:YES];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)swipeCard
{
    if ([self.inputTxtField.text floatValue] ==0)
    {
        [SVProgressHUD showErrorWithStatus:@"输入的金额不合法"];
        return;
    }
    if (![[DeviceHelper shareDeviceHelper] ispluged])
    {
        [SVProgressHUD showErrorWithStatus:@"请插入刷卡设备"];
        return;
    }
    
    
//    [[DeviceHelper shareDeviceHelper]swipeCardWithControler:self money:self.inputTxtField.text sucBlock:^(id mess) {
//        
//        NSString *dateStr = [StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:YES];
//        NSString *date = [dateStr substringWithRange:NSMakeRange(5, 5)];
//        date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        NSString *time = [dateStr substringFromIndex:11];
//        time = [time stringByReplacingOccurrencesOfString:@":" withString:@""];
//        
////        NSString *posNum = [[AppDataCenter sharedAppDataCenter] getTradeNumber];
//        NSString *moneyStr = [StringUtil amount2String:self.inputTxtField.text];
//        
//        NSDictionary *dict = @{kTranceCode:@"199005",
//                               kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
//                                            @"TERMINALNUMBER":[DeviceHelper shareDeviceHelper].tidStr,
//                                            @"PSAMCARDNO":[DeviceHelper shareDeviceHelper].pidStr,
//                                            @"TSEQNO":mess[@"TSEQNO"],
//                                            @"PCSIM":@"获取不到",
//                                            @"TRACK":[mess[kCardTrac] substringFromIndex:2],
//                                            @"CTXNAT":moneyStr, //消费金额
//                                            @"TPINBLK":mess[kCardPin],//支付密码
//                                            @"CRDNO":@"",  //卡号
//                                            @"CHECKX":@"0.0", //横坐标
//                                            @"APPTOKEN":@"APPTOKEN",
//                                            @"TTXNTM":mess[@"TTXNTM"], //交易时间
//                                            @"TTXNDT":mess[@"TTXNDT"], //交易日期
//                                            @"MAC": [StringUtil stringFromHexString:mess[kMacKey]]
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
//    return;
    
    
    
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
            [self doTrade];
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
                                                     
                                                     [self doTrade];
                                                     
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
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:nil completeBlock:^(NSArray *operations) {
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
    swipeCardNoticeController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:swipeCardNoticeController animated:NO];
    
    NSString *dateStr = [StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:YES];
    NSString *date = [dateStr substringWithRange:NSMakeRange(5, 5)];
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *time = [dateStr substringFromIndex:11];
    time = [time stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSString *posNum = [[AppDataCenter sharedAppDataCenter] getTradeNumber];
    NSString *moneyStr = [StringUtil amount2String:self.inputTxtField.text];
    NSString *mac = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"199005",moneyStr,posNum,time,date,[StringUtil stringToHexStr:[self.pidStr stringByReplacingOccurrencesOfString:@"UN" withString:@""]]];
   
    NSLog(@"self.pidStr is %@ self.tidStr is %@",self.pidStr,self.tidStr);
    NSLog(@"mac is %@",mac);
    
    NSString *num = [NSString stringWithFormat:@"%f",[self.inputTxtField.text floatValue]];
    [[DeviceHelper shareDeviceHelper] doTradeEx:num andType:0 Random:nil extraString:mac TimesOut:30 Complete:^(id mess) {
    
        //移除刷卡提示动画页面
        [self.navigationController popViewControllerAnimated:NO];
        
       
        
        NSDictionary *dict = @{kTranceCode:@"199005",
                               kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                                            @"TERMINALNUMBER":self.tidStr,
                                            @"PSAMCARDNO":self.pidStr,
                                            @"TSEQNO":posNum,
                                            @"PCSIM":@"获取不到",
                                            @"TRACK":[mess[kCardTrac] substringFromIndex:2],
                                            @"CTXNAT":moneyStr, //消费金额
                                            @"TPINBLK":mess[kCardPin],//支付密码
                                            @"CRDNO":@"",  //卡号
                                            @"CHECKX":@"0.0", //横坐标
                                            @"APPTOKEN":@"APPTOKEN",
                                            @"TTXNTM":time, //交易时间
                                            @"TTXNDT":date, //交易日期
                                            @"MAC": [StringUtil stringFromHexString:mess[kMacKey]]
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
        }];
        
       
    }];

}

/**
 *  现金记账
 */
- (void)doCashAccount
{
    NSDictionary *dict = @{kTranceCode:@"200002",
                           kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                                        @"curType":@"CNY",
                                        @"transAmt":self.inputTxtField.text,
                                        @"operationId":@"addTransaction"}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"000000"])
                                                 {
                                                    
                                                     [SVProgressHUD showSuccessWithStatus:@"记账成功"];
                                                 }
                                                 else
                                                 {
                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在加载..." completeBlock:^(NSArray *operations) {
    }];
}

@end
