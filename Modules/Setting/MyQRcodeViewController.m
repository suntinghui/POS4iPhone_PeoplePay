//
//  MyQRcodeViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-9-9.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "MyQRcodeViewController.h"
#import "QRCodeGenerator.h"
#import "AESUtil.h"

@interface MyQRcodeViewController ()

@end

@implementation MyQRcodeViewController

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
    self.navigationItem.title = @"我的二维码";
    
    NSString *info = [NSString stringWithFormat:@"%@|%@",[UserDefaults objectForKey:KUSERNAME],self.nameStr] ;
    info = [AESUtil encryptUseAES:info];
    
    self.qrImageView.image = [QRCodeGenerator qrImageForString:info imageSize:self.qrImageView.frame.size.width];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
