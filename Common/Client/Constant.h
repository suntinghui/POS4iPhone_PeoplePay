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


#define DEFAULTHOST                     @"http://211.147.87.20:8092/"
#define kHostAddress                    @"HOSTADDRESS"

#define kTranceCode                     @"TANCECODE" //交易码
#define kParamName                      @"KPARAMNAGE" //交易发送的数据节点 

#define kOnePageSize                    @"10"

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
#define kUserHeadImage                  @"HEADIMAGE"      //用户头像数据

#define kLastSignTime                   @"LASTSIGNTIME"   //上次签到时间
#define kTradeNum                       @"TRADENUM"       //交易流水号

#define kPinKey                         @"PINKEY"
#define kMacKey                         @"MACKEY"
#define kEncryptKey                     @"ENCRYPTKEY"



//************实名认证相关**************************************
#define kUserName     @"UserName"    //申请人姓名
#define kUserIdCard   @"UserIdCard"  //申请人身份证号码
#define kMerchantName @"MerchantName"//商户名称
#define kServiceType  @"ServiceType" //经营范围
#define kServicePlace @"ServicePlace"//经营地址
#define kDeviceNumber @"DeviceNumber"//设备序列号

//**********存的字典信息 {@"name":@"",@"code":@""}
#define kProvince   @"province"  //省份
#define kCity       @"city"      //城市
#define kBank       @"bank"      //银行


//*********存的字符串
#define kBankPlace  @"bankplace" //网点
#define kCardName   @"cardname"  //开户名
#define kCardNumber @"cardnumber"//银行账户

//******************************************************************


//*********新浪微博*************************
#define kAppKey             @"1288753078"
#define kAppSecret          @"ed8d44e640de2aed3888eeea19dbc24b"
#define kAppRedirectURI     @"http://www.baidu.com"

//#define kAppKey             @"4156530697"
//#define kAppSecret          @"63b17a75c4c04e959006090b5cb07b2f"
//#define kAppRedirectURI     @"http://www.boc.cn"

#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
//***************************************


//*********腾讯微博**********************

#define WiressSDKDemoAppKey     @"801379028"
#define WiressSDKDemoAppSecret  @"3b3b300f243b5eb75e9badb0d98a13bb"
#define REDIRECTURI             @"https://jf365.boc.cn/BOCGIFTORDERNET/pages/bfsh.jsp"

#import "TCWBEngine.h"
//*************************************


