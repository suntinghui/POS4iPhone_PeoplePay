//
//  SplitViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-30.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "SplitViewController.h"
#import "LoginViewController.h"

@interface SplitViewController ()

@end

@implementation SplitViewController

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
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (int i=0; i<4; i++)
    {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*320, 0, 320, self.view.frame.size.height)];
        if (IsIPhone5)
        {
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"split%d-iphone5",i+1]];
        }
        else
        {
           imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"split%d",i+1]];
        }
        
        [self.scrollView addSubview:imgView];
        
        if (i==3)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; //TODO IPHONE5
            button.frame = CGRectMake(50+320*3,(IsIPhone5?410: 350), 220, 70);
            [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:button];
        }
    }
    self.scrollView.contentSize = CGSizeMake(320*4, self.view.frame.size.height);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //从navigation栈里移除本页面  避免退出等操作到根视图时需特殊处理
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [arr removeObjectAtIndex:arr.count-2];
    self.navigationController.viewControllers = arr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)buttonClickHandle:(UIButton*)button
{
    LoginViewController *loginViewController = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}
@end
