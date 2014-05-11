//
//  LockViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-29.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "LockViewController.h"
#import "ForgetPasswordViewController.h"

@interface LockViewController ()

@end

@implementation LockViewController

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
    
    if (IsIPhone5)
    {
        self.bgImgView.image = [UIImage imageNamed:@"ip-ssmm-bj5"];
    }
    else
    {
        self.bgImgView.image = [UIImage imageNamed:@"ip-ssmm-bj4"];
    }
    
	self.lockView = [[SPLockScreen alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
	self.lockView.center = CGPointMake(160, self.headImgView.frame.size.height+self.headImgView.frame.origin.y+10+160);
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
        [self.view removeFromSuperview];
    }
}

#pragma mark- 按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    ForgetPasswordViewController *forgetPswController = [[ForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgetPswController animated:YES];
}

@end
