//
//  BasicInfoViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-25.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "BasicInfoViewController.h"
#import "AccountInfoViewController.h"

#define Button_Tag_TypeSelect  100
#define Button_Tag_Commit      101

@interface BasicInfoViewController ()

@end

@implementation BasicInfoViewController

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
    self.navigationItem.title = @"基本信息(1/3)";
    
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    titles = @[@"申请人姓名",@"身份证号码",@"商户名称",@"经营范围",@"经营地址",@"机器序列号"];
    placeHolds = @[@"请输入姓名",@"请输入身份证号",@"请输入商户名称",@"",@"请输入经营地址",@"请输入购买机器的序列号",];
    
    results = [[NSMutableArray alloc]init];
    for (NSString *title in titles)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:title forKey:@"name"];
        [results addObject:dict];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentEditIndex = textField.tag-100;
    self.listTableView.contentSize = CGSizeMake(self.listTableView.frame.size.width, self.listTableView.frame.size.height+100);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    NSMutableDictionary *dict = results[textField.tag-100];
    [dict setObject:textField.text forKey:@"InputContent"];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.listTableView.contentOffset=CGPointMake(0,0);
    self.listTableView.contentSize = CGSizeMake(self.listTableView.frame.size.width, self.listTableView.frame.size.height-100);
    
    [UIView commitAnimations];
    
    return YES;
}
#pragma mark -keyboardDelegate
-(void)keyboardWasShown:(NSNotification *)notification
{
    
    NSValue  *valu_=[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    
    CGRect rectForkeyBoard=[valu_ CGRectValue];
    
    //    self.listTableView.contentSize=CGSizeMake(self.listTableView.contentSize.width,self.listTableView.contentSize.height+rectForkeyBoard.size.height-keyBoardLastHeight);
    
    keyBoardLastHeight=rectForkeyBoard.size.height;
    
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:currentEditIndex inSection:0];
    
    CGRect rectForRow=[self.listTableView rectForRowAtIndexPath:indexPath];
    
    float touchSetY=(IsIPhone5?548:460)-rectForkeyBoard.size.height-rectForRow.size.height-self.listTableView.frame.origin.y-49;//44为navigationController的高度,如果没有就不用减去44
    if (rectForRow.origin.y>touchSetY) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.listTableView.contentOffset=CGPointMake(0,rectForRow.origin.y-touchSetY);
        [UIView commitAnimations];
    }
    
    
}

-(void)keyboardWasHidden:(NSNotification *)notification
{
    
    keyBoardLastHeight=0;
    
}

#pragma mark -按钮点击事件
- (void)buttonClickHandle:(UIButton*)button
{
    switch (button.tag)
    {
        case Button_Tag_TypeSelect:
        {
            NSArray *arr = @[@{@"name":@"测试1",@"code":@"1"},@{@"name":@"测试2",@"code":@"3"}];
            [StaticTools showCustomSelectWithControl:self title:@"经营范围" Data:arr selectType:CSelectTypeMulty finishiOpeare:^(id select) {
                
            }];
           
        }
            break;
        case Button_Tag_Commit:
        {
            
            [self.view endEditing:YES];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            
            self.listTableView.contentOffset=CGPointMake(0,0);
            self.listTableView.contentSize = CGSizeMake(self.listTableView.frame.size.width, self.listTableView.frame.size.height-200);
            
            [UIView commitAnimations];
            
//            for (int i=0; i<results.count; i++)
//            {
//                NSDictionary *dict = results[i];
//                if ([StaticTools isEmptyString:dict[@"InputContent"]])
//                {
//                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请输入%@",titles[i]]];
//                    break;
//                }
//            }
            
            AccountInfoViewController *accountInfoController = [[AccountInfoViewController alloc]init];
            [self.navigationController pushViewController:accountInfoController animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return titles.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==titles.count)
    {
        return 70;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.row<titles.count)
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.text = titles[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        
        UITextField *inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(110, 14, 200, 30)];
        inputTextField.placeholder = placeHolds[indexPath.row];
        inputTextField.tag = indexPath.row+100;
        inputTextField.delegate = self;
        inputTextField.font = [UIFont systemFontOfSize:16];
        inputTextField.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:inputTextField];
        
        if (indexPath.row==3)
        {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = Button_Tag_TypeSelect;
            [button setBackgroundImage:[UIImage imageNamed:@"selectbg"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(110, 8, 200, 35);
            [cell.contentView insertSubview:button belowSubview:inputTextField];
            
            inputTextField.frame  = CGRectMake(110, 14, 130, 30);
            inputTextField.enabled = NO;
        }
        else
        {
            
            UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 8, 200, 35)];
            bgImgView.image = [UIImage imageNamed:@"textInput"];
            [cell.contentView insertSubview:bgImgView belowSubview:inputTextField];
        }
        
        NSDictionary *dict = results[indexPath.row];
        inputTextField.text = dict[@"InputContent"];
    }
    else
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"ip_button"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"ip_button2"] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(15, 10, 290, 44);
        button.tag = Button_Tag_Commit;
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:button];
        
    }
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
