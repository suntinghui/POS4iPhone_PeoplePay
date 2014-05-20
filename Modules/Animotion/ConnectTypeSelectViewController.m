//
//  ConnectTypeSelectViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-20.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "ConnectTypeSelectViewController.h"
#import "MerchantViewController.h"
#import "LeveyTabBarController.h"
#import "InputMoneyViewController.h"
#import "TradeListViewController.h"
#import "ToolsViewController.h"

#define Button_Tag_BlueTooth  100
#define Button_Tag_Line       101

@interface ConnectTypeSelectViewController ()

@end

@implementation ConnectTypeSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -功能函数
/**
 *  弹出系统蓝牙连接页面
 */
- (void)showBlutoothPicker
{
    self.picker = [[GKPeerPickerController alloc] init];
    self.picker.delegate = self;
    self.picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [self.picker show];
}


- (void)gotoHome
{
    
    InputMoneyViewController *inputMoneyController = [[InputMoneyViewController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:inputMoneyController];
    [StaticTools setNavigationBarBackgroundImage:nav1.navigationBar withImg:@"ip_title"];
    
    TradeListViewController *tardeListController = [[TradeListViewController alloc]init];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:tardeListController];
    [StaticTools setNavigationBarBackgroundImage:nav2.navigationBar withImg:@"ip_title"];
    
    MerchantViewController *merchantController = [[MerchantViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:merchantController];
    [nav3 setNavigationBarHidden:YES];
    [StaticTools setNavigationBarBackgroundImage:nav3.navigationBar withImg:@"ip_title"];
    
    ToolsViewController *toolsController = [[ToolsViewController alloc]init];
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:toolsController];
    [StaticTools setNavigationBarBackgroundImage:nav4.navigationBar withImg:@"ip_title"];
    
    NSArray *ctlArr = @[nav1,nav2,nav3,nav4];
    
    NSMutableDictionary *imgDic1 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic1 setObject:[UIImage imageNamed:@"ip_sk"] forKey:@"Default"];
	[imgDic1 setObject:[UIImage imageNamed:@"ip_sk"] forKey:@"Highlighted"];
	[imgDic1 setObject:[UIImage imageNamed:@"ip_sk2"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic2 setObject:[UIImage imageNamed:@"ip_ls"] forKey:@"Default"];
	[imgDic2 setObject:[UIImage imageNamed:@"ip_ls"] forKey:@"Highlighted"];
	[imgDic2 setObject:[UIImage imageNamed:@"ip_ls2"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic3 setObject:[UIImage imageNamed:@"ip_sh"] forKey:@"Default"];
	[imgDic3 setObject:[UIImage imageNamed:@"ip_sh"] forKey:@"Highlighted"];
	[imgDic3 setObject:[UIImage imageNamed:@"ip_sh2"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic4 setObject:[UIImage imageNamed:@"ip_gj"] forKey:@"Default"];
	[imgDic4 setObject:[UIImage imageNamed:@"ip_gj"] forKey:@"Highlighted"];
	[imgDic4 setObject:[UIImage imageNamed:@"ip_gj2"] forKey:@"Seleted"];
    
    
    NSArray *imgArr = @[imgDic1,imgDic2,imgDic3,imgDic4];
    LeveyTabBarController *leveyTabBarController = [[LeveyTabBarController alloc] initWithViewControllers:ctlArr imageArray:imgArr];
    //	[leveyTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbarbg.png"]];
	[leveyTabBarController setTabBarTransparent:YES];
    [AppDataCenter sharedAppDataCenter].leveyTabBar = leveyTabBarController;
    [self.navigationController pushViewController:leveyTabBarController animated:YES];
}

#pragma mark -按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Button_Tag_BlueTooth:
        {
            [self showBlutoothPicker];
        }
            break;
        case Button_Tag_Line:
        {
            [self gotoHome];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark- BlueToothDelegate
- (GKSession *) peerPickerController:(GKPeerPickerController *)picker
			sessionForConnectionType:(GKPeerPickerConnectionType)type {
    self.currentSession = [[GKSession alloc] initWithSessionID:@"FR" displayName:nil sessionMode:GKSessionModePeer];
    self.currentSession.delegate = self;
	
    return self.currentSession;
}


//方法功能：判断数据传输状态
-(void)session:(GKSession*)session peer:(NSString*)peerID didChangeState:(GKPeerConnectionState)state
{
	switch (state) {
		case GKPeerStateConnected:
			
            
			NSLog(@"连接");
            
			break;
		case GKPeerStateDisconnected:
            
			NSLog(@"连接断开");
			self.currentSession=nil;
			break;
	}
}

//收到其他设备请求时调用
- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
   
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    printf("连接成功！\n");
    
    
    [self.currentSession setDataReceiveHandler :self withContext:nil];
    
    [picker dismiss];
    picker.delegate = nil;
    
}



- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
    printf("连接尝试被取消 \n");
}

//发送数据
- (void) sendMessage
{
    NSLog(@"开始发送数据");
}


//方法功能：接受数据
-(void)receiveData:(NSData*)data fromPeer:(NSString*)peer inSession:(GKSession*)session context:(void*)context
{
 
    
}
@end
