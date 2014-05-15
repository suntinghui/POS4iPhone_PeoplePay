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
{
    int state; //0：输入原始手势  1：第一次输入新手势  2：第二次输入新手势
    NSString *titleStr;
}

@property (strong, nonatomic)  SPLockScreen *lockView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *messLabel;
@property (strong, nonatomic) NSNumber *firstInput; //第一次输入的新手势 用来判断两次输入的手势是否一致

@end
