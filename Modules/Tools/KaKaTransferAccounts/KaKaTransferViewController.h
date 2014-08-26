//
//  KaKaTransferViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-24.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：卡卡转账页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface KaKaTransferViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate,
    UIScrollViewDelegate,
    UITextFieldDelegate,
    UIActionSheetDelegate>
{
    NSArray *titles;
    NSArray *placeHolds;
    int currentEditIndex;
    NSArray *credentials; //保存证件类型
    NSMutableArray *results; //保存输入内容

}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
