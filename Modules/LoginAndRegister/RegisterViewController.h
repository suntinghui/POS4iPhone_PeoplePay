//
//  RegisterViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-29.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：注册页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface RegisterViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTxtField;
@property (weak, nonatomic) IBOutlet UITextField *codeTxtField;
@property (weak, nonatomic) IBOutlet UITextField *pswTxtField;
@property (weak, nonatomic) IBOutlet UITextField *pswConfirmTxtField;

- (IBAction)buttonClickHandle:(id)sender;

@end
