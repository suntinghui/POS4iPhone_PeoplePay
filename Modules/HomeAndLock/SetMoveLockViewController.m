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
	self.lockView.center = CGPointMake(160, 90+160+(IsIPhone5?60:0));
	self.lockView.delegate = self;
	self.lockView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.lockView];
    
//    if ([UserDefaults objectForKey:kMoveUnlockPsw]!=nil)
//    {
//        self.messLabel.text = @"请输入原始解锁手势";
//        state = 0;
//    }
//    else
//    {
        self.messLabel.text = @"请输入新解锁手势";
        state = 1;
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 功能函数

- (void)shakeLabel:(UILabel*)lable withMess:(NSString*)mess
{
     titleStr =lable.text;
    lable.textColor = [UIColor redColor];
    lable.text = mess;
    
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置抖动幅度
    shake.delegate = self;
    shake.fromValue = [NSNumber numberWithFloat:-0.1];
    shake.toValue = [NSNumber numberWithFloat:+0.1];
    shake.duration = 0.07;
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 6;
    [lable.layer addAnimation:shake forKey:nil];

    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.messLabel.text  = titleStr;
    self.messLabel.textColor = [UIColor whiteColor];
}

#pragma -LockScreenDelegate
- (void)lockScreen:(SPLockScreen *)lockScreen didEndWithPattern:(NSNumber *)patternNumber
{
    
    if (state==0)
    {
        NSNumber *oldNum = [UserDefaults objectForKey:kMoveUnlockPsw];
        if ([patternNumber intValue]!=[oldNum intValue])
        {
//             [SVProgressHUD showErrorWithStatus:@"原始手势错误"];
            
            [self shakeLabel:self.messLabel withMess:@"原始手势错误"];
        }
        else
        {
            self.messLabel.text = @"请输入新解锁手势";
            state=1;
        }
    }
    else if (state==1)
    {
        self.firstInput = patternNumber;
        self.messLabel.text = @"请再次输入新解锁手势";
        state=2;
    }
    else if(state==2)
    {
        if ([self.firstInput intValue]!=[patternNumber intValue])
        {
//            [SVProgressHUD showErrorWithStatus:@"两次输入手势不一致"];
             [self shakeLabel:self.messLabel withMess:@"两次输入手势不一致"];
        }
        else
        {
            [UserDefaults setObject:patternNumber forKey:kMoveUnlockPsw];
             [UserDefaults setObject:@"1" forKey:kMoveUnlockState];
            [UserDefaults synchronize];
            
            [SVProgressHUD showSuccessWithStatus:@"手势设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
    }
}

@end
