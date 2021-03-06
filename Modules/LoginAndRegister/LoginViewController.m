//
//  LoginViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-26.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "LoginViewController.h"
#import "MerchantViewController.h"
#import "InputMoneyViewController.h"
#import "TradeListViewController.h"
#import "ToolsViewController.h"
#import "TimedoutUtil.h"
#import "ForgetPasswordViewController.h"
#import "SwipeCardNoticeViewController.h"
#import "MyTabBarController.h"
#import "RegisterViewController.h"
#import "LocationHelper.h"

#define Button_Tag_Login         100 //登录按钮
#define Button_Tag_ForgetPwd     101 //
#define Button_Tag_Regiter       102
#define button_Tag_SpeciaAccount 103
#define Button_Tag_NormalAccount 104
#define Button_Tag_RemenberPwd   105 //记住密码

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    addKeyBoardNotification = YES;
    if (IsIPhone5)
    {
        self.bgImgView.image = [UIImage imageNamed:@"ip_dl-bj5"];
    }
    else
    {
        self.bgImgView.image = [UIImage imageNamed:@"ip_dl-bj4"];
    }
    
    [self.nameTxtField setValue:RGBCOLOR(255, 255, 255)forKeyPath:@"_placeholderLabel.textColor"];
    [self.pwdTxtField setValue:RGBCOLOR(255, 255, 255)forKeyPath:@"_placeholderLabel.textColor"
     ];
    
    self.remenberPwdBtn.selected = [UserDefaults boolForKey:kREMEBERPWD];
    if (self.remenberPwdBtn.selected)
    {
        self.pwdTxtField.text = [UserDefaults objectForKey:kPASSWORD];
    }
    NSString *lastName = [UserDefaults objectForKey:KUSERNAME];
    if (lastName!=nil)
    {
        self.nameTxtField.text = lastName;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!isGohome)
    {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    else
    {
        self.pwdTxtField.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

#pragma mark - 功能函数
- (BOOL)checkInputValue
{
    NSString *err = nil;
    if ([StaticTools isEmptyString:self.nameTxtField.text])
    {
        err = @"请输入用户名";
    }
    else if([StaticTools isEmptyString:self.pwdTxtField.text])
    {
        err = @"请输入密码";
    }
    if (err!=nil)
    {
        [SVProgressHUD showErrorWithStatus:err];
        return NO;
    }
    return YES;
}


- (void)gotoHome
{
    isGohome = YES;
    [[NSNotificationCenter defaultCenter] addObserver:ApplicationDelegate selector:@selector(unTouchedTimeUp) name:kNotificationTimeUp object:nil];
    
    NSString *image=IOS7_OR_LATER?@"ip_title_ios7":@"ip_title";
    
    InputMoneyViewController *inputMoneyController = [[InputMoneyViewController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:inputMoneyController];
    [StaticTools setNavigationBarBackgroundImage:nav1.navigationBar withImg:image];
    
    TradeListViewController *tardeListController = [[TradeListViewController alloc]init];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:tardeListController];
    [StaticTools setNavigationBarBackgroundImage:nav2.navigationBar withImg:image];
    
    MerchantViewController *merchantController = [[MerchantViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:merchantController];
    [nav3 setNavigationBarHidden:YES];
//    nav3.hidesBottomBarWhenPushed = YES;
    [StaticTools setNavigationBarBackgroundImage:nav3.navigationBar withImg:image];
    
    ToolsViewController *toolsController = [[ToolsViewController alloc]init];
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:toolsController];
    [StaticTools setNavigationBarBackgroundImage:nav4.navigationBar withImg:image];
    
    NSMutableDictionary *imgDic1 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic1 setObject:[UIImage imageNamed:@"ip_sk"] forKey:@"Default"];
	[imgDic1 setObject:[UIImage imageNamed:@"ip_sk"] forKey:@"Highlighted"];
	[imgDic1 setObject:[UIImage imageNamed:@"ip_sk2"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic2 setObject:[UIImage imageNamed:@"ip_ls"] forKey:@"Default"];
	[imgDic2 setObject:[UIImage imageNamed:@"ip_ls"] forKey:@"Highlighted"];
	[imgDic2 setObject:[UIImage imageNamed:@"ip_ls2"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic3 setObject:[UIImage imageNamed:@"ip_sh"] forKey:@"Default"];
	[imgDic3 setObject:[UIImage imageNamed:@"ip_sh"] forKey:@"Highlighted"];
	[imgDic3 setObject:[UIImage imageNamed:@"ip_sh2"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic4 setObject:[UIImage imageNamed:@"ip_gj"] forKey:@"Default"];
	[imgDic4 setObject:[UIImage imageNamed:@"ip_gj"] forKey:@"Highlighted"];
	[imgDic4 setObject:[UIImage imageNamed:@"ip_gj2"] forKey:@"Seleted"];

    
    NSArray *imgArr = @[imgDic1,imgDic2,imgDic3,imgDic4];
   
    
    
	MyTabBarController *tabcon = [[MyTabBarController alloc] init];
    tabcon.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3,nav4,nil];
	[tabcon setImages:imgArr];
    [tabcon setSelectedIndex:0];
[self.navigationController pushViewController:tabcon animated:YES];
    

}
#pragma mark- 按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Button_Tag_Login: //登录
        {
            if ([self checkInputValue])
            {
                
                if (self.nameTxtField.isFirstResponder||self.pwdTxtField.isFirstResponder)
                {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                        [self.view endEditing:YES];
                    }];
                }
    
                [self loginAction];
            }
        }
            break;
        case Button_Tag_ForgetPwd: //忘记密码
        {
             isGohome = NO;
            ForgetPasswordViewController *forgetPswController = [[ForgetPasswordViewController alloc]init];
            [self.navigationController pushViewController:forgetPswController animated:YES];
           
        }
            break;
        case Button_Tag_RemenberPwd: //记住密码
        {
            self.remenberPwdBtn.selected = !self.remenberPwdBtn.selected;
            [UserDefaults setBool:self.remenberPwdBtn.selected forKey:kREMEBERPWD];
            [UserDefaults synchronize];
        }
            break;
        case Button_Tag_Regiter: //用户注册
        {
            isGohome = NO;
            RegisterViewController *registController = [[RegisterViewController alloc]init];
            [self.navigationController pushViewController:registController animated:YES];
        }
            break;
        case button_Tag_SpeciaAccount: //签约账户
        {
            APPDataCenter.accountType = 0;
        }
            break;
        case Button_Tag_NormalAccount://普通账户
        {
            APPDataCenter.accountType = 1;
        }
            break;
        default:
            break;
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.nameTxtField.isFirstResponder||self.pwdTxtField.isFirstResponder)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view endEditing:YES];
        }];
    }
    
}

