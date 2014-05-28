//
//  DeviceSearchViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-21.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "DeviceSearchViewController.h"

@interface DeviceSearchViewController ()

@end

@implementation DeviceSearchViewController

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
    self.navigationItem.title = @"连接设备";
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [self.bgImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
    CGAffineTransform  transform;
    transform = CGAffineTransformScale(self.deviceImgView.transform,2,2);
    [UIView beginAnimations:@"scale" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    [self.deviceImgView setTransform:transform];
    [UIView commitAnimations];
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    [[DeviceHelper shareDeviceHelper] cancleSwipeCard];
}
@end
