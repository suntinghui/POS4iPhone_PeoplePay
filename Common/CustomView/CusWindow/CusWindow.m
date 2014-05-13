//
//  CusWindow.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-12.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "CusWindow.h"
#import "TimedoutUtil.h"

@implementation CusWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];
    
    //打开了滑动解锁
    if ([[UserDefaults objectForKey:kMoveUnlockState] isEqualToString:@"1"])
    {
       [[TimedoutUtil sharedInstance] startTimer];
    }
    
    
}

@end
