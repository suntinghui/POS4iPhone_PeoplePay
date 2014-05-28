//
//  AppDelegate.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-26.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusWindow.h"
#import "WXApi.h"
#import "BPush.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,
    WXApiDelegate,
    BPushDelegate,
    UIAlertViewDelegate>
{
}
@property (strong, nonatomic) UIWindow *window;

- (void)unTouchedTimeUp;

- (void) sendNewsContentwithType:(int)type
                           Title:(NSString*)title
                     description:(NSString*)descrip
                      thumbimage:(UIImage*)img
                   withDetailUrl:(NSString*)url;
@end
