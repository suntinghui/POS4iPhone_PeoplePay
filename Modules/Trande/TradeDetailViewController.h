//
//  TradeDetailViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-11.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 // 版权所有。
 //
 // 文件功能描述：交易详情
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface TradeDetailViewController : BaseViewController<UIAlertViewDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;  //状态
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;  //金额
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;   //日期
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;   //卡号
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel; //商户姓名
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *candleBtn;
@property (assign, nonatomic) UIViewController *fatherController;

@property (strong, nonatomic) NSString *tidStr;
@property (strong, nonatomic) NSString *pidStr;
@property (strong, nonatomic) NSDictionary *infoDict;

- (IBAction)buttonClickHandle:(id)sender;
@end
