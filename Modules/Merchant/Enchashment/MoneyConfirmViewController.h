//
//  MoneyConfirmViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-7-2.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：账户提现--密码确认页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface MoneyConfirmViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *myMoneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTxtField;
@property (weak, nonatomic) IBOutlet UILabel *messLabel;

@property (strong, nonatomic) NSString *money;
@property (assign, nonatomic) int opeType;  //0:普通提款 1：快速提款

- (IBAction)buttonClickHandle:(id)sender;

@end
