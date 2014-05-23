//
//  SNSlistViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-21.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "SNSlistViewController.h"
#import "SNSshareViewController.h"

@interface SNSlistViewController ()

@end

@implementation SNSlistViewController

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
    self.navigationItem.title = @"推荐我们";
    [StaticTools setExtraCellLineHidden:self.listTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    UIImageView *logoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 30, 30)];
    logoImgView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:logoImgView];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 8, 100, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:textLabel];
    
    if (indexPath.row==0)
    {
        logoImgView.image = [UIImage imageNamed:@"share_sina_weibo"];
        textLabel.text = @"新浪微博";
    }
    else if(indexPath.row==1)
    {
        logoImgView.image = [UIImage imageNamed:@"share_weixin"];
        textLabel.text = @"微信好友";
    }
    else if(indexPath.row==2)
    {
        logoImgView.image = [UIImage imageNamed:@"share_weixin_friend"];
        textLabel.text = @"微信朋友圈";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0)
    {
        SNSshareViewController *snsShareController = [[SNSshareViewController alloc]init];
        [self.navigationController pushViewController:snsShareController animated:YES];
    }
    else if(indexPath.row==1||indexPath.row==2)
    {
        if (![WXApi isWXAppInstalled])
        {
         
            [SVProgressHUD showErrorWithStatus:@"请先安装微信客户端"];
            return;
        }
        if ([WXApi openWXApp])
        {
            //通过微信邀请客户
            [ApplicationDelegate  sendNewsContentwithType:indexPath.row==1?WXSceneSession:WXSceneTimeline
                                                    Title:nil
                                              description:@"众付宝"
                                               thumbimage:[UIImage imageNamed:@"ip_gyxtlogo"]
                                            withDetailUrl:@"http://www.people2000.net"];
            
        
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"微信启动失败"];
        }
    }
    
}
@end
