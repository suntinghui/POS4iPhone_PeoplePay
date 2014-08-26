//
//  AccountInfoViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-25.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：实名认证账户信息填写
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface AccountInfoViewController : BaseViewController<UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate>
{
    NSArray *titles;
    int currentEditIndex;
    NSMutableDictionary *resultDict; //保存输入内容
    NSArray *keys;
}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSArray *provins; //保存省份列表
@property (strong, nonatomic) NSArray *citys; //保存城市列表
@property (strong, nonatomic) NSArray *banks;  //银行列表
@property (strong, nonatomic) NSArray *bankPlaces;  //支行列表

@end
