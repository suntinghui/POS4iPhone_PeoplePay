//
//  AppDelegate.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-26.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TimedoutUtil.h"
#import "Test.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[CusWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginViewController ];
    [StaticTools setNavigationBarBackgroundImage:nav.navigationBar withImg:@"ip_title"];
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
    
    //第一次进入软件时  滑动解锁设置为关闭状态
    if ([UserDefaults objectForKey:kMoveUnlockState]==nil)
    {
        [UserDefaults setObject:@"0" forKey:kMoveUnlockState];
    }
    
    [self.window makeKeyAndVisible];
    
    
    ppp();
    
    [WXApi registerApp:@"wx41fecbb18f303ee2"];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
}

#pragma mark--
#pragma mark--微信相关函数
- (void) viewContent:(WXMediaMessage *) msg
{
    //显示微信传过来的内容
    WXAppExtendObject *obj = msg.mediaObject;
    
    NSString *strTitle = [NSString stringWithFormat:@"消息来自微信"];
    NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void) onShowMediaMessage:(WXMediaMessage *) message
{
    // 微信启动， 有消息内容。
    [self viewContent:message];
}

-(void) onRequestAppMessage
{
    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
    
    //    RespForWeChatViewController* controller = [[RespForWeChatViewController alloc]autorelease];
    //    controller.delegate = self;
    //    [self.viewController presentModalViewController:controller animated:YES];
    
}
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        [self onRequestAppMessage];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        [self onShowMediaMessage:temp.message];
    }
    
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        //        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
        //        NSString *strMsg = [NSString stringWithFormat:@"发送微信消息结果:%d 响应id：%d", resp.errCode,resp.type];
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        //        [alert release];
        
        if (resp.errCode ==0) {
            
//            [self getGoldWithName:[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"] rsptype:@"15" PostType:@"通过微信分享获得积分"];
//            [self showLoadingView:NO];
        }
    }
    //    else if([resp isKindOfClass:[SendAuthResp class]])
    //    {
    //        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
    //        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
    //
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alert show];
    //        [alert release];
    //    }
}


/**
 *	@brief	发送新闻消息
 *
  *	@param 	scene 	分享类型  WXSceneSession:会话 WXSceneTimeline:朋友圈
 *	@param 	title 	标题
 *	@param 	descrip 	详情
 *	@param 	img 	图片 不能超过32k
 *  @param 	url 	微信上点击的详情页url 必须赋值（可赋值为空） 否则无法进入微信程序
 */
- (void) sendNewsContentwithType:(int)type
                           Title:(NSString*)title
                     description:(NSString*)descrip
                      thumbimage:(UIImage*)img
                   withDetailUrl:(NSString*)url

{
    WXMediaMessage *message = [WXMediaMessage message];
    if (title!=nil) {
        message.title = title;
    }
    if (descrip!=nil) {
        message.description = descrip;
    }
    
    if (img!=nil) {
        [message setThumbImage:img];
    }
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = type;
    
    [WXApi sendReq:req];
}

#pragma mark-长时间未操作的回调
/**
 *  长时间未操作
 */
- (void)unTouchedTimeUp
{
    if ([[UserDefaults objectForKey:kMoveUnlockState] isEqualToString:@"1"])
    {
        [StaticTools showLockView];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    else
    {
        [StaticTools showAlertWithTag:0
                                title:nil
                              message:@"由于您长时间未操作，系统自动退出。"
                            AlertType:CAlertTypeDefault
                            SuperView:nil];
        
        UINavigationController *rootNav =(UINavigationController*)self.window.rootViewController;
        [rootNav popToRootViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
   
}


@end
