//
//  Transfer.m
//  LKOA4iPhone
//
//  Created by  STH on 7/27/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "Transfer.h"
#import "Transfer+Parser.h"
#import "XMLWriter.h"
#import "MProgressAlertView.h"
#import "Reachability.h"
#import "FileManagerUtil.h"
#import "GTMNSString+HTML.h"
#import "AESUtil.h"

#define KB      (1024.0)
#define MB      (1024.0 * 1024.0)

@implementation Transfer

@synthesize downloadOperation = _downloadOperation;
@synthesize downloadFileName = _downloadFileName;

static Transfer *instance = nil;
static AFHTTPClient *client = nil;
static NSString *totalSize = nil;

+ (Transfer *) sharedTransfer
{
    @synchronized(self)
    {
        if (nil == instance) {
            instance = [[Transfer alloc] init];
        }
    }
    
    return instance;
}

+ (AFHTTPClient *) sharedClient
{
    if (nil == client) {
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", [Transfer getHost]]];
        client = [[AFHTTPClient alloc] initWithBaseURL:url];
    }
    
    return client;
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
- (void)setRequestUrl:(NSString*)url
{
    client.baseURL = [NSURL URLWithString:url];
}

+ (NSString *) getHost
{
    NSString *host = [UserDefaults objectForKey:kHostAddress];
    if ([StaticTools isEmptyString:host])
    {
        host = DEFAULTHOST;
    }
    
    return host;
}



- (void) doQueueByOrder:(NSArray *) operationList
          completeBlock:(QueueCompleteBlock) completeBlock
{
    isCancelAction = NO;
    
    [[Transfer sharedClient].operationQueue setMaxConcurrentOperationCount:1];
    [[Transfer sharedClient].operationQueue setName:@"doQueueByOrder"];
    
    for (int i=0; i< [operationList count] - 1; i++) {
        [[operationList objectAtIndex:i+1] addDependency:[operationList objectAtIndex:i]];
    }
    
    [[Transfer sharedClient] enqueueBatchOfHTTPRequestOperations:operationList progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        [SVProgressHUD dismiss];
        
        if (completeBlock) {
            completeBlock(operations);
        }
    }];
}

- (void) doQueueByTogether:(NSArray *) operationList
                    prompt:(NSString *) prompt
             completeBlock:(QueueCompleteBlock) completeBlock
{
    isCancelAction = NO;
    
    if (prompt) {
        //[SVProgressHUD showWithStatus:prompt maskType:SVProgressHUDMaskTypeClear];
        
        
         [SVProgressHUD showWithStatus:prompt maskType:SVProgressHUDMaskTypeClear cancelBlock:^(id sender){
             NSLog(@"用户取消操作...");
             isCancelAction = YES;
             [[Transfer sharedClient].operationQueue cancelAllOperations];
             [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:@"POST" path:[Transfer getHost]];
             
             [SVProgressHUD dismiss];
             
         }];
         
    }
    
    [[Transfer sharedClient].operationQueue setMaxConcurrentOperationCount:[operationList count]];
    [[Transfer sharedClient].operationQueue setName:@"doQueueByTogether"];
    
    [[Transfer sharedClient] enqueueBatchOfHTTPRequestOperations:operationList progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        //[SVProgressHUD dismiss];
        
        if (completeBlock) {
            completeBlock(operations);
        }
        
    }];
}

/**
    不要直接使用该方法的返回值调用start方法执行联网请求。而是使用上面的队列方式来请求数据。。。
    
    如果使用doQueueByTogether则prompt失效
 
 **/

- (AFHTTPRequestOperation *) TransferWithRequestDic:(NSDictionary *) reqDic
                                             prompt:(NSString *) prompt
                                            success:(SuccessBlock) success
                                            failure:(FailureBlock) failure

{
    return [self TransferWithRequestDic:reqDic
                                 prompt:prompt
                             alertError:YES
                                success:^(id obj) {
                                 success(obj);
                             } failure:^(NSString *errMsg) {
                                 failure(errMsg);
                             }];
}


