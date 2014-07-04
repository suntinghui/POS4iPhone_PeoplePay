//
//  NewPasswordViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-7-4.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "NewPasswordViewController.h"

@interface NewPasswordViewController ()

@end

@implementation NewPasswordViewController

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
    
    self.navigationItem.title = @"密码重置";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    NSString *err = nil;
    
    if ([StaticTools isEmptyString:self.pswTxtField.text])
    {
        err = @"请输入新密码";
    }
    else if([StaticTools isEmptyString:self.pswConfrimTxtField.text])
    {
        err = @"请确认新密码";

    }
    else if(![self.pswConfrimTxtField.text isEqualToString:self.pswTxtField.text])
    {
        err = @"两次输入的密码不一致";
    }
    else if(self.pswTxtField.text.length<6||self.pswTxtField.text.length>10||self.pswConfrimTxtField.text.length<6||self.pswConfrimTxtField.text.length>10)
    {
        err = @"密码的长度为6-10位";
    }
    else if(![StaticTools isValidatePassword:self.pswTxtField.text]||
            ![StaticTools isValidatePassword:self.pswConfrimTxtField.text])
    {
        err = @"密码只能包含数字和字母";
    }
    
    if (err!=nil)
    {
        
        [SVProgressHUD showErrorWithStatus:err];
        return;
    }
    
    [self setPassword];
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
 *  提交 获取系统返回的密码
 */
- (void)setPassword
{
    NSDictionary *dict = @{kTranceCode:@"199004",
                           kParamName:@{@"PHONENUMBER":self.phoneNumber,
                                        @"PASSWORDNEW":self.pswConfrimTxtField.text}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                             {
                                                 [SVProgressHUD showSuccessWithStatus:@"密码重置成功"];
                                                 [self.navigationController popToRootViewControllerAnimated:YES];
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

@end
