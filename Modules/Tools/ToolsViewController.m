//
//  ToolsViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-10.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "ToolsViewController.h"

@interface ToolsViewController ()

@end

@implementation ToolsViewController

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
    self.navigationItem.hidesBackButton = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (IsIPhone5)
    {
        self.toolsView.frame = CGRectMake(0, 240, self.toolsView.frame.size.width, self.toolsView.frame.size.height);
        self.topImgView.frame = CGRectMake(0, self.topImgView.frame.origin.y, self.topImgView.frame.size.width, self.topImgView.frame.size.height+50);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