- (AFHTTPRequestOperation *) TransferWithRequestDic:(NSDictionary *)reqDic
                                             prompt:(NSString *)prompt
                                         alertError:(BOOL)alertError
                                            success:(SuccessBlock)success
                                            failure:(FailureBlock)failure
{
    if (![self checkNetAvailable]) {
        [SVProgressHUD dismiss];
        return nil;
    }
    
    if (prompt && [[Transfer sharedClient].operationQueue.name isEqualToString:@"doQueueByOrder"]) {
        //[SVProgressHUD showWithStatus:prompt maskType:SVProgressHUDMaskTypeClear];
        
        
        [SVProgressHUD showWithStatus:prompt maskType:SVProgressHUDMaskTypeClear cancelBlock:^(id sender){
            NSLog(@"用户取消操作...");
            isCancelAction = YES;
            
            [[Transfer sharedClient].operationQueue cancelAllOperations];
            [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:@"POST" path:[Transfer getHost]];
            
            [SVProgressHUD dismiss];
        }];
        
    }
    
  
    
    NSString* (^dic2XML) (void) = ^(void){
        NSMutableString *mutString = [NSMutableString string];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[reqDic objectForKey:kParamName]];
        
        //增加公共参数
        [tempDic setObject:[reqDic objectForKey:kTranceCode] forKey:@"TRANCODE"];
        
        for (NSString *key in [tempDic allKeys])
        {
            
            id obj = [tempDic objectForKey:key];
            
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                [mutString appendFormat:@"<%@>%@</%@>", key, [XMLWriter XMLStringFromDictionary:obj], key];
                
            }
            else if ([obj isKindOfClass:[NSString class]])
            {
                
                 [mutString appendFormat:@"<%@>%@</%@>", key, obj, key];
            }
            
        }
        
        return mutString;
    };
    
    
    NSMutableString *httpBodyString = [NSMutableString stringWithFormat:
                                @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                "<EPOSPROTOCOL>"
                                "%@"
                                "</EPOSPROTOCOL>", dic2XML()];
    
    //对整个报文做md5后  将值传入该字段
    NSString *mac = [SecurityUtil md5Crypto:httpBodyString];
    NSString *packmac = [NSString stringWithFormat:@"<PACKAGEMAC>%@</PACKAGEMAC>" ,mac];
    [httpBodyString insertString:packmac atIndex:[httpBodyString rangeOfString:@"</EPOSPROTOCOL>"].location];
    
    [[Transfer sharedClient] setDefaultHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",[httpBodyString length]]];
    
 
 
   
//    NSLog(@"Request:%@", httpBodyString);
    
    /***
    // don't work
    [client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            // Not reachable
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"无法链接到互联网，请检查您的网络设置."
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        } else {
            // Reachable
            [SVProgressHUD dismiss];
        }
        
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            // On wifi
        }
    }];
     ****/
    
    NSString *postType = @"posp";
    NSString *endType = @"tran";
    NSString *rspCode = [reqDic objectForKey:kTranceCode];
  
    if([rspCode isEqualToString:@"199031"]||//获取省份
        [rspCode isEqualToString:@"199032"]||//获取城市
        [rspCode isEqualToString:@"199035"]||//获取银行列表
        [rspCode isEqualToString:@"199034"]||//获取支行列表
        [rspCode isEqualToString:@"199026"]||//我的账户信息
        [rspCode isEqualToString:@"199020"]||//签到
        [rspCode isEqualToString:@"199030"]||//实名认证
        [rspCode isEqualToString:@"199002"]|| //登录
        [rspCode isEqualToString:@"199004"]|| //忘记密码
        [rspCode isEqualToString:@"199018"]|| //获取短信验证码
        [rspCode isEqualToString:@"199003"]||  //修改密码
        [rspCode isEqualToString:@"199008"]||  //流水查询
        [rspCode isEqualToString:@"199037"]||  //发送交易小票
        [rspCode isEqualToString:@"199010"]||  //上传消费签名图片
        [rspCode isEqualToString:@"199025"]||  //账户提现
        [rspCode isEqualToString:@"199022"]||  //商户信息
        [rspCode isEqualToString:@"708102"]||  //信用卡还款
        [rspCode isEqualToString:@"199019"]||  //短信码验证
        [rspCode isEqualToString:@"708101"]||  //卡卡转账
        [rspCode isEqualToString:@"199001"]||  //注册（UN）
       [rspCode isEqualToString:@"199005"]||    //消费
       [rspCode isEqualToString:@"199038"]      //获取扣率
        )
    {
        postType = @"Vpm";
        endType = @"tranm";
    }
    else if([rspCode isEqualToString:@"708103"]) //手机充值
    {
        postType = @"Vpm";
        endType = @"tranp";
    }
    else if([rspCode isEqualToString:@"199021"]) //身份证图片上传
    {
        postType = @"Vpm";
        endType = @"tran";
    }
    else if([rspCode isEqualToString:@"200000"]||//头像上传
            [rspCode isEqualToString:@"200001"]||//头像下载
            [rspCode isEqualToString:@"200002"]||//现金记账
            [rspCode isEqualToString:@"200003"]||//现金流水列表
            [rspCode isEqualToString:@"200004"]||//现金流水删除
            [rspCode isEqualToString:@"200005"]||//背景大图上传
            [rspCode isEqualToString:@"200006"]||//背景大图下载
            [rspCode isEqualToString:@"200007"]||//用户注册
            [rspCode isEqualToString:@"200008"]||//用户登录
            [rspCode isEqualToString:@"200009"]||//修改密码
            [rspCode isEqualToString:@"200010"]||//上传实名认证图片
            [rspCode isEqualToString:@"200011"]  //上传实名认证填写的资料
            )
    {
        postType = @"";
        endType = @"";
    }
    
    
    NSString *path = [NSString stringWithFormat:@"%@/%@.%@",postType,[reqDic objectForKey:kTranceCode],endType];
    
    if ([postType isEqualToString:@"posm"])
    {
        [self setRequestUrl:@"http://211.147.87.24:8092/"];
    }
    else if ([postType isEqualToString:@""]) //内部服务地址
    {
        //http://111.198.29.38:8891/
        //192.168.4.100:8080 周
        
        [self setRequestUrl:@"http://111.198.29.38:8891/"];
        path = @"zfb/mpos/transProcess.do";
    }
    else if([postType isEqualToString:@"posp"])
    {
         [self setRequestUrl:@"http://211.147.87.23:8088/"];
    }
    else if([postType isEqualToString:@"Vpm"])
    {
         [self setRequestUrl:@"http://211.147.87.20:8092/"];
    }
    
   
    NSLog(@"Request:%@ ", httpBodyString);
    
    httpBodyString = [NSMutableString stringWithFormat:@"%@", [AESUtil encryptUseAES:httpBodyString]];
    httpBodyString = [NSMutableString stringWithFormat:@"requestParam=%@", httpBodyString];
    
    NSMutableURLRequest *request;
    
    if ([rspCode isEqualToString:@"199021"]) //身份证图片上传特别处理
    {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[reqDic objectForKey:kParamName]];
        [tempDic setObject:[reqDic objectForKey:kTranceCode] forKey:@"TRANCODE"];
    
        request = [[Transfer sharedClient] requestWithMethod:@"POST" path:path parameters:tempDic];
    }
    else
    {
       
        request = [[Transfer sharedClient] requestWithMethod:@"POST" path:path parameters:nil];
        request.HTTPBody = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    }
    
     NSLog(@"url is --》%@",request.URL);
    [request setTimeoutInterval:30];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        /***
        if ([[Transfer sharedClient].operationQueue.operations count] == 0) {
            [SVProgressHUD dismiss];
        }
         ***/
        
        [SVProgressHUD dismiss];
        
      
        NSString *respXML = [[operation responseString] gtm_stringByUnescapingFromHTML];
        
