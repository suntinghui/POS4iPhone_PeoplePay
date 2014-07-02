//
//  CustomSelectViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-25.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "CustomSelectViewController.h"

@interface CustomSelectViewController ()

@end

@implementation CustomSelectViewController

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
    self.navigationItem.title = self.titleStr;
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    self.selectDatas = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)back
{
    [self dismissModalViewControllerAnimated:YES];
    if (self.finishSelect)
    {
        self.finishSelect(self.selectDatas);
    }
}
#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.datas[indexPath.row];
    float height = [StaticTools getLabelHeight:dict[@"name"] defautWidth:270 defautHeight:480 fontSize:15];
    return height+20;
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
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSDictionary *dict = self.datas[indexPath.row];
    
    float height = [StaticTools getLabelHeight:dict[@"name"] defautWidth:270 defautHeight:480 fontSize:15];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 270, height)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.text = dict[@"name"];
    [cell.contentView addSubview:textLabel];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(280, (height+20-28)/2, 28, 28)];
    imageView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:imageView];
    
    BOOL selected = NO;
    for (NSDictionary *selectDict in self.selectDatas)
    {
        if (dict == selectDict)
        {
            selected = YES;
            break;
        }
    }
    imageView.image = [UIImage imageNamed:selected?@"checkBox":@"uncheckBox"];
    
    return cell;
 
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.datas[indexPath.row];
    if (self.selectType == CSelectTypeSingle)
    {
        [self.selectDatas removeAllObjects];
        [self.selectDatas addObject:dict];
        [self.listTableView reloadData];
    }
    else
    {
        if ([self.selectDatas containsObject:dict])
        {
            [self.selectDatas removeObject:dict];
        }
        else
        {
            [self.selectDatas addObject:dict];
        }
        [self.listTableView reloadData];
    }
}

@end
