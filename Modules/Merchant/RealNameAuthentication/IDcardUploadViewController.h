//
//  IDcardUploadViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-25.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：身份证照片上传
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface IDcardUploadViewController : BaseViewController< UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
{
    int operateType;
}

@property (weak, nonatomic) IBOutlet UIButton *imageOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *iamgeTwoBt;
@property (weak, nonatomic) IBOutlet UIButton *imageThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *imageFourBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)buttonClickHandle:(id)sender;

@end
