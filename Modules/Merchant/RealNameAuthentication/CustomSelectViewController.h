//
//  CustomSelectViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-25.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：通用选择页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

typedef void(^FinishSelectBlock)(id select);
typedef enum  //选择类型
{
    CSelectTypeSingle, //单选
    CSelectTypeMulty //多选
}CSelectType;

@interface CustomSelectViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSArray *datas;
@property (strong, nonatomic) FinishSelectBlock finishSelect;
@property (assign, nonatomic) int selectType;
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSMutableArray *selectDatas;

@end
