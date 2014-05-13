//
//  SettingMainViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-12.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "SettingMainViewController.h"
#import "AbountViewController.h"
#import "LockViewController.h"
#import "TimedoutUtil.h"
#import "SetMoveLockViewController.h"

@interface SettingMainViewController ()

@end

@implementation SettingMainViewController

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
    self.navigationItem.title = @"设置";
    [StaticTools setExtraCellLineHidden:self.listTableView];
    self.listTableView.backgroundColor = [UIColor clearColor];
    
    lockSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(215, 8, 60, 30)];
    [lockSwitch addTarget:self action:@selector(lockValueChange:) forControlEvents:UIControlEventValueChanged];
    NSString *state = [UserDefaults objectForKey:kMoveUnlockState];
    if ([state isEqualToString:@"0"])
    {
        [lockSwitch setOn:NO];
    }
    else
    {
        [lockSwitch setOn:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 按钮点击
- (void)lockValueChange:(id)sender
{
    if (lockSwitch.isOn)
    {
        [UserDefaults setObject:@"1" forKey:kMoveUnlockState];
    }
    else
    {
        [UserDefaults setObject:@"0" forKey:kMoveUnlockState];
        [[TimedoutUtil sharedInstance] stopTimer];
    }
    
    [UserDefaults synchronize];
    
}

#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?1:4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==0?0:10;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [[UIView alloc]initWithFrame:CGRectZero];
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
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
       UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 20, 19)];
    headImgView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:headImgView];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 8, 200, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:titleLabel];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section==0)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        headImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ip_gdtb%d",1]];
        titleLabel.text = @"设置锁屏手势";
        if (![cell.contentView.subviews containsObject:lockSwitch])
        {
            [cell.contentView addSubview:lockSwitch];
        }
    }
    else if(indexPath.section==1)
    {
        headImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ip_gdtb%d",indexPath.row+2]];
        if (indexPath.row==0)
        {
            titleLabel.text = @"关于系统";
        }
        else if (indexPath.row==1)
        {
            titleLabel.text = @"意见反馈";
        }
        else if (indexPath.row==2)
        {
            titleLabel.text = @"检查更新";
        }
        else if (indexPath.row==3)
        {
            titleLabel.text = @"帮助";
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
    if (indexPath.section==0)
    {
        SetMoveLockViewController *setMoveLockController = [[SetMoveLockViewController alloc]init];
        [self.navigationController pushViewController:setMoveLockController animated:YES];
    }
    else if(indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            AbountViewController *aboutController = [[AbountViewController alloc]init];
            [self.navigationController pushViewController:aboutController animated:YES];

        }
    }

}
@end
