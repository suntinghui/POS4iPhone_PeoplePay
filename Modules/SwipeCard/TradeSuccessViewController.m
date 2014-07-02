//
//  TradeSuccessViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-7-1.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "TradeSuccessViewController.h"

#define Button_Tag_OK 200
#define Button_Tag_Select 201

@interface TradeSuccessViewController ()

@end

@implementation TradeSuccessViewController

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
    
    self.selectBtn.selected  = YES;
    self.phoneTxtField.text = [UserDefaults objectForKey:KUSERNAME];
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
    if (button.tag == Button_Tag_Select)
    {
        self.selectBtn.selected = !self.selectBtn.selected;
        if (self.selectBtn.selected)
        {
            self.phoneTxtField.hidden = NO;
            self.inputBgView.hidden = NO;
            [self.OkBtn setTitle:@"发送小票" forState:UIControlStateNormal];
        }
        else
        {
            self.phoneTxtField.hidden = YES;
            self.inputBgView.hidden = YES;
            [self.OkBtn setTitle:@"确定" forState:UIControlStateNormal];
        }
        
    }
    else if(button.tag == Button_Tag_OK)
    {
        if (self.selectBtn.selected)
        {
            if ([StaticTools isEmptyString:self.phoneTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"请输入接收小票的手机号!"];
                return;
            }
            else if(![StaticTools isMobileNumber:self.phoneTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"请输入一个正确的手机号!"];
                return;
            }
            
            [self sendTrandePic];
        }
        else
        {
            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
        }
    }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -http请求
/**
 *  发送交易小票
 */
- (void)sendTrandePic
{
    NSDictionary *dict = @{kTranceCode:@"199037",
                           kParamName:@{@"PHONENUMBER":self.phoneTxtField.text,
                                        @"LOGNO":self.logNum
                                        }};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             
                                             
                                             if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                             {
                                                 
                                                 [SVProgressHUD showSuccessWithStatus:@"小票已发送，请注意查收。"];
                                                 [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             
                                             [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在加载..." completeBlock:^(NSArray *operations) {
    }];
    
    
}


#pragma mark -UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = CGRectMake(0, -120, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = CGRectMake(0, IOS7_OR_LATER?64:0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

@end
