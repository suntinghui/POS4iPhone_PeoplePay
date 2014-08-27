//
//  SuccessViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-27.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：操作成功提示页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
typedef void(^ButtonClickBlock)();

@interface SuccessViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *messLabel;
@property (strong, nonatomic) ButtonClickBlock clickBlock;
@property (strong, nonatomic) NSString *messStr;

- (IBAction)buttonClickHandle:(UIButton*)button;

@end
