//
//  InputMoneyViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-29.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
// Copyright (C) 众人科技
//
// 文件功能描述：消费--金额输入页面

// 创建标识：
// 修改标识：
// 修改日期：
// 修改描述：
//
//----------------------------------------------------------------*/

#import <UIKit/UIKit.h>

@interface InputMoneyViewController : BaseViewController<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTxtField;
@property (weak, nonatomic) IBOutlet UIView *numView;
@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) NSString *tidStr;
@property (strong, nonatomic) NSString *pidStr;
@property (strong, nonatomic) NSString *rate;  //扣率

- (IBAction)buttonClickHandle:(id)sender;

@end
