//
//  AccountInfoViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-25.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "IDcardUploadViewController.h"

#define Button_Tag_ProvinceSelect   100
#define Button_Tag_CitySelect       101
#define Button_Tag_BankSelect       102
#define Button_Tag_BankPlaceSelect  103
#define Button_Tag_Commit           104



@interface AccountInfoViewController ()

@end

@implementation AccountInfoViewController

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
    self.navigationItem.title = @"账户信息(2/3)";
    
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    titles = @[@"开户名",@"开户地点",@"开户银行",@"银行网点",@"银行账户"];
    keys = @[kCardName,kProvince,kCity,kBank,kBankPlace,kCardNumber];
    resultDict = [[NSMutableDictionary alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    [self getProviceData];
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
- (void)resetTabelView
{
    [self.view endEditing:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.listTableView.contentOffset=CGPointMake(0,0);
    self.listTableView.contentSize = CGSizeMake(self.listTableView.frame.size.width, self.listTableView.frame.size.height-200);
    
    [UIView commitAnimations];
}
#pragma mark- http请求
/**
 *  获取省份数据
 */
- (void)getProviceData
{
    NSDictionary *dict = @{kTranceCode:@"199031"};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                 {
                                                     
                                                     self.provins = obj[@"LIST"];
                                                     NSDictionary *dict = self.provins[0];
                                                     [resultDict setObject:dict forKey:kProvince];
                                                     [self.listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                                     
                                                     [self getCityData];
                                                     
                                                     [self getBankData];
                                                     
                                                     [self getBankPlaces];
                                                     
                                                 }
                                                 else
                                                 {
                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"省份获取失败，请稍后再试!"];
                                             
                                         }];
    
    
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在获取省份..." completeBlock:^(NSArray *operations) {
    }];
}

/**
 *  获取城市数据
 */
- (void)getCityData
{
    NSDictionary *proDict = resultDict[kProvince];
    if (proDict==nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请先选择省份"];
        return;
    }
    
    NSDictionary *dict = @{kTranceCode:@"199032",
                           kParamName:@{@"PARCOD":proDict[@"code"]}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                 {
                                                     
                                                     self.citys = obj[@"LIST"];
                                                     NSDictionary *dict = self.citys[0];
                                                     [resultDict setObject:dict forKey:kCity];
                                                     [self.listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                                     
                                                 }
                                                 else
                                                 {
                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"城市获取失败，请稍后再试!"];
                                             
                                         }];
    
    
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在获取城市..." completeBlock:^(NSArray *operations) {
    }];
}

/**
 *  获取银行列表
 */
- (void)getBankData
{
    NSDictionary *proDict = resultDict[kProvince];
    if (proDict==nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请先选择省份"];
        return;
    }
    
    NSDictionary *dict = @{kTranceCode:@"199035",
                           kParamName:@{@"PARCOD":proDict[@"code"]}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                 {
                                                     
                                                     self.banks = obj[@"LIST"];
                                                     NSDictionary *dict = self.banks[0];
                                                     [resultDict setObject:dict forKey:kBank];
                                                     [self.listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                                     
                                                     [self getBankPlaces];
                                                     
                                                 }
                                                 else
                                                 {
                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"银行信息获取失败，请稍后再试!"];
                                             
                                         }];
    
    
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在获取银行..." completeBlock:^(NSArray *operations) {
    }];
}


/**
 *  获取银行网点
 */
- (void)getBankPlaces
{
    NSDictionary *cityDict = resultDict[kCity];
    if (cityDict==nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请先选择城市"];
        return;
    }
    
    NSDictionary *bankDict = resultDict[kBank];
    if (bankDict==nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请先选择银行"];
        return;
    }
   
    NSDictionary *dict = @{kTranceCode:@"199034",
                           kParamName:@{@"BBANKCOD":bankDict[@"code"],
                                        @"CITYCOD":cityDict[@"code"]}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                 {
                                                     
                                                     self.bankPlaces = obj[@"LIST"];
                                                     if (self.bankPlaces.count>0)
                                                     {
                                                         NSDictionary *dict = self.bankPlaces[0];
                                                         [resultDict setObject:dict forKey:kBankPlace];
                                                       
                                                     }
                                                     else if(self.bankPlaces.count==0)
                                                     {
                                                         [resultDict setObject:@{@"name":@"该银行在开户地无网点信息",@"code":@"-1"} forKey:kBankPlace];
                                                     }
                                                     
                                                       [self.listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                                     
                                                 }
                                                 else
                                                 {
                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"支行信息获取失败，请稍后再试!"];
                                             
                                         }];
    
    
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在获取支行信息..." completeBlock:^(NSArray *operations) {
    }];
}

