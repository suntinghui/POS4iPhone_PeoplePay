//
//  MyAccountViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-25.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MoneyConfirmViewController.h"

#define Button_Tag_Fast 100
#define Button_Tag_Nomal 101

@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

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
    self.navigationItem.title = @"我的账户";
    
    [self getProviceData];
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
    switch (button.tag) {
        case Button_Tag_Fast:
        case Button_Tag_Nomal:
        {
            [self.view endEditing:YES];
            
            NSString *allMoney = [self.myMoneyLabel.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
            if ([StaticTools isEmptyString:self.inputTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"请输入提取金额！"];
                return;
            }
            if (![StaticTools isPUreFloat:self.inputTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"提取金额不是一个正确的数字！"];
                return;
            }
            if ([self.inputTxtField.text floatValue]>[allMoney floatValue])
            {
                [SVProgressHUD showErrorWithStatus:@"提取金额不能大于账户余额！"];
                return;
            }
            
            if (state==2)
            {
                [SVProgressHUD showErrorWithStatus:@"账户已冻结"];
                return;
            }
            
            MoneyConfirmViewController *moneyConfirmController = [[MoneyConfirmViewController alloc] init];
            if (Button_Tag_Nomal==button.tag)
            {
                moneyConfirmController.opeType = 0;
            }
            else
            {
                moneyConfirmController.opeType = 1;
            }
            moneyConfirmController.money = self.inputTxtField.text;
            [self.navigationController pushViewController:moneyConfirmController animated:YES];
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

#pragma mark- http请求
/**
 *  获取账户信息
 */
- (void)getProviceData
{
    NSDictionary *dict = @{kTranceCode:@"199026",
                           kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME]}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                 {
                                                     state = [obj[@"ACSTATUS"] intValue];
                                                     self.myMoneyLabel.text = [NSString stringWithFormat:@"￥%@",obj[@"CASHACBAL"]];
                                                     
                                                 }
                                                 else
                                                 {
                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"账户信息获取失败，请稍后再试!"];
                                             
                                         }];
    
    
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在获取账户信息..." completeBlock:^(NSArray *operations) {
    }];
}

@end
