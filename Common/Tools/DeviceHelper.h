//
//  DeviceHelper.h
//  QpostTest
//
//  Created by 文彬 on 14-4-27.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：qpos操作类 对pos包的封装
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "Qpost.h"

typedef void(^NoPramaBlock)();
typedef void(^OnePramaBlock)(id mess);


@interface DeviceHelper : NSObject<ZftDelegate>
{
    ZftQposLib *qpostLib;
}

@property (strong, nonatomic) OnePramaBlock onePrameBlock;
@property (strong, nonatomic) OnePramaBlock failBlock;
@property (strong, nonatomic) NSMutableDictionary *infoDict;

//分类不支持添加属性  暂时放这定义
@property (strong, nonatomic) NSString *tidStr;
@property (strong, nonatomic) NSString *pidStr;
@property (strong, nonatomic) NSString *moneyCount;
@property (assign, nonatomic) UIViewController *controller;
@property (strong, nonatomic) OnePramaBlock sucBlock;

+(DeviceHelper*)shareDeviceHelper;

//获取设备版本号
- (NSString*)getDeviceVersion;

//获取设备终端号码和psamid
- (void)getTerminalIDWithComplete:(OnePramaBlock)Sucblock Fail:(OnePramaBlock)failBlock;

//判断设备是否插入
- (BOOL)ispluged;

//签到
-(void)doSignInWithMess:(NSString*)mess Complete:(OnePramaBlock)block Fail:(OnePramaBlock)failBlock;

//刷卡等操作
-(void) doTradeEx:(NSString*)amountString
          andType:(NSInteger)type
           Random:(NSString*)random
      extraString:(NSString*)extraString
         TimesOut:(NSInteger)timeout
         Complete:(OnePramaBlock)sucBlock
          andFail:(OnePramaBlock)failBlock;
@end
