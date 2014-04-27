//
//  Transfer.h
//  LKOA4iPhone
//
//  Created by  STH on 7/27/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^SuccessBlock) (id obj);
typedef void (^FailureBlock) (NSString *errMsg);
typedef void (^QueueCompleteBlock) (NSArray *operations);

@interface Transfer : NSObject <NSXMLParserDelegate, UIAlertViewDelegate>
{
    bool isCancelAction;
    
    AFHTTPRequestOperation *downloadOperation;
    
    NSString *downloadFileName;
}

@property (nonatomic, strong) AFHTTPRequestOperation *downloadOperation;
@property (nonatomic, strong) NSString *downloadFileName;


+ (Transfer *) sharedTransfer;

+ (NSString *) getHost;
+ (AFHTTPClient *) sharedClient;

- (AFHTTPRequestOperation *) TransferWithRequestDic:(NSDictionary *) reqDic
                                             prompt:(NSString *) prompt
                                         alertError:(BOOL) alertError
                                            success:(SuccessBlock) success
                                            failure:(FailureBlock) failure;


- (AFHTTPRequestOperation *) TransferWithRequestDic:(NSDictionary *) reqDic
                                             prompt:(NSString *) prompt
                                            success:(SuccessBlock) success
                                            failure:(FailureBlock) failure;



- (void) downloadFileWithName:(NSString *) name
                         link:(NSString *) link
               repeatDownload:(BOOL) repeatDownload
               viewController:(UIViewController *) vc
                      success:(SuccessBlock) success
                      failure:(FailureBlock) failure;

- (void) downloadFileWithName:(NSString *) name
                         link:(NSString *) link
               viewController:(UIViewController *) vc
                      success:(SuccessBlock) success
                      failure:(FailureBlock) failure;

- (void) doQueueByOrder:(NSArray *) operationList
          completeBlock:(QueueCompleteBlock) completeBlock;

- (void) doQueueByTogether:(NSArray *) operationList
                    prompt:(NSString *) prompt
             completeBlock:(QueueCompleteBlock) completeBlock;

@end
