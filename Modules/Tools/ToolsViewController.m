//
//  ToolsViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-10.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "ToolsViewController.h"
#import "SNSlistViewController.h"

#define Button_Tag_Weibo   100
#define Button_Tag_Tuijian 101

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

#pragma mark -按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    [StaticTools tapAnimationWithView:button];
    [self performSelector:@selector(handleWithTag:) withObject:[NSNumber numberWithInt:button.tag] afterDelay:0.5];
}

- (void)handleWithTag:(NSNumber*)tag
{
    switch ([tag intValue])
    {
        case Button_Tag_Weibo:
        {
            
        }
            break;
        case Button_Tag_Tuijian:
        {
            SNSlistViewController *snsListController = [[SNSlistViewController alloc]init];
            snsListController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:snsListController animated:YES];
        }
            break;
            
        default:
            break;
    }
}
@end
