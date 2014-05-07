//
//  HomeViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-29.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "HomeViewController.h"
#import "InputMoneyViewController.h"

#define Button_Tag_Logout   100  //退出登录

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    
    [self initPageControl];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 功能函数
/**
 *  页面原始初始化
 */
- (void)initPageControl
{
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *logOutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logOutBtn.frame = CGRectMake(30, 10, 260, 40) ;
    logOutBtn.tag = Button_Tag_Logout;
    [logOutBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [footView addSubview:logOutBtn];
    self.listTableView.tableFooterView = footView;
    
}

#pragma mark - 按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *buton = (UIButton*)sender;
    switch (buton.tag)
    {
        case Button_Tag_Logout: //退出登录
        {
            [StaticTools showLockView];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        if (state==0)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
    else
    {
        return 3;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==0?0:10;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1&&indexPath.section==0)
    {
        return 100;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.section==0&&indexPath.row==1)
    {
       
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.text = @"入账信息";
        [cell.contentView addSubview:titleLabel];
        
        UILabel *cardNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 300, 20)];
        cardNumLabel.backgroundColor = [UIColor clearColor];
        cardNumLabel.font = [UIFont systemFontOfSize:15];
        cardNumLabel.text = [NSString stringWithFormat:@"银行卡号：%@",@"430******123141"];
        [cell.contentView addSubview:cardNumLabel];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, 300, 20)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.text = [NSString stringWithFormat:@"开户名：  %@",@"wenbin"];
        [cell.contentView addSubview:nameLabel];
        
        UILabel *bankLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 300, 20)];
        bankLabel.backgroundColor = [UIColor clearColor];
        bankLabel.font = [UIFont systemFontOfSize:15];
        bankLabel.text = [NSString stringWithFormat:@"开户银行：%@",@"农业银行"];
        [cell.contentView addSubview:bankLabel];
        
    }
    else
    {
        UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        headImgView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:headImgView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 200, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:titleLabel];
        if (indexPath.section==0)
        {
            titleLabel.text = @"入账信息";
            
            UIImageView *stateImgView = [[UIImageView alloc]initWithFrame:CGRectMake(280, 10, 30, 30)];
            stateImgView.backgroundColor = state==0?[UIColor lightGrayColor]:[UIColor blackColor];
            [cell.contentView addSubview:stateImgView];
        
        }
       else  if (indexPath.section==1)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (indexPath.row==0)
            {
                titleLabel.text = @"修改密码";
            }
            else if (indexPath.row==1)
            {
                titleLabel.text = @"更多设置";
            }
            else if (indexPath.row==2)
            {
                titleLabel.text = @"联系客服";
            }
       }
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0&&indexPath.section==0)
    {
        state = (state==0?1:0);
        [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            InputMoneyViewController *inputMoneyController = [[InputMoneyViewController alloc]initWithNibName:@"InputMoneyViewController" bundle:nil];
            [self.navigationController pushViewController:inputMoneyController animated:YES];
        }
    }
}
@end
