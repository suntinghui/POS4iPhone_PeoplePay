//
//  PersonSignViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-27.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：交易成功后的个人签名页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "PaintMaskView.h"

@interface PersonSignViewController : BaseViewController
{
    PaintMaskView *painCanvasView;
}
@property (assign, nonatomic) int pageType;  //0:交易成功签名  1：撤销成功签名
@property (strong, nonatomic) NSMutableDictionary *infoDict; //刷卡的信息 前一个页面传过来
@end
