//
//  MoneyConfirmViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-7-2.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "MoneyConfirmViewController.h"

@interface MoneyConfirmViewController ()

@end

@implementation MoneyConfirmViewController

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
    
    self.myMoneyLabel.text = [NSString stringWithFormat:@"￥%@",self.money];
    if (self.opeType==0)
    {
        self.navigationItem.title = @"普通提款";
        self.messLabel.hidden = YES;
    }
    else if(self.opeType==1)
    {
        self.navigationItem.title = @"快速提款";
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    if ([StaticTools isEmptyString:self.inputTxtField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入登录密码!"];
        return;
    }
    
    [self getCash];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark-http请求
/**
 *  提现
 */
- (void)getCash
{
    NSString *dateStr = [StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:YES];
    NSString *date = [dateStr substringWithRange:NSMakeRange(5, 5)];
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSDictionary *dict = @{kTranceCode:@"199025",
                           kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                                        @"PAYAMT":self.money,
                                        @"PAYTYPE":[NSString stringWithFormat:@"%d",self.opeType==0?2:1],
                                        @"PASSWORD":self.inputTxtField.text,
                                        @"PAYDATE":date}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                 {
                                                     
                                                     [SVProgressHUD showSuccessWithStatus:@"提现成功"];
                                                     [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
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
