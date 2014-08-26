//
//  BasicInfoViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-25.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：实名认证基本信息填写
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface BasicInfoViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate,
    UITextFieldDelegate>
{
    NSArray *titles;
    NSArray *placeHolds;
    int currentEditIndex;
    NSMutableDictionary *resultDict; //保存输入内容
    NSArray *serviceTypes;   //所有的经营范围
    NSArray *keys;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
