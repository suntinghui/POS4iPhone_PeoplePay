//
//  SetMoveLockViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-13.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "SetMoveLockViewController.h"

@interface SetMoveLockViewController ()

@end

@implementation SetMoveLockViewController

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
    
    self.navigationItem.title = @"解锁手势设置";
    
    if (IsIPhone5)
    {
        self.bgImgView.image = [UIImage imageNamed:@"ip-ssmm-bj5"];
    }
    else
    {
        self.bgImgView.image = [UIImage imageNamed:@"ip-ssmm-bj4"];
    }
    
	self.lockView = [[SPLockScreen alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
	self.lockView.center = CGPointMake(160, 50+160);
	self.lockView.delegate = self;
	self.lockView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.lockView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -LockScreenDelegate
- (void)lockScreen:(SPLockScreen *)lockScreen didEndWithPattern:(NSNumber *)patternNumber
{
    if ([patternNumber isEqualToNumber:@(123)])
    {
        
    }
}

@end
