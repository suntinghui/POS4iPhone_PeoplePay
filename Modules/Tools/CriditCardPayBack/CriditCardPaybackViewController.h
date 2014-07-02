//
//  CriditCardPaybackViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-7-2.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：信用卡还款页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface CriditCardPaybackViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *cardNumTxtField;
@property (weak, nonatomic) IBOutlet UITextField *moneyTxtField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxtField;

- (IBAction)buttonClickHandle:(id)sender;

@end
