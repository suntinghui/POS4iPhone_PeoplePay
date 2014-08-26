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
#import "PersonSignViewController.h"
#import "WebViewViewController.h"

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
#define Button_Tag_Notice       115 //


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
        
        self.cashBtn.frame = CGRectMake(self.cashBtn.frame.origin.x, self.cashBtn.frame.origin.y+20, self.cashBtn.frame.size.width, self.cashBtn.frame.size.height);
        self.lineView.frame = CGRectMake(self.lineView.frame.origin.x, self.lineView.frame.origin.y+20, self.lineView.frame.size.width, self.lineView.frame.size.height);
    }
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
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
   
    if (APPDataCenter.rateList.count==0)
    {
        [self getRateData];
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
//            PersonSignViewController *personSignController =[[PersonSignViewController alloc]init];
//            personSignController.logNum = @"14070103019113";
//            personSignController.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:personSignController animated:YES];
//            return;
            
            [StaticTools tapAnimationWithView:self.moneyView];
            
            if ([self.inputTxtField.text floatValue] ==0)
            {
                [SVProgressHUD showErrorWithStatus:@"输入的金额不合法"];
                return;
            }
            
            if (APPDataCenter.rateList==nil)
            {
                [self getRateData];
                return;
            }
            else
            {
                if (APPDataCenter.rateList.count==1) //只有一条扣率方式 默认就是用该条
                {
                    NSDictionary *dict = APPDataCenter.rateList[0];
                    self.rate = dict[@"IDFID"];;
                    [self performSelector:@selector(swipeCard) withObject:nil afterDelay:0.5];
                }
                else //多条扣率数据 让用户选择方式
                {
                    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles: nil];
                    for (NSDictionary *dict in APPDataCenter.rateList)
                    {
                        [sheet addButtonWithTitle:dict[@"IDFCHANNEL"]];
                    }
                    
                    [sheet showInView:self.view.window];
                }
            }
            

            
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
        case Button_Tag_Notice: //问号帮助
        {
            WebViewViewController *webViewController = [[WebViewViewController alloc]initWithWebUrl:[NSString stringWithFormat:@"http://211.147.87.20:8092/Vpm/300134.tran?EPOSFLG=1&PHONENUMBER=%@",[UserDefaults objectForKey:KUSERNAME]] title:@"扣率说明"];
            webViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0)
    {
        NSDictionary *dict = APPDataCenter.rateList[buttonIndex-1];
        self.rate = dict[@"IDFID"];
        NSLog(@"rate %@",self.rate);
        [self performSelector:@selector(swipeCard) withObject:nil afterDelay:0];
    }
 
}

#pragma mark HTTP请求
- (void)swipeCard
{
   [[DeviceHelper shareDeviceHelper]swipeCardWithControler:self
                                                       type:CSwipteCardTypeConsume
                                                      money:self.inputTxtField.text
                                              otherParamter:@{kTranceCode:@"199053"}
                                                   sucBlock:^(id mess) {
        
       NSString *moneyStr = [StringUtil amount2String:self.inputTxtField.text];
    
       NSDictionary *infoDict =   @{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                                    @"TERMINALNUMBER":[DeviceHelper shareDeviceHelper].tidStr,
                                    @"PSAMCARDNO":[DeviceHelper shareDeviceHelper].pidStr,
                                    @"TSEQNO":mess[@"TSEQNO"],
                                    @"PCSIM":@"获取不到",
                                    @"TRACK":[mess[kCardTrac] substringFromIndex:2],
                                    @"CTXNAT":moneyStr, //消费金额
                                    @"TPINBLK":mess[kCardPin],//支付密码
                                    @"CRDNO":@"",  //卡号
                                    @"CHECKX":@"0.0", //横坐标
                                    @"APPTOKEN":@"APPTOKEN",
                                    @"TTXNTM":mess[@"TTXNTM"], //交易时间
                                    @"TTXNDT":mess[@"TTXNDT"], //交易日期
                                    @"MAC": [StringUtil stringFromHexString:mess[kMacKey]],
                                    @"IDFID":self.rate      //扣率
                                    };
    
       PersonSignViewController *personSignController =[[PersonSignViewController alloc]init];
       personSignController.infoDict = [NSMutableDictionary dictionaryWithDictionary:infoDict];
       personSignController.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:personSignController animated:YES];

    }];
}


/**
 *  现金记账
 */
- (void)doCashAccount
{
    NSDictionary *dict = @{kTranceCode:@"200002",
                           kParamName:@{@"phoneNum":[UserDefaults objectForKey:KUSERNAME],
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

/**
 *  获取扣率数据
 */
- (void)getRateData
{
    NSDictionary *dict = @{kTranceCode:@"199038",
                           kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME]}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                 {

                                                     NSMutableArray *arr = [NSMutableArray arrayWithArray:obj[@"TRANDETAILS"]];
                                                       APPDataCenter.rateList = arr;
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
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在获取扣率信息" completeBlock:^(NSArray *operations) {
    }];
    
}
@end
