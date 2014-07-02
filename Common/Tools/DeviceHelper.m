//
//  DeviceHelper.m
//  QpostTest
//
//  Created by 文彬 on 14-4-27.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "DeviceHelper.h"

@implementation DeviceHelper

static DeviceHelper *instance = nil;

+ (DeviceHelper *) shareDeviceHelper
{
    @synchronized(self)
    {
        if (nil == instance)
        {
            instance = [[DeviceHelper alloc] init];
        }
    }
    
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        qpostLib = [ZftQposLib getInstance];
        [qpostLib setLister:self];
        
        self.failBlock = ^(id mess) {
            
            [SVProgressHUD showErrorWithStatus:mess];
            
        };
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

#pragma mark - qpostDelegate
-(void)onPlugin
{
    NSLog(@"device plugin");
}

-(void)onPlugOut
{
    NSLog(@"device plugout");
}

-(void)onSwiper:(NSString*)cardNum  andcardTrac:(NSString*)cardTrac andpin:(NSString*)cardPin
{
    NSLog(@"cardNum:%@\n,cardTrac:%@\n,cardPin:%@\n",cardNum,cardTrac,cardPin);
    
    [self.infoDict setObject:cardNum forKey:kCardNum];
    [self.infoDict setObject:cardTrac forKey:kCardTrac];
    [self.infoDict setObject:cardPin forKey:kCardPin];
    
}

-(void)onTradeInfo:(NSString*)mac andpsam:(NSString*)psam andtids:(NSString*)tids
{
    
    NSLog(@"mac:%@\n,psam:%@\n,tids:%@\n",mac,psam,tids);
    
    [self.infoDict setObject:mac forKey:kCardMc];
    [self.infoDict setObject:psam forKey:kPsamNum];
    [self.infoDict setObject:tids forKey:kTids];
    
    if (self.onePrameBlock)
    {
        self.onePrameBlock(self.infoDict);
        self.onePrameBlock = nil;
    }
    
 
}

-(void)onError:(NSString*)errmsg
{

    if (self.failBlock)
    {
        self.failBlock(errmsg);
    }
    else //错误的默认处理
    {
        
    }
     NSLog(@"errmsg:%@",errmsg);
}

-(void)doSignInStatus:(NSString *) status
{    
    if (self.onePrameBlock)
    {
        self.onePrameBlock(status);
    }
    
    NSLog(@"do signstatus %@",status);
}

#pragma mark - devicehelper 内部函数
- (void)doGetTerminalID
{
    
    NSString *idStr = [qpostLib getTerminalID];
    NSString *pidStr =[qpostLib getPsamID];
    
    NSLog(@"termina id %@ pidStr is %@",idStr,pidStr);
    if ([StaticTools isEmptyString:idStr])
    {
        if (self.failBlock)
        {
            self.failBlock(@"终端号获取失败,请重试。");
        }
    }
    else if([StaticTools isEmptyString:pidStr])
    {
        if (self.failBlock)
        {
            self.failBlock(@"psam号获取失败,请重试。");
        }
    }
    else
    {
        if (self.onePrameBlock)
        {
            self.onePrameBlock([NSString stringWithFormat:@"%@#%@",idStr,pidStr]);
//            self.onePrameBlock  = nil;
        }
    }
}

#pragma mark - devicehelper对外函数

/**
 *  获取设备版本号
 *
 *  @return
 */
- (NSString*)getDeviceVersion
{
    return [qpostLib getVersionID];
}

/**
 *  判断设备是否插入
 *
 *  @return 
 */
- (BOOL)ispluged
{
    return [qpostLib ispluged];
}


/**
 *  获取设备的终端id号和psamid
 *
 *  @param Sucblock  获取成功的回调
 *  @param failBlock 获取失败的回调 传nil时采用默认处理：弹框提示错误信息
 */
- (void)getTerminalIDWithComplete:(OnePramaBlock)Sucblock Fail:(OnePramaBlock)failBlock
{    
    self.onePrameBlock = Sucblock;
    self.failBlock = failBlock;

    [qpostLib doGetTerminalID:1];
    [self performSelector:@selector(doGetTerminalID) withObject:nil afterDelay:4];
    
}


/**
 *  签到操作
 *
 *  @param block 成功的回调
 *  @param failBlock 失败的回调 传nil时采用默认处理：弹框提示错误信息
 */
-(void)doSignInWithMess:(NSString*)mess Complete:(OnePramaBlock)block Fail:(OnePramaBlock)failBlock
{

    NSLog(@"设备开始签到");
    self.onePrameBlock = block;
    self.failBlock = failBlock;
    
    [qpostLib doSignIn:mess];
}

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
 * @param block 成功的回调
 * @param failBlock 失败的回调 传nil时采用默认处理：弹框提示错误信息
 */
-(void) doTradeEx:(NSString*)amountString
          andType:(NSInteger)type
           Random:(NSString*)random
      extraString:(NSString*)extraString
         TimesOut:(NSInteger)timeout
         Complete:(OnePramaBlock)sucBlock
          andFail:(OnePramaBlock)failBlock
{
    
    NSLog(@"发送刷卡请求");
    self.infoDict = [[NSMutableDictionary alloc]init];
    self.onePrameBlock = sucBlock;
    self.failBlock = failBlock;

    int state = [qpostLib doTradeEx:amountString andType:type andRandom:random andextraString:extraString andTimesOut:timeout];
    
    
    //TODO
    if (state == 0)
    {
       
    }
    else if(state==1)
    {

    }
}

/**
 *  //取消刷卡 未提供刷卡操作  类型传255时可进行取消
 */
- (void)cancleSwipeCard
{
    NSLog(@"取消刷卡");
    [self doTradeEx:@"0" andType:255 Random:nil extraString:@"abc" TimesOut:60 Complete:^(id mess) {
        
    } andFail:^(id mess) {
        
    }];
}

@end
