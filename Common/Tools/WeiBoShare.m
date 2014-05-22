//
//  WeiBoShare.m
//  HManager
//
//  Created by wenbin on 13-10-11.
//
//

#import "WeiBoShare.h"
#import "StaticToolsHeader.h"
@implementation WeiBoShare

static WeiBoShare *shareWeiBo = nil;


- (id)init
{
    self = [super init];
    if (self)
    {
        //**********新浪微博******************
        self.sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
        if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
        {
            self.sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
            self.sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
            self.sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        }
        //*************************************
       
        //********腾讯微博**********************
        self.tcWeiboEngine = [[TCWBEngine alloc] initWithAppKey:WiressSDKDemoAppKey
                                                  andSecret:WiressSDKDemoAppSecret
                                             andRedirectUrl:REDIRECTURI];
        //*************************************
    }
    return self;
}

- (void)dealloc
{
    self.sinaweibo = nil;
    
    self.tcWeiboEngine = nil;
}

+(WeiBoShare *)sharedWeiBo
{
    @synchronized(self)
    {
        if(shareWeiBo == nil)
        {
            shareWeiBo = [[self alloc] init];
        }
    }
    return shareWeiBo;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (shareWeiBo == nil)
        {
            shareWeiBo = [super allocWithZone:zone];
            return  shareWeiBo;
        }
    }
    return nil;
}

#pragma mark-
#pragma mark--新浪微博相关

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/**
 *	@brief	保存新浪微博授权信息
 */
- (void)storeAuthData

{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  新浪微博是否授权
 *
 *  @return
 */
- (BOOL)isSinaWeiBoIsSign
{
    NSDictionary *auth = [UserDefaults objectForKey:@"SinaWeiboAuthData"];
    if (auth==nil)
    {
        return NO;
    }
    return YES;
}
/**
 *	@brief	新浪微博登陆授权
 */
- (void)sinaweiboLogIn
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logIn];
}

/**
 *	@brief	新浪微博取消授权
 */
- (void)sinaWeiBoLogOut
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logOut];
}

/**
 *	@brief	新浪微博发送
 *
 *	@param 	txt 	正文 没有正文时传nil
 *	@param 	image 	图片 没有图片时传nil
  *	@param 	sBlock 	发送成功后的回调
 */
- (void)sinaweiboSendWithTxt:(NSString*)txt Image:(UIImage*)image success:(OperateBlock)sBlock
{
    SinaWeibo *sinaweibo = [self sinaweibo];

    //没有授权时需先授权
    if (!sinaweibo.isAuthValid)
    {
        [self sinaweiboLogIn];
        return;
    }
    self.sucBlock = sBlock;
    if (image==nil)
    {
        [sinaweibo requestWithURL:@"statuses/update.json"
                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:txt, @"status", nil]
                       httpMethod:@"POST"
                         delegate:self];
    }
    else
    {
        NSMutableDictionary *dataMtbDict = [NSMutableDictionary dictionaryWithCapacity:0];
        if(txt!=nil)
        {
            [dataMtbDict setObject:txt forKey:@"status"];
        }
      
        [dataMtbDict setObject:image forKey:@"pic"];
    
        [sinaweibo requestWithURL:@"statuses/upload.json"
                           params:dataMtbDict
                       httpMethod:@"POST"
                         delegate:self];
    }
    
    [SVProgressHUD showWithStatus:@"正在发送..." maskType:SVProgressHUDMaskTypeClear];
    
}

//新浪微博授权成功
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
   [SVProgressHUD showSuccessWithStatus:@"授权成功"];
    
    [self storeAuthData];
}

//新浪微博取消授权成功
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
  
}

//新浪微博授权时点击了取消
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

//新浪微博授权失败
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
    [SVProgressHUD showSuccessWithStatus:@"授权失败"];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
}

#pragma mark  SinaWeiboRequest Delegate
//新浪微博信息发送请求失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [StaticTools showAlertWithTag:0
                            title:nil
                          message:[NSString stringWithFormat:@"发送失败：%@",[error localizedDescription]]
                        AlertType:CAlertTypeDefault
                        SuperView:nil];
    
    [SVProgressHUD dismiss];
    
}
//新浪微博信息发送请示成功
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    [SVProgressHUD dismiss];
    
    [SVProgressHUD showSuccessWithStatus:@"微博发送成功"];
    
    if (self.sucBlock)
    {
        self.sucBlock();
    }
}

- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response %@",response.description);
}

#pragma mark-
#pragma mark--腾讯微博相关

/**
 *	@brief	腾讯微博登陆授权
 */
- (void)tcWeiboLogin
{
 
    [self.tcWeiboEngine setRootViewController:self.tcWeiBoRootController];
    [self.tcWeiboEngine logInWithDelegate:self
                                onSuccess:@selector(tcWeiBoLoginSuccessCallback)
                                onFailure:@selector(tcWeiBoLoginFailureCallback:)];
}

/**
 *	@brief	腾讯微博取消授权
 */
- (void)tcWeiBoLogOut
{
    [self.tcWeiboEngine logOut];
}

/**
 *	@brief	腾讯微博发送消息
 *
 *	@param 	txt 	正文
 *	@param 	imageData 	图片 
 */
- (void)tcWeiBoSendWithTxt:(NSString*)txt image:(NSData*)imageData
{
    [self.tcWeiboEngine postPictureTweetWithFormat:@"json"
                                                   content:txt
                                                  clientIP:@"10.10.1.38"
                                                       pic:imageData
                                            compatibleFlag:@"0"
                                                 longitude:nil
                                               andLatitude:nil
                                               parReserved:nil
                                                  delegate:self
                                                 onSuccess:@selector(tcWeiBoSendSuccess:)
                                                 onFailure:@selector(tcWeiBoSendFail:)];
}


//腾讯授权成功
- (void)tcWeiBoLoginSuccessCallback
{
    [StaticTools showAlertWithTag:0
                            title:nil
                          message:@"授权成功"
                        AlertType:CAlertTypeDefault
                        SuperView:nil];
    
   
}

//腾讯授权失败
- (void)tcWeiBoLoginFailureCallback:(NSError*)error
{
   [StaticTools showAlertWithTag:0
                           title:nil
                         message:@"授权失败"
                       AlertType:CAlertTypeDefault
                       SuperView:nil];
   
}

//腾讯微博发送成功
- (void)tcWeiBoSendSuccess:(id)result
{
    [StaticTools showAlertWithTag:0
                            title:nil
                          message:@"发送微博成功"
                        AlertType:CAlertTypeDefault
                        SuperView:nil];

}

//腾讯微博发送失败
- (void)tcWeiBoSendFail:(NSError *)error
{
    [StaticTools showAlertWithTag:0
                            title:nil
                          message:[NSString stringWithFormat:@"发送失败：%@",[error localizedDescription]]
                        AlertType:CAlertTypeDefault
                        SuperView:nil];
  
}

@end
