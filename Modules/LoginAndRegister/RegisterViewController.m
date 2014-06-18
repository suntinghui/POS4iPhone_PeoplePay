//
//  RegisterViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-29.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "RegisterViewController.h"


#define Button_Tag_GetCode 100
#define Button_Tag_Commit 101

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    
    self.navigationItem.title = @"用户注册";
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
            else if(![StaticTools isMobileNumber:self.phoneTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"请输入一个正确的手机号"];
                return;
            }
            else if ([StaticTools isEmptyString:self.codeTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
                return;
            }
            else if ([StaticTools isEmptyString:self.pswTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"请输入密码"];
                return;
            }
            else if ([StaticTools isEmptyString:self.pswConfirmTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"请确认密码"];
                return;
            }
            else if (![self.pswConfirmTxtField.text isEqualToString:self.pswTxtField.text])
            {
                [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
                return;
            }
            
            [self userRegister];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = CGRectMake(0, IOS7_OR_LATER?64:0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
}
#pragma mark -UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==self.pswTxtField||textField==self.pswConfirmTxtField)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0, -150, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
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
                                        @"TYPE":@"100002"}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj[@"RSPMSG"] isEqualToString:@"000000"])
                                             {
                                                 [SVProgressHUD showSuccessWithStatus:@"短信发送成功"];
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
 *  用户注册
 */
- (void)userRegister
{
    NSDictionary *infodict = @{kTranceCode:@"200007",
                               kParamName:@{@"phoneNum":self.phoneTxtField.text,
                                            @"password":self.pswTxtField.text,
                                            @"operationId":@"setUserInfo"}};
    
    AFHTTPRequestOperation *infoOperation = [[Transfer sharedTransfer] TransferWithRequestDic:infodict
                                                                                       prompt:nil
                                                                                      success:^(id obj)
                                             {
                                                 
                                                 if ([obj isKindOfClass:[NSDictionary class]])
                                                 {
                                                     
                                                     if ([obj[@"RSPCOD"] isEqualToString:@"000000"])
                                                     {
                                                         
                                                         [SVProgressHUD showSuccessWithStatus:@"注册成功"];
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
                                                 [SVProgressHUD showErrorWithStatus:@"注册失败!"];
                                                 
                                             }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:infoOperation, nil] prompt:@"正在加载..." completeBlock:^(NSArray *operations) {
    }];
    
}
@end
