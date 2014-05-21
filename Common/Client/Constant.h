//
//  Constant.h
//  LKOA4iPhone
//
//  Created by  STH on 7/27/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//



#import "AppDelegate.h"

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define UserDefaults [NSUserDefaults standardUserDefaults]
#define APPDataCenter [AppDataCenter sharedAppDataCenter]

#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue ]>=7.0)

//判断设备是否IPHONE5
#define IsIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//颜色设置
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


#define DEFAULTHOST                     @"http://211.147.87.24:8092/"
#define kHostAddress                    @"HOSTADDRESS"

#define kTranceCode                     @"TANCECODE" //交易码
#define kParamName                      @"KPARAMNAGE" //交易发送的数据节点 

#define kOnePageSize                    @"5"

//银行卡相关
#define kCardNum                        @"CARDNUM"
#define kCardTrac                       @"CARDTRAC"
#define kCardPin                        @"CARDPIN"
#define kCardMc                         @"MACKEY"
#define kPsamNum                        @"PSAMNUM"
#define kTids                           @"TIDS"

//登录相关
#define kUSERID                         @"userId"         //用户id
#define KUSERNAME                       @"userName"       //用户名
#define kPASSWORD                       @"password"       //用户密码
#define kMoveUnlockPsw                  @"MOVEUNLOCKPSW"  //滑动解锁手势密码 number类型
#define kMoveUnlockState                @"MOVEUNLOCKSTATE"//滑动解锁开关 @"0" 关闭 @"1" 打开
#define kREMEBERPWD                     @"remeberPWD"     //是否记住密码 @"1"：记住  @"0":不记住
#define kAUTOLOGIN                      @"autoLogin"      //是否自动登录 @"1"：自动登录  @"0":不自动登录

#define kLastSignTime                   @"LASTSIGNTIME"   //上次签到时间
#define kTradeNum                       @"TRADENUM"       //交易流水号

#define kPinKey                         @"PINKEY"
#define kMacKey                         @"MACKEY"
#define kEncryptKey                     @"ENCRYPTKEY"


