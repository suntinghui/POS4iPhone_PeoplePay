//
//  ChangePasswordViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-12.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 // 版权所有。
 //
 // 文件功能描述：修改密码
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPwdTxtField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxtField;
@property (weak, nonatomic) IBOutlet UITextField *pwdConfirdTxtField;

- (IBAction)buttonClickHandle:(id)sender;

@end
