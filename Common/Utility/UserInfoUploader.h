//
//  UserInfoUpload.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-7-29.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：实名认证后将用户信息上传到内部服务器  没有提示框 在后台运行
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <Foundation/Foundation.h>

@interface UserInfoUploader : NSObject

- (void)uploadImageWithImageInfo:(NSDictionary*)infoDic;

- (void)uploadUserInfo:(NSDictionary*)infoDic;
@end
