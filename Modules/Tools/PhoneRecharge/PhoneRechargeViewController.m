//
//  PhoneRechargeViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-24.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "PhoneRechargeViewController.h"
#import "TKAddressBook.h"
#import "StringUtil.h"

#define Button_Tag_SelectPhone  100
#define Button_Tag_SelectMoney  101
#define Button_Tag_Commit 102

#define kLastRechargPhone @"LastRechargPhone" //上一次充值的手机号

@interface PhoneRechargeViewController ()

@end

@implementation PhoneRechargeViewController

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
    self.navigationItem.title = @"手机充值";
    
    moneys = @[@"1元",@"50元",@"100元"];
    self.moneyLabel.text = moneys[0];
    
    NSString *lastPhone = [UserDefaults objectForKey:kLastRechargPhone];
    if (lastPhone==nil)
    {
        self.phoneTxtField.text = [UserDefaults objectForKey:KUSERNAME];
    }
    else
    {
        self.phoneTxtField.text = lastPhone;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
 
    UIButton *button =(UIButton*)sender;
    switch (button.tag)
    {
        case Button_Tag_SelectPhone: //选择联系人
        {
            TKContactsMultiPickerController *contactPickController = [[TKContactsMultiPickerController alloc]init];
            contactPickController.delegate = self;
            [self.navigationController pushViewController:contactPickController animated:YES];
        }
            break;
        case Button_Tag_SelectMoney: //选择金额
        {
            
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择充值金额" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:nil];
            
            for (NSString *monye in moneys)
            {
                [sheet addButtonWithTitle:monye];
            }
            [sheet showInView:self.view];
        }
            break;
        case Button_Tag_Commit: //刷卡
        {
            
            if ([StaticTools isEmptyString:self.phoneTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"请输入需要充值的手机号"];
                return;
            }
            if (![StaticTools isMobileNumber:self.phoneTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"请输入一个正确的手机号"];
                return;
            }
            
            [self phoneRecharge];
           
        }
            break;
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark-http请求
- (void)phoneRecharge
{
    NSString *money = [self.moneyLabel.text stringByReplacingOccurrencesOfString:@"元" withString:@""];
    NSString *moneyStr = [StringUtil amount2String:money];
    
    [[DeviceHelper shareDeviceHelper]swipeCardWithControler:self
                                                       type:CSwipteCardTypePhoneRecharge
                                                      money:money
                                              otherParamter:@{kTranceCode:@"708103"}
                                                   sucBlock:^(id mess) {
                                                       
           NSDictionary *dict = @{kTranceCode:@"708103",
                                  kParamName:@{@"SELLTEL_B":[UserDefaults objectForKey:KUSERNAME],
                                               @"phoneNumber_B":self.phoneTxtField.text, //充值手机号
                                               @"Track2_B":[mess[kCardTrac] substringFromIndex:2], //磁道信息
                                               @"TXNAMT_B":moneyStr, //交易金额
                                               @"POSTYPE_B":@"1",    //刷卡器类型
                                               @"CHECKX_B":@"0.0",     //当前经度
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
                                                            
                                                            //保存充值的手机号 下一次自动填充
                                                            [UserDefaults setObject:self.phoneTxtField.text forKey:kLastRechargPhone];
                                                            [UserDefaults synchronize];
                                                            
                                                            [SVProgressHUD showSuccessWithStatus:@"充值成功"];
                                                            [self.navigationController popViewControllerAnimated:YES];
                                                            
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
                                                       
                                                   }];

}
#pragma mark -ContaceSelectDelegate
- (void)contactsMultiPickerController:(TKContactsMultiPickerController*)picker didFinishPickingDataWithInfo:(NSArray*)data;
{
    [self.navigationController popViewControllerAnimated:YES];
    if (data.count>0)
    {
        TKAddressBook *address = data[0];
        self.phoneTxtField.text = address.tel;
    }
 
}
- (void)contactsMultiPickerControllerDidCancel:(TKContactsMultiPickerController*)picker
{
    
}
#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0)
    {
          self.moneyLabel.text = moneys[buttonIndex-1];
    }
  
}

@end
