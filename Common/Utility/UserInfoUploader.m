//
//  UserInfoUpload.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-7-29.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "UserInfoUploader.h"

@implementation UserInfoUploader
/**
 *   上传图片
 *
 *  @param infoDic
 */
- (void)uploadImageWithImageInfo:(NSDictionary*)infoDic
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:infoDic
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"000000"])
                                                 {
 
                                                     NSLog(@"%@ 图片上传成功",infoDic[@"FILETYPE"]);
                                                 }
                                                 else
                                                 {
                                                    NSLog(@"%@ 图片上传失败",infoDic[@"FILETYPE"]);
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             NSLog(@"%@ 图片上传失败",infoDic[@"FILETYPE"]);
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:nil completeBlock:^(NSArray *operations) {
        
    }];
}

/**
 *  上传用户资料
 *
 *  @param infoDic
 */
- (void)uploadUserInfo:(NSDictionary*)infoDic
{
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:infoDic
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"000000"])
                                                 {
                                                    
                                                      NSLog(@"实名认证资料上传成功");
                                                 }
                                                 else
                                                 {
                                                      NSLog(@"实名认证资料上传失败");
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             
                                              NSLog(@"实名认证资料上传失败");
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:nil completeBlock:^(NSArray *operations) {
        
    }];

}

@end
