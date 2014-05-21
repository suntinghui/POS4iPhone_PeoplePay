//
//  SwipeCardNoticeViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-15.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "SwipeCardNoticeViewController.h"

@interface SwipeCardNoticeViewController ()

@end

@implementation SwipeCardNoticeViewController

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
    
    self.navigationItem.title = @"刷卡";
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    for (int i=1;i<9; i++)
    {
        [imgArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"ip_skdh%d",i]]];
    }
    
    //为图片设置动态
    self.cardImgView.animationImages = imgArr;
    //为动画设置持续时间
    self.cardImgView.animationDuration = 1.5;
    //为默认的无限循环
    self.cardImgView.animationRepeatCount = 0;
    //开始播放动画
   [self.cardImgView startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
