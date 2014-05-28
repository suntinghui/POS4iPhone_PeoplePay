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
@end
