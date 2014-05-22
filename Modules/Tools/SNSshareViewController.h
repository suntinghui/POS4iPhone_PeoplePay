//
//  SNSshareViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-22.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：分享到微博
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface SNSshareViewController : BaseViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *inputTxtView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

- (IBAction)buttonClickHandle:(id)sender;

@end
