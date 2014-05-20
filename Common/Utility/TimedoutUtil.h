//
//  TimedoutUtil.h
//  POS2iPhone
//
//  Created by  STH on 4/27/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMaxMin  10  //用户不操作时 退出到登陆页面的时间（分钟）

#define kNotificationTimeUp @"UNTOUCHEDTIMEUP"//到达最大时间时 发出的通知

@interface TimedoutUtil : NSObject

{
    NSTimer *timer;
}

+ (TimedoutUtil *) sharedInstance;

- (void) startTimer;
- (void) stopTimer;

@end
