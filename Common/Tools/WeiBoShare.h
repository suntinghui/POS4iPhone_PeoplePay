//
//  WeiBoShare.h
//  HManager
//
//  Created by wenbin on 13-10-11.
//
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件功能描述：微博分享处理单例类 提供授权、分享、成功或失败等操作的处理
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/

#import <Foundation/Foundation.h>

typedef void(^OperateBlock)();

@interface WeiBoShare : NSObject<SinaWeiboDelegate, SinaWeiboRequestDelegate,TCWBRequestDelegate>
{
 
}
@property (retain, nonatomic) SinaWeibo *sinaweibo;
@property (retain, nonatomic) TCWBEngine *tcWeiboEngine;
@property (assign, nonatomic) UIViewController *tcWeiBoRootController; //腾讯微博授权时需用到

@property (strong, nonatomic) OperateBlock sucBlock;  //操作成功回调
+(WeiBoShare *)sharedWeiBo;

//新浪微博是否授权
- (BOOL)isSinaWeiBoIsSign;
//新浪微博登录授权
- (void)sinaweiboLogIn;
//新浪微博取消授权
- (void)sinaWeiBoLogOut;
//新浪微博发送消息
- (void)sinaweiboSendWithTxt:(NSString*)txt Image:(UIImage*)image success:(OperateBlock)sBlock;

//腾讯微博登陆授权
- (void)tcWeiboLogin;
//腾讯微博取消授权
- (void)tcWeiBoLogOut;
//腾讯微博发送消息
- (void)tcWeiBoSendWithTxt:(NSString*)txt image:(NSData*)imageData;

@end
