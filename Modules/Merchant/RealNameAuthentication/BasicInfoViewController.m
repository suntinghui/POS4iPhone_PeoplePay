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
    placeHolds = @[@"请输入姓名",@"请输入身份证号",@"请输入商户名称",@"",@"请输入经营地址",@"请输入购买机器的序列号"];
    keys = @[kUserName,kUserIdCard,kMerchantName,kServiceType,kServicePlace,kDeviceNumber];
    
   serviceTypes = @[@{@"name":@"服装",@"code":@""},
                     @{@"name":@"3c家电",@"code":@""},
                     @{@"name":@"美容化妆、健身养生",@"code":@""},
                     @{@"name":@"品牌直销",@"code":@""},
                     @{@"name":@"办公用品印刷",@"code":@""},
                     @{@"name":@"家居建材家具",@"code":@""},
                     @{@"name":@"商业服务、成人教育",@"code":@""},
                     @{@"name":@"生活服务",@"code":@""},
                     @{@"name":@"箱包皮具服饰",@"code":@""},
                     @{@"name":@"食品饮料烟酒零售",@"code":@""},
                     @{@"name":@"文化体育休闲玩意",@"code":@""},
                     @{@"name":@"杂货超市",@"code":@""},
                     @{@"name":@"餐饮娱乐、休闲度假",@"code":@""},
                     @{@"name":@"汽车、自行车",@"code":@""},
                     @{@"name":@"珠宝工艺、古董花鸟",@"code":@""},
                     @{@"name":@"彩票充值票务旅游",@"code":@""},
                     @{@"name":@"药店及医疗服务",@"code":@""},
                     @{@"name":@"物流、租赁",@"code":@""},
                     @{@"name":@"公益类",@"code":@""}];
    
    resultDict = [[NSMutableDictionary alloc]init];
    [resultDict setObject:serviceTypes[0][@"name"] forKey:kServiceType];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -功能函数
- (void)resetTableView
{
    [self.view endEditing:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.listTableView.contentOffset=CGPointMake(0,0);
    self.listTableView.contentSize = CGSizeMake(self.listTableView.frame.size.width, self.listTableView.frame.size.height-200);
    
    [UIView commitAnimations];
}

#pragma mark -UITextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentEditIndex = textField.tag-100;
    self.listTableView.contentSize = CGSizeMake(self.listTableView.frame.size.width, self.listTableView.frame.size.height+160);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *key = keys[textField.tag-100];
    [resultDict setObject:textField.text forKey:key];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.listTableView.contentOffset=CGPointMake(0,0);
    self.listTableView.contentSize = CGSizeMake(self.listTableView.frame.size.width, self.listTableView.frame.size.height-160);
    
    [UIView commitAnimations];
    
    return YES;
}
#pragma mark -keyboardDelegate
-(void)keyboardWasShown:(NSNotification *)notification
{
    
    NSValue  *valu_=[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGRect rectForkeyBoard=[valu_ CGRectValue];
    keyBoardLastHeight=rectForkeyBoard.size.height;
    
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:currentEditIndex inSection:0];
    CGRect rectForRow=[self.listTableView rectForRowAtIndexPath:indexPath];
    
    float touchSetY=(IsIPhone5?548:460)-rectForkeyBoard.size.height-rectForRow.size.height-self.listTableView.frame.origin.y-49;
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
        case Button_Tag_TypeSelect: //经营范围选择
        {
            [self resetTableView];
            
            [StaticTools showCustomSelectWithControl:self title:@"经营范围" Data:serviceTypes selectType:CSelectTypeSingle finishiOpeare:^(id select) {
                NSArray *arr = (NSArray*)select;
                if (arr.count>0)
                {
                    [resultDict setObject:arr[0][@"name"] forKey:kServiceType];
                    [self.listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
               
            }];
           
        }
            break;
        case Button_Tag_Commit:
        {
            
            [self resetTableView];
            
//            for (int i=0; i<keys.count; i++)
//            {
//                NSString *key = keys[i];
//                if ([StaticTools isEmptyString:resultDict[key]])
//                {
//                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请输入%@",titles[i]]];
//                    return;
//                }
//            }
            
            APPDataCenter.comDict = [[NSMutableDictionary alloc]initWithDictionary:resultDict];
            
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
        
        UITextField *inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(113, 16, 197, 20)];
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
            
            inputTextField.frame  = CGRectMake(110, 16, 170, 20);
            inputTextField.enabled = NO;
            
        }
        else
        {
            
            UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 8, 200, 35)];
            bgImgView.image = [UIImage imageNamed:@"textInput"];
            [cell.contentView insertSubview:bgImgView belowSubview:inputTextField];
            
            if (indexPath.row==1||indexPath.row==5)
            {
                inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            }
            
        }
        
        inputTextField.text = resultDict[keys[indexPath.row]];
       
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