//        if ([[reqDic objectForKey:kMethodName] isEqualToString:@"GetBMZC"])  //测试用
//        {
//            NSString *path = [[NSBundle mainBundle]pathForResource:@"file" ofType:@"txt"];
//            NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//            respXML = [str gtm_stringByUnescapingFromHTML];
//        }
        
        
//        NSLog(@"Response: %@", respXML);
        

      
        NSString *xmlStr = respXML;
         if (![rspCode isEqualToString:@"199021"]) //身份证图片上传特殊处理
         {
             NSLog(@"Response: %@", [AESUtil decryptUseAES:respXML]);
             
             xmlStr = [AESUtil decryptUseAES:respXML];
             id obj = [self ParseXMLWithReqCode:[reqDic objectForKey:kTranceCode] xmlString: xmlStr];
             success(obj);
         }
        else
        {
            NSLog(@"Response: %@", respXML);
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[respXML dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            success(result);
        }
        
        
       
            
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
        [SVProgressHUD dismiss];
        
        [[Transfer sharedClient].operationQueue cancelAllOperations];
        [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:@"POST" path:[Transfer getHost]];
        
        NSLog(@"--%@", [NSString stringWithFormat:@"%@",error]);
        //[SVProgressHUD showErrorWithStatus:[self getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]];
        
        // 点击取消的时候会报（The operation couldn’t be completed）,但是UserInfo中不存在NSLocalizedDescription属性，说明这不是一个错误，现用一BOOL值进行简单特殊控制,。。。
        NSString *message = [Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        if (!isCancelAction && message && alertError) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
        failure([Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]);
    }];
    
    return operation;
}


