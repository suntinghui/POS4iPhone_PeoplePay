//
//  ZftQposLib.h
//  ZftQposLib
//
//  Created by rjb on 13-8-1.
//  Copyright (c) 2013年 rjb. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZftDelegate <NSObject>

@required
-(void)onPlugin;
-(void)onPlugOut;
-(void)onSwiper:(NSString*)cardNum  andcardTrac:(NSString*)cardTrac andpin:(NSString*)cardPin;
-(void)onTradeInfo:(NSString*)mac andpsam:(NSString*)psam andtids:(NSString*)tids;
-(void)onError:(NSString*)errmsg;
-(void)doSignInStatus:(NSString *) status;

@end

@interface ZftQposLib : NSObject


/*单例 */
+(ZftQposLib *)getInstance;
/*检测设备是否插入*/
-(BOOL)ispluged;
/*获取版本号*/
+(NSString *) getVersionID;
/*设置监听*/
-(void) setLister:(id<ZftDelegate>)lister;
/**
 * 读取刷卡器ID，并且下发交易指令
 * @param amountString 交易金额（单位：分）
 * @param type  ：0=磁卡密文
 * 				  1=磁卡密文+密码（六位密码）
 *                2=手工输入卡号+磁卡密文+密码
 *                3=二次输入+磁卡密文+密码
 *                4=只刷卡，
 *                5=只输入六位密码,
 *                6=ICcard支付,
 *                7=非接口支付
 *                8=只输入四位密码
 *                9=刷卡输入四位密码
 * @param random 随机数 随意3位数字
 * @param extraString 额外数
 * @param timeout 超时时间
 * @return
 * 	 	0： 成功
 *      1： 超时，刷卡器无响应
 */
-(NSInteger) doTradeEx:(NSString*) amountString andType:(NSInteger) type andRandom:(NSString*)random
        andextraString:(NSString*)extraString andTimesOut:(NSInteger)timeout;
/* 获取设备版本号
 *praram 无
 *return:
 设备版本号  明文格式
 */
-(NSString *) getVersionID;
-(NSString *) getPsamID;

/**尝试去和读卡器通信，获取terminalID
 *输入参数为尝试次数；
 *输出为0： 表示成功； 为1：表示超时。
 */
-(void) doGetTerminalID:(NSInteger) tries;

/**
 * 当doGetTerminalID成功后，可以调用此方法得到当前刷卡器的ID。 得到的ID是一个字符串，ID以明文形式传输
 * doGetTerminalID为异步操作 请避免同时调用doGetTerminalID和getTerminalID
 * 建议在执行doGetTerminalID 2秒后调用get方法获取设备ID
 */

-(NSString*) getTerminalID;


/**
 * 设备签到
 * @param data NSString 签到信息
 * @return
 *   0:成功
 *   1:失败
 */
-(void)doSignIn:(NSString *)strdata;
/**
 * @param time 休眠时间
 * @return
 *      0:  成功
 *      1:  失败
 *      -1: 超时
 *
 */
-(NSInteger)setSleepTime:(NSInteger)time;
/*
 *给POS机器关机
 *
 */
-(void) powerOff;



@end
