//
//  CriditCardPaybackViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-7-2.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "CriditCardPaybackViewController.h"
#import "StringUtil.h"

@interface CriditCardPaybackViewController ()

@end

@implementation CriditCardPaybackViewController

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
    self.navigationItem.title = @"信用卡还款";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    if ([StaticTools isEmptyString:self.cardNumTxtField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入信用卡卡号"];
        return;
    }
    
    if ([StaticTools isEmptyString:self.moneyTxtField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入还款金额"];
        return;
    }
    
    if (![StaticTools isPUreFloat:self.moneyTxtField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"还款金额不是一个正确的数字"];
        return;
    }
    
    
    [self creditCardPayback];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -http请求
/**
 *  信用卡还款
 */
- (void)creditCardPayback
{
    NSString *moneyStr = [StringUtil amount2String:self.moneyTxtField.text];
    
    [[DeviceHelper shareDeviceHelper]swipeCardWithControler:self
                                                       type:CSwipteCardTypeCriditCardPayback
                                                      money:self.moneyTxtField.text
                                              otherParamter:@{kTranceCode:@"708102"}
                                                   sucBlock:^(id mess) {
                                                       
       NSDictionary *dict = @{kTranceCode:@"708102",
                              kParamName:@{@"SELLTEL_B":[UserDefaults objectForKey:KUSERNAME],
                                           @"CRDNO1_B":self.cardNumTxtField.text, //信用卡卡号
                                           @"phoneNumber_B":self.phoneTxtField.text==nil?@"":self.phoneTxtField.text, //接收手机号
                                           @"Track2_B":[mess[kCardTrac] substringFromIndex:2], //磁道信息
                                           @"TXNAMT_B":moneyStr, //交易金额
                                           @"POSTYPE_B":@"1",    //刷卡器类型
                                           @"CHECKX":@"0.0",     //当前经度
                                           @"CHECKY_B":@"0.0",   //当前纬度
                                           @"TERMINALNUMBER_B":[mess[kPsamNum] stringByReplacingOccurrencesOfString:@"554E" withString:@"UN"],//机器psam号
                                           @"CRDNOJLN_B":mess[kCardPin],
                                           @"MAC_B":[StringUtil stringFromHexString:mess[kMacKey]],
                                           @"TTxnTm_B":mess[@"TTXNTM"], //交易时间
                                           @"TTxnDt_B":mess[@"TTXNDT"], //交易日期
                                           @"TSeqNo_B":mess[@"TSEQNO"]
                                           }};
       
       AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                      prompt:nil
                                                                                     success:^(id obj)
                                            {
                                                if ([obj isKindOfClass:[NSDictionary class]])
                                                {
                                                    if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                    {
                                                        
                                                        [SVProgressHUD showSuccessWithStatus:@"还款成功"];
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                    }
                                                    else
                                                    {
                                                        [StaticTools showErrorPageWithMess:obj[@"RSPMSG"] clickHandle:nil];
                                                    }
                                                    
                                                }
                                                
                                            }
                                                                                     failure:^(NSString *errMsg)
                                            {
                                                [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
                                                
                                            }];
       
       
       
       [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在加载..." completeBlock:^(NSArray *operations) {
       }];
                                                       
                                                   }];

}

@end