#pragma mark -UITextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentEditIndex = textField.tag-100;
    self.listTableView.contentSize = CGSizeMake(self.listTableView.frame.size.width, self.listTableView.frame.size.height+200);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 100) //开户名
    {
        [resultDict setObject:textField.text forKey:kCardName];
    }
    else if(textField.tag == 104) //银行账户
    {
        [resultDict setObject:textField.text forKey:kCardNumber];
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.listTableView.contentOffset=CGPointMake(0,0);
    self.listTableView.contentSize = CGSizeMake(self.listTableView.frame.size.width, self.listTableView.frame.size.height-200);
    
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
      
        case Button_Tag_ProvinceSelect: //省份选择
        {
            if (self.provins.count>0)
            {
                [StaticTools showCustomSelectWithControl:self title:@"省份选择" Data:self.provins selectType:CSelectTypeSingle finishiOpeare:^(id select) {
                    
                    NSArray *arr = (NSArray*)select;
                    if (arr.count>0)
                    {
                        [resultDict setObject:arr[0] forKey:kProvince];
                        [self.listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        
                        [self getCityData];
                        
                        [self getBankData];
                        
                        [self getBankPlaces];
                    }
                }];
            }
            else
            {
                [self getProviceData];
            }
            
            
        }
            break;
        case Button_Tag_CitySelect: //城市选择
        {
            if (self.citys.count>0)
            {
                [StaticTools showCustomSelectWithControl:self title:@"城市选择" Data:self.citys selectType:CSelectTypeSingle finishiOpeare:^(id select) {
                    
                    NSArray *arr = (NSArray*)select;
                    if (arr.count>0)
                    {
                        [resultDict setObject:arr[0] forKey:kCity];
                        [self.listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        
                        [self getBankPlaces];
                    }
                }];
            }
            else
            {
                [self getCityData];
            }
        }
            break;
        case Button_Tag_BankSelect: //银行名称选择
        {
            if (self.banks.count>0)
            {
                [StaticTools showCustomSelectWithControl:self title:@"银行选择" Data:self.banks selectType:CSelectTypeSingle finishiOpeare:^(id select) {
                    
                    NSArray *arr = (NSArray*)select;
                    if (arr.count>0)
                    {
                        [resultDict setObject:arr[0] forKey:kBank];
                        [self.listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        
                        [self getBankPlaces];
                    }
                }];
            }
            else
            {
                [self getBankData];
            }
        }
            break;
        case Button_Tag_BankPlaceSelect: //支行选择
        {
            if (self.bankPlaces.count>0)
            {
                [StaticTools showCustomSelectWithControl:self title:@"支行选择" Data:self.bankPlaces selectType:CSelectTypeSingle finishiOpeare:^(id select) {
                    
                    NSArray *arr = (NSArray*)select;
                    if (arr.count>0)
                    {
                        [resultDict setObject:arr[0] forKey:kBankPlace];
                        [self.listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
            }
            else
            {
                [self getBankPlaces];
            }
        }
            break;
        case Button_Tag_Commit:
        {
            
            [self resetTabelView];
            
            for (int i=0; i<keys.count; i++)
            {
                NSString *key = keys[i];
                if (resultDict[key]==nil)
                {
                    int j=i;
                    if (j>=2)
                    {
                        j=i-1;
                    }
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请输入%@",titles[j]]];
                    return;
                }
            }
            
            if ([resultDict[kBankPlace][@"code"] isEqualToString:@"-1"])
            {
                [SVProgressHUD showErrorWithStatus:@"网点信息为空，请重新选择。"];
                return;
            }
            
            [APPDataCenter.comDict addEntriesFromDictionary:resultDict];
    
            IDcardUploadViewController *idCardUploadController = [[IDcardUploadViewController alloc]init];
            [self.navigationController pushViewController:idCardUploadController animated:YES];
            
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
    else if(indexPath.row==2||indexPath.row==3)
    {
        NSDictionary *dict = indexPath.row==2?resultDict[kBank]:resultDict[kBankPlace];
        float height = [StaticTools getLabelHeight:dict[@"name"]  defautWidth:200 defautHeight:480 fontSize:16];
        height=height<30?30:height;
        
        return height+20;
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
        

        if (indexPath.row==1)
        {
            //省份选择
            UIButton *ProviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [ProviceBtn setBackgroundImage:[UIImage imageNamed:@"selectbg"] forState:UIControlStateNormal];
            [ProviceBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            ProviceBtn.tag = Button_Tag_ProvinceSelect;
            ProviceBtn.frame = CGRectMake(80, 9, 100, 35);
            [cell.contentView addSubview:ProviceBtn];
            
            UILabel *proviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 11, 90, 30)];
            proviceLabel.backgroundColor = [UIColor clearColor];
            proviceLabel.textAlignment = UITextAlignmentCenter;
            proviceLabel.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:proviceLabel];
            NSDictionary *proDict = resultDict[kProvince];
            if (proDict!=nil)
            {
                proviceLabel.text = proDict[@"name"];
            }
            
            
            //城市选择
            UIButton *CityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [CityBtn setBackgroundImage:[UIImage imageNamed:@"selectbg"] forState:UIControlStateNormal];
            [CityBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            CityBtn.frame = CGRectMake(210, 9, 100, 35);
            CityBtn.tag = Button_Tag_CitySelect;
            [cell.contentView addSubview:CityBtn];
            
            UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 11, 90, 30)];
            cityLabel.backgroundColor = [UIColor clearColor];
            cityLabel.font = [UIFont systemFontOfSize:16];
            cityLabel.textAlignment = UITextAlignmentCenter;
            [cell.contentView addSubview:cityLabel];
            NSDictionary *cityDict = resultDict[kCity];
            if (proDict!=nil)
            {
                cityLabel.text = cityDict[@"name"];
            }
            
        }
        else if(indexPath.row==2||indexPath.row==3)
        {
            
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 10, 200, 40)];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.font = [UIFont systemFontOfSize:16];
            textLabel.numberOfLines = 0;
            textLabel.lineBreakMode = UILineBreakModeCharacterWrap;
            [cell.contentView addSubview:textLabel];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"selectbg"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(80, 8, 230, 35);
            [cell.contentView insertSubview:button belowSubview:textLabel];
            if (indexPath.row==2)
            {
                button.tag = Button_Tag_BankSelect;
                NSDictionary *dict = resultDict[kBank];
                if (dict!=nil)
                {
                    textLabel.text = dict[@"name"];
                }
                
            }
            else
            {
                button.tag = Button_Tag_BankPlaceSelect;
                NSDictionary *dict = resultDict[kBankPlace];
                if (dict!=nil)
                {
                    textLabel.text = dict[@"name"];
                }
            }
            
            float height = [StaticTools getLabelHeight:textLabel.text defautWidth:textLabel.frame.size.width defautHeight:480 fontSize:16];
            height=height<30?30:height;
            textLabel.frame = CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y, textLabel.frame.size.width, height);
            button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width, textLabel.frame.size.height+5);

        }
        else
        {
            UITextField *inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(85, 16, 225, 20)];
            inputTextField.tag = indexPath.row+100;
            inputTextField.delegate = self;
            inputTextField.font = [UIFont systemFontOfSize:16];
            inputTextField.returnKeyType = UIReturnKeyDone;
            [cell.contentView addSubview:inputTextField];
            
            if (indexPath.row==0||indexPath.row==4)
            {
                UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 8, 230, 35)];
                bgImgView.image = [UIImage imageNamed:@"textInput"];
                [cell.contentView insertSubview:bgImgView belowSubview:inputTextField];
                
                if (indexPath.row==0)
                {
                   inputTextField.placeholder = @"请输入开户名";
                    inputTextField.text = resultDict[kCardName];
                }
                else
                {
                    inputTextField.placeholder = @"请输入银行账号";
                    inputTextField.text = resultDict[kCardNumber];
                    inputTextField.keyboardType = UIKeyboardTypeNumberPad;
                    
                }
            }
        }
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
