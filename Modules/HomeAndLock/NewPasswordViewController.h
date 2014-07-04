//
//  NewPasswordViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-7-4.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPasswordViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *pswTxtField;
@property (weak, nonatomic) IBOutlet UITextField *pswConfrimTxtField;

@property (strong, nonatomic) NSString *phoneNumber;

- (IBAction)buttonClickHandle:(id)sender;

@end
