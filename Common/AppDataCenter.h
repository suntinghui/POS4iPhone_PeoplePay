//
//  AppDataCenter.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-26.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：全局的单例类  存放全局的公用数据
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "LeveyTabBarController.h"

@interface AppDataCenter : NSObject

+ (AppDataCenter *) sharedAppDataCenter;

@property (assign, nonatomic) LeveyTabBarController *leveyTabBar; //底部tabbar
@property (strong, nonatomic) NSString *tradeNum; //交易流水号

//获取交易流水号
- (NSString *)getTradeNumber;

@end
