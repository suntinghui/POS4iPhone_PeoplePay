//
//  TradeListViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-10.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 // 版权所有。
 //
 // 文件功能描述：交易列表
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "ScrollSelectView.h"
#import "BaseViewController.h"

@interface TradeListViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate,
    ScrollSelectDelegate,
    UIAlertViewDelegate>
{
    MJRefreshHeaderView *headerView;
    MJRefreshFooterView *footView;
    int operateType;   //0:交易流水 1：现金流水
    int currentPage;  //从0开始 第一页传0
    int totalPage;
    BOOL isFresh;  //是否为下拉刷新
    int deleteIndex; //点中的删除的项
}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel; //交易笔数
@property (weak, nonatomic) IBOutlet UILabel *txtLabel; // “笔”文字
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel; //金额
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;  //时间选择按钮
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (strong, nonatomic) NSMutableArray *trades;
@property (strong, nonatomic) NSMutableArray *cashs;

@property (strong, nonatomic) NSString *totalMoney; 
@property (strong, nonatomic) NSString *totalCount;

- (IBAction)buttonClickHandle:(id)sender;
//刷新列表
- (void)refreshList;

@end
