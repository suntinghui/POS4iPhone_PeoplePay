//
//  HomeViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-29.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "MerchantViewController.h"
#import "InputMoneyViewController.h"
#import "ForgetPasswordViewController.h"
#import "SettingMainViewController.h"

#define Button_Tag_Logout   100  //退出登录

#define Alert_Tag_Logout    200  //退出登录alert

#define View_Tag_StateImg   300

@interface MerchantViewController ()

@end

@implementation MerchantViewController

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

#pragma mark - 功能函数
/**
 *  页面原始初始化
 */
- (void)initPageControl
{
    [StaticTools setExtraCellLineHidden:self.listTableView];
    self.listTableView.backgroundView = nil;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logOutBtn.frame = CGRectMake(14, 10, 292, 43) ;
    logOutBtn.tag = Button_Tag_Logout;
    [logOutBtn setBackgroundImage:[UIImage imageNamed:@"ip_button"] forState:UIControlStateNormal];
    [logOutBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [logOutBtn setTitle:@"安全退出" forState:UIControlStateNormal];
    [footView addSubview:logOutBtn];
    [logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logOutBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
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
            [StaticTools showAlertWithTag:Alert_Tag_Logout
                                    title:nil
                                  message:@"您确定要退出吗？"
                                AlertType:CAlertTypeCacel
                                SuperView:self];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==Alert_Tag_Logout&&buttonIndex!=alertView.cancelButtonIndex)
    {
        UINavigationController *rootNav = (UINavigationController*)ApplicationDelegate.window.rootViewController;
        [rootNav popToRootViewControllerAnimated:YES];
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
        return 105;
    }
    return 44;
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
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"入账信息";
        [cell.contentView addSubview:titleLabel];
        titleLabel.textColor = [UIColor darkGrayColor];
        
        UILabel *cardNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 300, 20)];
        cardNumLabel.backgroundColor = [UIColor clearColor];
        cardNumLabel.font = [UIFont systemFontOfSize:15];
        cardNumLabel.text = [NSString stringWithFormat:@"银行卡号：%@",@"430******123141"];
        [cell.contentView addSubview:cardNumLabel];
        cardNumLabel.textColor = [UIColor lightGrayColor];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, 300, 20)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.text = [NSString stringWithFormat:@"开户名：   %@",@"wenbin"];
        [cell.contentView addSubview:nameLabel];
        nameLabel.textColor = [UIColor lightGrayColor];
        
        UILabel *bankLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 300, 20)];
        bankLabel.backgroundColor = [UIColor clearColor];
        bankLabel.font = [UIFont systemFontOfSize:15];
        bankLabel.text = [NSString stringWithFormat:@"开户银行：%@",@"农业银行"];
        [cell.contentView addSubview:bankLabel];
        bankLabel.textColor = [UIColor lightGrayColor];
        
    }
    else
    {
        UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 20, 19)];
        headImgView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:headImgView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 8, 200, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:titleLabel];
        if (indexPath.section==0)
        {
            titleLabel.text = @"入账信息";
             headImgView.image = [UIImage imageNamed:@"ip-rzxx"];
            
            UIImageView *stateImgView = [[UIImageView alloc]initWithFrame:CGRectMake(280, 10, 25, 25)];
            stateImgView.image = [UIImage imageNamed:@"ip-shjt"];
            stateImgView.tag = View_Tag_StateImg;
            stateImgView.backgroundColor = [UIColor clearColor];
           
            [cell.contentView addSubview:stateImgView];
        
        }
       else  if (indexPath.section==1)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (indexPath.row==0)
            {
                titleLabel.text = @"修改密码";
                headImgView.image = [UIImage imageNamed:@"ip-xgmm"];
            }
            else if (indexPath.row==1)
            {
                titleLabel.text = @"更多设置";
                headImgView.image = [UIImage imageNamed:@"ip-gdsz"];
            }
            else if (indexPath.row==2)
            {
                titleLabel.text = @"联系客服";
                headImgView.image = [UIImage imageNamed:@"ip-lxkf"];
            }
       }
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0&&indexPath.section==0)
    {
        state = (state==0?1:0);
        [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        UIImageView *imgView  = (UIImageView*)[cell.contentView viewWithTag:View_Tag_StateImg];
//        
//        CABasicAnimation* rotationAnimation;
//        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//        if (state==0)
//        {
//              rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI];
//        }
//        else
//        {
//              rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI];
//        }
//      
//        rotationAnimation.duration = 0.3;
//        rotationAnimation.cumulative = YES;
//        rotationAnimation.delegate = self;
////        rotationAnimation.repeatCount = repeat;
//         [imgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0) //修改密码
        {
            ForgetPasswordViewController *forgetPswController = [[ForgetPasswordViewController alloc]init];
            [self.navigationController pushViewController:forgetPswController animated:YES];
        }
        else if(indexPath.row==1) //更多设置
        {
            SettingMainViewController *settingMainController = [[SettingMainViewController alloc]init];
            [self.navigationController pushViewController:settingMainController animated:YES];
        }
        else if(indexPath.row==2) //联系客服
        {
            
        }
    }
}
//
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    UITableViewCell *cell = [self.listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    UIImageView *imgView  = (UIImageView*)[cell.contentView viewWithTag:View_Tag_StateImg];
//    if (state ==1)
//    {
//         imgView.transform = CGAffineTransformMakeRotation(M_PI);
//    }
//    else
//    {
//         imgView.transform = CGAffineTransformMakeRotation(0);
//    }
//}
@end
