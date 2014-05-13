//
//  ForgetPasswordViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-11.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "ForgetPasswordViewController.h"

#define Button_Tag_GetCode  100  //获取验证码
#define Button_Tag_Commit   101  //提交

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

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
    self.navigationItem.title = @"忘记密码";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Button_Tag_GetCode:
        {
            if ([StaticTools isEmptyString:self.phoneTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
                return;
            }
            else if(![StaticTools isMobileNumber:self.phoneTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"请输入一个正确的手机号"];
                return;
            }
            
            [self getVerCode];
        }
            break;
        case Button_Tag_Commit:
        {
            if ([StaticTools isEmptyString:self.phoneTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
                return;
            }
            else if ([StaticTools isEmptyString:self.codeTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
                return;
            }
            
            [self getPassword];
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
#pragma mark -UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark -http请求
/**
 *  获取短信验证码
 */
- (void)getVerCode
{
    NSDictionary *dict = @{kTranceCode:@"199018",
                           kParamName:@{@"PHONENUMBER":self.phoneTxtField.text,
                                        @"TOPHONENUMBER":self.phoneTxtField.text,
                                        @"TYPE":@"10001"}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj[@"RSPMSG"] isEqualToString:@"00000"])
                                             {
                                                 
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                             }
                                        }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"登录失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在获取验证码..." completeBlock:^(NSArray *operations) {
    }];
}

/**
 *  提交 获取系统返回的密码
 */
- (void)getPassword
{
    NSDictionary *dict = @{kTranceCode:@"199004",
                           kParamName:@{@"PHONENUMBER":self.phoneTxtField.text,
                                        @"MESSAGECODE":self.codeTxtField.text}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj[@"RSPMSG"] isEqualToString:@"00000"])
                                             {
                                                 
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                             }
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"登录失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在提交..." completeBlock:^(NSArray *operations) {
    }];
}

@end

