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
#define Button_Tag_Xieyi   102
#define Button_Tag_Select  103
#define Button_Tag_HideTxtRead 104

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
    addKeyBoardNotification = YES;
    self.selectBtn.selected = YES;

    self.txtView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.txtView.layer.borderWidth = 0.5;
    self.txtView.layer.cornerRadius = 8;
    
    self.txtReadView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.txtReadView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -功能函数
/**
 *  查看阅读协议
 */
- (void)showTxtReadView
{
    self.txtReadView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
//    [self.view addSubview:self.txtReadView];
    [UIView animateWithDuration:0.3 animations:^{
       
        self.txtReadView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

/**
 *  隐藏阅读协议
 */
- (void)hideTxtReadView
{
    [UIView animateWithDuration:0.3 animations:^{
           self.txtReadView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
//        [self.txtReadView removeFromSuperview];
    }];
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
        case Button_Tag_Select:
        {
            self.selectBtn.selected = !self.selectBtn.selected;
        }
            break;
        case Button_Tag_Xieyi:
        {

            NSString *file = [[NSBundle mainBundle] pathForResource:@"register" ofType:@"txt"];
            NSString *text = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
            self.txtView.text = text;
            
            [self showTxtReadView];
        }
            break;
        case Button_Tag_HideTxtRead:
        {
            [self hideTxtReadView];
        }
            break;
        case Button_Tag_Commit:
        {
            NSString *err = nil;
            if ([StaticTools isEmptyString:self.phoneTxtField.text])
            {
                err =@"请输入手机号";
            }
            else if(![StaticTools isMobileNumber:self.phoneTxtField.text])
            {
                err = @"请输入一个正确的手机号";
            }
            else if ([StaticTools isEmptyString:self.codeTxtField.text])
            {
                err = @"请输入验证码";
            }
            else if ([StaticTools isEmptyString:self.pswTxtField.text])
            {
                err = @"请输入密码";
            }
            else if ([StaticTools isEmptyString:self.pswConfirmTxtField.text])
            {
                err = @"请确认密码";
            }
            else if (![self.pswConfirmTxtField.text isEqualToString:self.pswTxtField.text])
            {
                err = @"两次输入的密码不一致";
            }
            else if(self.pswConfirmTxtField.text.length<6||self.pswConfirmTxtField.text.length>10||self.pswTxtField.text.length<6||self.pswTxtField.text.length>10)
            {
                err =@"密码的长度只能为6到10位";
            }
            else if(![StaticTools isValidatePassword:self.pswTxtField.text]||
                    ![StaticTools isValidatePassword:self.pswConfirmTxtField.text])
            {
                err = @"密码只能以数字或字母命名";
            }
            
            if (err!=nil)
            {
                [SVProgressHUD showErrorWithStatus:err];
                return;
            }
            
            if(!self.selectBtn.selected)
            {
                [SVProgressHUD showErrorWithStatus:@"请先阅读并同意注册协议"];
                return;
            }
            
//            [self userRegister];
            
            [self registerUser];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTxtField = textField;
}

#pragma mark -keyboard
- (void)keyBoardShowWithHeight:(float)height
{
    CGRect rect=currentTxtField.frame;
    CGRect rectForRow = [self.view convertRect:rect fromView:self.inputView];
    
    float touchSetY = [[UIScreen mainScreen] bounds].size.height-height-64;
    
    if (rectForRow.origin.y+rectForRow.size.height>touchSetY)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0, -(rectForRow.origin.y+rectForRow.size.height-touchSetY)+(IOS7_OR_LATER?64:0), self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}
- (void)keyBoardHidden
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = CGRectMake(0, IOS7_OR_LATER?64:0, self.view.frame.size.width, self.view.frame.size.height);
    }];
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
 *  注册（un平台）
 */
- (void)registerUser
{
    NSDictionary *infodict = @{kTranceCode:@"199001",
                               kParamName:@{@"PHONENUMBER":self.phoneTxtField.text,
                                            @"PASSWORD":self.pswTxtField.text,
                                            @"CPASSWORD":self.pswConfirmTxtField.text,
                                            @"MSCODE":self.codeTxtField.text}};
    
    AFHTTPRequestOperation *infoOperation = [[Transfer sharedTransfer] TransferWithRequestDic:infodict
                                                                                       prompt:nil
                                                                                      success:^(id obj)
                                             {
                                                 
                                                 if ([obj isKindOfClass:[NSDictionary class]])
                                                 {
                                                     
                                                     if ([obj[@"RSPCOD"] isEqualToString:@"00"])
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
/**
 *  用户注册（自有平台）
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
