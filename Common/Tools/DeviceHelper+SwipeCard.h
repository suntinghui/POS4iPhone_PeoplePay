//
//  DeviceHelper+SwipeCard.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-22.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：刷卡操作封装  包含了雷达搜索提示和刷卡提示操作
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import "DeviceHelper.h"



@interface DeviceHelper (SwipeCard)


//刷卡操作
- (void)swipeCardWithControler:(UIViewController*)viewController
                          type:(CSwipteCardType)type
                         money:(NSString*)money
                 otherParamter:(NSDictionary*)other
                      sucBlock:(OnePramaBlock)block;

@end
