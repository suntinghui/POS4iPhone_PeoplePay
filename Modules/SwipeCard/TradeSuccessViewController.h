//
//  TradeSuccessViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-7-1.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：交易成功提示页面--发送交易小票
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface TradeSuccessViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *OkBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxtField;
@property (weak, nonatomic) IBOutlet UIImageView *inputBgView;

@property (strong, nonatomic) NSString *logNum;

- (IBAction)buttonClickHandle:(id)sender;

@end
