//
//  PhoneRechargeViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-24.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "PhoneRechargeViewController.h"
#import "TKAddressBook.h"

#define Button_Tag_SelectPhone  100
#define Button_Tag_SelectMoney  101
#define Button_Tag_Commit 102

@interface PhoneRechargeViewController ()

@end

@implementation PhoneRechargeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"手机充值";
    
    moneys = @[@"10元",@"50元",@"100元"];
    self.moneyLabel.text = moneys[0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
 
    UIButton *button =(UIButton*)sender;
    switch (button.tag)
    {
        case Button_Tag_SelectPhone: //选择联系人
        {
            TKContactsMultiPickerController *contactPickController = [[TKContactsMultiPickerController alloc]init];
            contactPickController.delegate = self;
            [self.navigationController pushViewController:contactPickController animated:YES];
        }
            break;
        case Button_Tag_SelectMoney: //选择金额
        {
            
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择充值金额" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:nil];
            
            for (NSString *monye in moneys)
            {
                [sheet addButtonWithTitle:monye];
            }
            [sheet showInView:self.view];
        }
            break;
        case Button_Tag_Commit: //刷卡
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -ContaceSelectDelegate
- (void)contactsMultiPickerController:(TKContactsMultiPickerController*)picker didFinishPickingDataWithInfo:(NSArray*)data;
{
    [self.navigationController popViewControllerAnimated:YES];
    if (data.count>0)
    {
        TKAddressBook *address = data[0];
        self.phoneTxtField.text = address.tel;
    }
 
}
- (void)contactsMultiPickerControllerDidCancel:(TKContactsMultiPickerController*)picker
{
    
}
#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0)
    {
          self.moneyLabel.text = moneys[buttonIndex-1];
    }
  
}

@end
