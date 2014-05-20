//
//  ConnectTypeSelectViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-20.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：连接类型选择页面---暂时没用到
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface ConnectTypeSelectViewController : BaseViewController<GKPeerPickerControllerDelegate,
    GKSessionDelegate>

@property (nonatomic, strong) GKSession *currentSession;
@property (nonatomic, strong) GKPeerPickerController *picker;

- (IBAction)buttonClickHandle:(id)sender;

@end
