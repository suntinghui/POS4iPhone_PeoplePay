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
        
        for (NSString *key in [tempDic allKeys]) {
            
            id obj = [tempDic objectForKey:key];
            
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [mutString appendFormat:@"<%@>%@</%@>", key, [XMLWriter XMLStringFromDictionary:obj], key];
                
            } else if ([obj isKindOfClass:[NSString class]]) {
                
                 [mutString appendFormat:@"<%@>%@</%@>", key, obj, key];
            }
            
        }
        
        return mutString;
    };
    
    
    NSMutableString *httpBodyString = [NSMutableString stringWithFormat:
                                @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                                "<EPOSPROTOCOL>"
                                "%@"
                                "</EPOSPROTOCOL>", dic2XML()];
    
    //对整个报文做md5后  将值传入该字段
    NSString *mac = [SecurityUtil md5Crypto:httpBodyString];
    NSString *packmac = [NSString stringWithFormat:@"<PACKAGEMAC>%@</PACKAGEMAC>" ,mac];
    [httpBodyString insertString:packmac atIndex:[httpBodyString rangeOfString:@"</EPOSPROTOCOL>"].location];
    
    [[Transfer sharedClient] setDefaultHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [[Transfer sharedClient] setDefaultHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",[httpBodyString length]]];
    
    NSLog(@"Request:%@", httpBodyString);
    
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
    
    NSString *postType = @"posm";
    if ([[reqDic objectForKey:kTranceCode] isEqualToString:@"199009"])
    {
        postType = @"posp";
    }
    
    NSMutableURLRequest *request = [[Transfer sharedClient] requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@/%@.tran5",postType,[reqDic objectForKey:kTranceCode]] parameters:nil];

    NSLog(@"url is %@",request.URL);
    
    //CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
    request.HTTPBody = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setTimeoutInterval:20];
    
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
        
        
        NSLog(@"Response: %@", respXML);
        NSLog(@"Response: %@", [AESUtil decryptUseAES:respXML]);

        id obj = [self ParseXMLWithReqCode:[reqDic objectForKey:kTranceCode] xmlString:respXML];
        success(obj);
            
        
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
