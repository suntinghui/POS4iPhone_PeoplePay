//
//  FeedBckViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-20.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：意见反馈页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "SKPSMTPMessage.h"

@interface FeedBckViewController : BaseViewController<UITextViewDelegate,
    SKPSMTPMessageDelegate>

@property (weak, nonatomic) IBOutlet UITextView *inputTxtView;
@property (weak, nonatomic) IBOutlet UILabel *messLabel;

- (IBAction)buttonClickHandle:(id)sender;

@end
