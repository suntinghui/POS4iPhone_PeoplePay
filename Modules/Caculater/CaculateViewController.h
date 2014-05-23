//
//  CaculateViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-23.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

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

- (IBAction)buttonClickHandle:(UIButton*)button;

@end
