//
//  MyQRcodeViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-9-9.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：我的二维码页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface MyQRcodeViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;

@property (strong, nonatomic) NSString *nameStr; //商户姓名 前一个页面传过来

@end
