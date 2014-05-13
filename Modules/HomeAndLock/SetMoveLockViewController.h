//
//  SetMoveLockViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-13.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：设置滑动解锁手势
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "SPLockScreen.h"

@interface SetMoveLockViewController : BaseViewController<LockScreenDelegate>

@property (strong, nonatomic)  SPLockScreen *lockView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@end