#pragma mark -UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTxtField = textField;    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark -keyboard
- (void)keyBoardShowWithHeight:(float)height
{
    CGRect rectForRow=currentTxtField.frame;
    float touchSetY = [[UIScreen mainScreen] bounds].size.height-height;
    if (rectForRow.origin.y+rectForRow.size.height>touchSetY)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0, -(rectForRow.origin.y+rectForRow.size.height-touchSetY), self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}
- (void)keyBoardHidden
{
    [UIView animateWithDuration:0.3 animations:^{
      self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

#pragma mark- HTTP请求
/**
 *  登录
 */
- (void)loginAction
{
    
    NSDictionary *dict;
    if (APPDataCenter.accountType==0)
    {
        dict = @{kTranceCode:@"199002",
                 kParamName:@{@"PHONENUMBER":self.nameTxtField.text,
                              @"PASSWORD":self.pwdTxtField.text,
                              @"PCSIM":@"不能获取"}};
    }
    else if(APPDataCenter.accountType==1)
    {
        dict = @{kTranceCode:@"200008",
                 kParamName:@{@"phoneNum":self.nameTxtField.text,
                              @"operationId":@"initUserLoginInfo",
                              @"password":self.pwdTxtField.text}};
    }

    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                 {
                                                     [UserDefaults setObject:self.nameTxtField.text forKey:KUSERNAME];
                                                     [UserDefaults setObject:self.pwdTxtField.text forKey:kPASSWORD];
                                                     [UserDefaults synchronize];
                                                     
                                                     [self gotoHome];
                                                     
                                                     if (APPDataCenter.userInfoDict!=nil)
                                                     {
                                                         [self uplaodUserLocatonWithName];
                                                     }
                                                   
                                                 }
                                                 else
                                                 {
                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"登录失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在登录..." completeBlock:^(NSArray *operations) {
    }];
    
}

/**
 *  将用户地址信息发送到公司的内部服务器
 */
- (void)uplaodUserLocatonWithName
{
    NSDictionary *infodict = @{kTranceCode:@"200012",
                               kParamName:@{@"MerName":self.nameTxtField.text,
                                            @"Address":APPDataCenter.userInfoDict[kAddress],
                                            @"Latitude":APPDataCenter.userInfoDict[kLatitude],
                                            @"Longitude":APPDataCenter.userInfoDict[kLongitude],
                                            @"operationId":@"setMerAddressInfo"}};
    
    AFHTTPRequestOperation *infoOperation = [[Transfer sharedTransfer] TransferWithRequestDic:infodict
                                                                                       prompt:nil
                                                                                      success:^(id obj)
                                             {
                                                 
                                                 if ([obj isKindOfClass:[NSDictionary class]])
                                                 {
                                                     
                                                     if ([obj[@"RSPCOD"] isEqualToString:@"000000"])
                                                     {
                                                         NSLog(@"商户地理位置信息上传成功");
                                                         
                                                     }
                                                     else
                                                     {
                                                         NSLog(@"商户地理位置信息上传失败");
                                                     }
                                                     
                                                 }
                                                 
                                             }
                                                                                      failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:infoOperation, nil] prompt:nil completeBlock:^(NSArray *operations) {
    }];
    
}
@end
