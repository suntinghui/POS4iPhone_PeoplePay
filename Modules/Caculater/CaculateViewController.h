//
//  CaculateViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-23.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 众人科技
 //
 // 文件功能描述：计算器页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface CaculateViewController : UIViewController
{
    double fstOperand; //当前输入数字
	double sumOperand; //前面输入的计算后的数据
    
    BOOL bBegin;
	BOOL backOpen;
    
    NSString *operater;
}
@property (weak, nonatomic) IBOutlet UITextField *resultTxtField;
@property (weak, nonatomic) IBOutlet UILabel *showFoperator;
@property (assign, nonatomic) UIViewController *fatherController;
@property (weak, nonatomic) IBOutlet UIImageView *inputBgView;

- (IBAction)buttonClickHandle:(UIButton*)button;

@end
