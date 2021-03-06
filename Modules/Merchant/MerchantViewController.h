//
//  HomeViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-29.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：商户首页
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface MerchantViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate,
    UIAlertViewDelegate,
    UIActionSheetDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIActionSheetDelegate>
{
    int state;  //0:未展开  1：展开
    UIImagePickerController *imagePickerController;
    int camaType;  //0：修改头像  1：修改大背景图
}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
@property (strong, nonatomic) NSDictionary *infoDict; //商户信息

- (IBAction)buttonClickHandle:(id)sender;

@end
