//
//  PhoneRechargeViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-24.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：手机充值页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "TKContactsMultiPickerController.h"

@interface PhoneRechargeViewController : BaseViewController<UIActionSheetDelegate,
    TKContactsMultiPickerControllerDelegate>
{
    NSArray *moneys;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTxtField;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

- (IBAction)buttonClickHandle:(id)sender;

@end
