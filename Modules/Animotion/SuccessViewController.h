//
//  SuccessViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-27.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *messLabel;

@property (strong, nonatomic) NSString *messStr;

- (IBAction)buttonClickHandle:(UIButton*)button;

@end
