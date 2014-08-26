//
//  AppDataCenter.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-26.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "AppDataCenter.h"

@implementation AppDataCenter

static AppDataCenter *instance = nil;


+ (AppDataCenter *) sharedAppDataCenter
{
    @synchronized(self)
    {
        if (nil == instance)
        {
            instance = [[AppDataCenter alloc] init];
        }
    }
    
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
    
        
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

/**
 *  获取交易流水号
 *
 *  @return 
 */
- (NSString *)getTradeNumber
{
    NSInteger number = [UserDefaults integerForKey:kTradeNum];
    if (number == 0) {
        number = 1;
    }
    
    [UserDefaults setInteger:(number+1)==1000000?1:(number+1) forKey:kTradeNum];
    [UserDefaults synchronize];
        
    self.tradeNum = [NSString stringWithFormat:@"%06ld", (long)number];
    
    return self.tradeNum;
}

/**
 *  是否可以编辑实名认证信息
 *  Status;// 认证状态 0开通 1关闭 2审核通过3审核未通过4黑名单5审核中6初始状态7只提交了文本信息
 *  @return
 */
- (BOOL)canEditAuthInfo
{
    if (self.userInfoDict==nil)
    {
        return YES;
    }
    
    if ([self.userInfoDict[@"STATUS"] isEqualToString:@"1"]||
        [self.userInfoDict[@"STATUS"] isEqualToString:@"3"]||
        [self.userInfoDict[@"STATUS"] isEqualToString:@"6"]||
        [self.userInfoDict[@"STATUS"] isEqualToString:@"7"]) {
        return YES;
    }
    
    return NO;
}

@end
