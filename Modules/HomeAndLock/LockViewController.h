//
//  LockViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-29.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：宫格滑动解锁页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "SPLockScreen.h"

@interface LockViewController : UIViewController<LockScreenDelegate>

@property (strong, nonatomic)  SPLockScreen *lockView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

- (IBAction)buttonClickHandle:(id)sender;
@end
