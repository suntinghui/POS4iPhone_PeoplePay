//
//  MyAccountViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-25.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：我的账户
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface MyAccountViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *myMoneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTxtField;

- (IBAction)buttonClickHandle:(id)sender;

@end
