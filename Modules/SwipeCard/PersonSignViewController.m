//
//  PersonSignViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-27.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "PersonSignViewController.h"
#import "SuccessViewController.h"
#import "ConvertUtil.h"
#import "TradeSuccessViewController.h"

#define Button_Tag_Clear  100
#define Button_Tag_Send   101

@interface PersonSignViewController ()

@end

@implementation PersonSignViewController

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
    
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    
     [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeRight animated:YES];
    
    float width = [[UIScreen mainScreen] bounds].size.height;
    
    //初始化画板视图
	painCanvasView = [[PaintMaskView alloc] initWithFrame:CGRectMake(0, 0, width, self.view.frame.size.width)];
	[painCanvasView  makePaintMaskViewEnable:YES];
    [painCanvasView setColorWithRed:0 Green:0 Blue:0];
    [painCanvasView setPaintLineWidth:3];
    [self.view addSubview:painCanvasView];

    
    //设置旋转动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    //设置视图旋转
    self.view.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.view.transform = CGAffineTransformMakeRotation(M_PI*1.5);
    
    [UIView commitAnimations];
    
    UIImageView *bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 32, width, 220)];
    bgImg.backgroundColor = [UIColor clearColor];
    bgImg.image = [UIImage imageNamed:@"ip_qmbj"];
    [self.view insertSubview:bgImg atIndex:0];
    
    UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, 32)];
    titleImg.backgroundColor = [UIColor clearColor];
    titleImg.image = [UIImage imageNamed:@"ip_title"];
    [self.view addSubview:titleImg];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:titleImg.frame];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = @"众付宝";
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(10, 260, 90, 50);
    clearBtn.tag = Button_Tag_Clear;
    [clearBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [clearBtn setBackgroundImage:[UIImage imageNamed:@"ip_title"] forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:clearBtn];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(width-70-30, 260, 90, 50);
    sendBtn.tag = Button_Tag_Send;
    [sendBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"ip_dl-button"] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:sendBtn];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
     [self.navigationController setNavigationBarHidden:NO animated:YES];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClickHandle:(UIButton*)button
{
    if (Button_Tag_Clear==button.tag)
    {
        [painCanvasView clearPaintMask];
    }
    else if(Button_Tag_Send==button.tag)
    {
        if (painCanvasView.drawImage.image == nil)
        {
            [SVProgressHUD showErrorWithStatus:@"请输入签名"];
            return;
        }
        
        [self uploadSignImage];
        
//        SuccessViewController *sucController = [[SuccessViewController alloc]init];
//        if (self.pageType==1)
//        {
//            sucController.messStr = @"撤销成功";
//        }
//        
//        [self.navigationController pushViewController:sucController animated:YES];
        
    }
}

#pragma mark -http请求
/**
 *  上传签名图片 转成png格式上传
 */
- (void)uploadSignImage
{
    NSData *imageData = UIImagePNGRepresentation(painCanvasView.drawImage.image);

    //图片转成16进制字符串后上传
    Byte *bytes = (Byte *)[imageData bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[imageData length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    
    NSDictionary *dict = @{kTranceCode:@"199010",
             kParamName:@{@"LOGNO":self.logNum,
                          @"ELESIGNA":hexStr}};

     AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                               prompt:nil
                                                                              success:^(id obj)
                                     {
                                         if ([obj isKindOfClass:[NSDictionary class]])
                                         {
                                             if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                             {
                                               
                                                 TradeSuccessViewController *tradeSucController = [[TradeSuccessViewController alloc] init];
                                                 tradeSucController.logNum = self.logNum;
                                                 [self.navigationController pushViewController:tradeSucController animated:YES];
                                                 
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                             }
                                             
                                         }
                                         
                                     }
                                                                              failure:^(NSString *errMsg)
                                     {
                                         [SVProgressHUD showErrorWithStatus:@"上传失败，请稍后再试!"];
                                         
                                     }];

    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在上传..." completeBlock:^(NSArray *operations) {
    }];


}
@end