- (void) downloadFileWithName:(NSString *) name
                         link:(NSString *) link
               viewController:(UIViewController *) vc
                      success:(SuccessBlock) success
                      failure:(FailureBlock) failure
{
    [self downloadFileWithName:name
                          link:link
                repeatDownload:NO
                viewController:vc
                       success:success
                       failure:failure];
}

/**
 repeatDownload参数控制是否需要重新下载,如果需要重新下载，则不检查是否存在原文件，直接下载
 **/
- (void) downloadFileWithName:(NSString *) name
                         link:(NSString *) link
               repeatDownload:(BOOL) repeatDownload
               viewController:(UIViewController *) vc
                      success:(SuccessBlock) success
                      failure:(FailureBlock) failure
{
    self.downloadFileName = [NSString stringWithFormat:@"%@", name];
    
    if (!repeatDownload && [FileManagerUtil fileExistWithName:name]) {
        success(nil);
        return;
    }
    
    if (![self checkNetAvailable]) {
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:link]];
    [request setTimeoutInterval:20];
    downloadOperation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // 保存文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:name];
    downloadOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    // 显示进度条
    MProgressAlertView *progressView =[[MProgressAlertView alloc] initWithTitle:@"正在下载文件" message:nil delegate:self cancelButtonTitle:@"取消下载" otherButtonTitles:nil, nil];
    progressView.tag = 100;
    [progressView show];
    
    [downloadOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (!totalSize) {
            totalSize = [Transfer formatDownloadData:totalBytesExpectedToRead];
        }
        
        // 更新进度
        float percent = (float)totalBytesRead / totalBytesExpectedToRead;
        progressView.progressView.progress = percent;
        /***
         progressView.message = [NSString stringWithFormat:@"%@ / %@", [self formatDownloadData:totalBytesRead], totalSize];
         progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", percent*100];
         ***/
        
        progressView.progressLabel.text = [NSString stringWithFormat:@"%@ / %@", [Transfer formatDownloadData:totalBytesRead], totalSize];
    }];
    
    [downloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"downloadComplete!");
        
        [SVProgressHUD dismiss];
        
        totalSize = nil;
        [progressView dismissWithClickedButtonIndex:0 animated:YES];
        
        success(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure! %@", error);
        
        [operation cancel];
        [SVProgressHUD dismiss];
        
        // 文件下载失败直接删除缓存文件
        [FileManagerUtil deleteFileWithName:name];
        
        totalSize = nil;
        [progressView dismissWithClickedButtonIndex:0 animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件下载失败。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        failure([Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]);
    }];
    
    [downloadOperation start];
}

+ (NSString *) formatDownloadData:(long long)length
{
    if (length < (MB/10.0)) {
        return [NSString stringWithFormat:@"%.2f K", length/KB];
    } else {
        return [NSString stringWithFormat:@"%.2f M", length/MB];
    }
}

// 检测网络
- (BOOL) checkNetAvailable
{
    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable) &&
        ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"无法链接到互联网，请检查您的网络设置"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}

+ (NSString *) getErrorMsg:(NSString *)enMsg
{
    // 如果enMsg为nil，则[nil rangeOfString:@"111"].location != NSNotFound 
    if (enMsg) {
        if ([enMsg rangeOfString:@"The request timed out"].location != NSNotFound) {
            // The request timed outtimed out
            return @"服务器响应超时";
        } else if ([enMsg rangeOfString:@"got 500"].location != NSNotFound) {
            //Expected status code in (200-299), got 500
            return [NSString stringWithFormat:@"服务器异常[%@]", enMsg];
        } else if ([enMsg rangeOfString:@"The Internet connection appears to be offline"].location != NSNotFound) {
            // The Internet connection appears to be offline
            return @"无法连接服务器，请检查网络设置";
        } else if ([enMsg rangeOfString:@"Could not connect to the server"].location != NSNotFound) {
            // Could not connect to the server
            return @"无法连接服务器，请检查网络设置";
        } else if ([enMsg rangeOfString:@"got 404"].location != NSNotFound) {
            // Expected status code in (200-299), got 404
            return @"服务器无法响应功能请求(404)";
        }
    }
    
    //return @"未知错误，请重试";
    return nil;
}

#pragma mark - UIAlertDialogDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            [downloadOperation cancel];
            [SVProgressHUD dismiss];
            
            // 文件下载失败直接删除缓存文件
            [FileManagerUtil deleteFileWithName:self.downloadFileName];
            
            totalSize = nil;
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}

@end
