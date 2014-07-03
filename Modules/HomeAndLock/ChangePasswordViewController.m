//
//  ChangePasswordViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-12.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

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
    self.navigationItem.title = @"修改密码";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -功能函数
/**
 *  检查页面输入合法性
 *
 *  @return
 */
- (BOOL)checkInputValue
{
    NSString *err = nil;
    if ([StaticTools isEmptyString:self.oldPwdTxtField.text])
    {
      err = @"请输入原始密码";
    }
    else if ([StaticTools isEmptyString:self.pwdTxtField.text])
    {
        err = @"请输入新密码";
    }
    else if ([StaticTools isEmptyString:self.pwdConfirdTxtField.text])
    {
        err = @"请再次输入新密码";
    }
    else if(![self.pwdTxtField.text isEqualToString:self.pwdConfirdTxtField.text])
    {
        err = @"两次输入的密码不一致";
    }
    
    if (err!=nil)
    {
        [SVProgressHUD showErrorWithStatus:err];
        return NO;
    }
    
    return YES;
}

#pragma mark -按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    if ([self checkInputValue])
    {
        [self changePassword];
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
 *  修改密码
 */
- (void)changePassword
{
    NSDictionary *dict;
    if (APPDataCenter.accountType==0)
    {
        dict = @{kTranceCode:@"199003",
                 kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                              @"PASSWORD":self.oldPwdTxtField.text,
                              @"PASSWORDNEW":self.pwdConfirdTxtField.text}};
    }
    else if(APPDataCenter.accountType==1)
    {
        dict = @{kTranceCode:@"200009",
                 kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                              @"PASSWORD":self.oldPwdTxtField.text,
                              @"PASSWORDNEW":self.pwdConfirdTxtField.text,
                              @"operationId":@"UpdateUserPassword"}};
    }
 
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                             {
                                                 [SVProgressHUD showSuccessWithStatus:@"密码修改成功，请重新登录。"];
                                                 UINavigationController *rootNav = (UINavigationController*)ApplicationDelegate.window.rootViewController;
                                                 [rootNav popToRootViewControllerAnimated:YES];
                                                 
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
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在提交..." completeBlock:^(NSArray *operations) {
    }];
}
@end
