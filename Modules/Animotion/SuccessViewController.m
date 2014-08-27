//
//  SuccessViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-27.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController ()

@end

@implementation SuccessViewController

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
    self.navigationItem.hidesBackButton = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"操作成功";
    
    if (![StaticTools isEmptyString:self.messStr])
    {
        self.messLabel.text = self.messStr;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClickHandle:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.clickBlock)
    {
        self.clickBlock();
    }
   
}
@end
