//
//  LockViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-29.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "LockViewController.h"
#import "ForgetPasswordViewController.h"
#import "TimedoutUtil.h"

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
    self.navigationItem.title = @"锁屏手势";
    
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
    NSNumber *pswNum = [UserDefaults objectForKey:kMoveUnlockPsw];
    if ([patternNumber intValue] == [pswNum intValue])
    {
        [self.view removeFromSuperview];
        
         [[NSNotificationCenter defaultCenter] addObserver:ApplicationDelegate selector:@selector(unTouchedTimeUp) name:kNotificationTimeUp object:nil];
    }
    else
    {
        CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //设置抖动幅度
        shake.delegate = self;
        shake.fromValue = [NSNumber numberWithFloat:-0.1];
        shake.toValue = [NSNumber numberWithFloat:+0.1];
        shake.duration = 0.07;
        shake.autoreverses = YES; //是否重复
        shake.repeatCount = 6;
        [self.headImgView.layer addAnimation:shake forKey:nil];
    }
}

#pragma mark- 按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    ForgetPasswordViewController *forgetPswController = [[ForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgetPswController animated:YES];
}

@end
