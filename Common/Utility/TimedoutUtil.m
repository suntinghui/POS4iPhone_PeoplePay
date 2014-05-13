//
//  TimedoutUtil.m
//  POS2iPhone
//
//  Created by  STH on 4/27/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import "TimedoutUtil.h"

@implementation TimedoutUtil

static TimedoutUtil *instance = nil;

+ (TimedoutUtil *) sharedInstance
{
    @synchronized(self)
    {
        if (nil == instance) {
            instance = [[TimedoutUtil alloc] init];
        }
    }
    
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    
    return nil;
}

- (void) startTimer
{
    if ([timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:60*kMaxMin target:self selector:@selector(timedout) userInfo:nil repeats:NO];
}

- (void) timedout
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTimeUp object:nil];
            
    NSLog(@"untouchup");
    
}

- (void) stopTimer
{
    if ([timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
}


@end
