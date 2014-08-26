//
//  AbountViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-12.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "AbountViewController.h"


@interface AbountViewController ()

@end

@implementation AbountViewController

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
    
    self.navigationItem.title = @"关于系统";
    self.versionLabel.text = [NSString stringWithFormat:@"众易付 For Iphone V%@",[StaticTools getCurrentVersion]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.people2000.net"]];
}
@end
