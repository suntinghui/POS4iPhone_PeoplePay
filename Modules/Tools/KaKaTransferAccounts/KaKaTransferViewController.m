//
//  KaKaTransferViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-24.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "KaKaTransferViewController.h"
#import "StringUtil.h"

#define Button_Tag_TypeSelect  100
#define Button_Tag_Commit      101

#define kContent @"ContentInput"

@interface KaKaTransferViewController ()

@end

@implementation KaKaTransferViewController

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
    self.navigationItem.title = @"卡卡转账";
    
    addKeyBoardNotification = YES;
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    titles = @[@"转入卡卡主姓名",@"转出卡卡主姓名",@"证件类型",@"证件号码",@"收款银行卡号",@"还款金额",@"手机号码"];
    placeHolds = @[@"请输入姓名",@"请输入姓名",@"",@"请输入证件号码",@"请输入卡号",@"请输入金额",@"请输入接收短信的手机号"];
    credentials = @[@{@"name":@"身份证",@"code":@"01"},
                    @{@"name":@"军官证",@"code":@"02"},
                    @{@"name":@"护照",@"code":@"03"},
                    @{@"name":@"回乡证",@"code":@"04"},
                    @{@"name":@"台胞证",@"code":@"05"},
                    @{@"name":@"警官证",@"code":@"06"},
                    @{@"name":@"士兵证",@"code":@"07"},
                    @{@"name":@"其他证件类型",@"code":@"99"}];
    
    results = [[NSMutableArray alloc]init];
    
    for (NSString *title in titles)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:title forKey:@"name"];
        [results addObject:dict];
    }
    
    NSMutableDictionary *mdict = results[2]; //默认为身份证
    [mdict setObject:credentials[0][@"name"] forKey:kContent];
    [mdict setObject:credentials[0][@"code"] forKey:@"code"];
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

#pragma mark -UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
//    [self.view endEditing:YES];
}

#pragma mark -UITextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentEditIndex = textField.tag-100;
    self.listTableView.contentSize = CGSizeMake(self.listTableView.frame.size.width, self.listTableView.frame.size.height+200);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSMutableDictionary *dict = results[textField.tag-100];
    [dict setObject:textField.text forKey:kContent];

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

#pragma mark -keyboard
- (void)keyBoardShowWithHeight:(float)height
{
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:currentEditIndex inSection:0];
    
    CGRect rectForRow=[self.listTableView rectForRowAtIndexPath:indexPath];
    
    float touchSetY=(IsIPhone5?548:460)-height-rectForRow.size.height-self.listTableView.frame.origin.y-49;
    if (rectForRow.origin.y>touchSetY) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.listTableView.contentOffset=CGPointMake(0,rectForRow.origin.y-touchSetY);
        [UIView commitAnimations];
    }
}
#pragma mark -按钮点击事件
- (void)buttonClickHandle:(UIButton*)button
{
    switch (button.tag)
    {
        case Button_Tag_TypeSelect:
        {
            
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择证件类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:nil];
            
            for (NSDictionary *dict in credentials)
            {
                [sheet addButtonWithTitle:dict[@"name"]];
            }
            [sheet showInView:self.view];
        }
            break;
        case Button_Tag_Commit: //刷卡
        {
        
            [self.view endEditing:YES];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            
            self.listTableView.contentOffset=CGPointMake(0,0);
            self.listTableView.contentSize = CGSizeMake(self.listTableView.frame.size.width, self.listTableView.frame.size.height-200);
            
            [UIView commitAnimations];
            
            for (int i=0; i<results.count; i++)
            {
                NSDictionary *dict = results[i];
                if ([StaticTools isEmptyString:dict[kContent]])
                {
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请输入%@",titles[i]]];
                    return;
                }
            }
            
            
            [self kakaTransfer];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark-http请求
- (void)kakaTransfer
{
    NSString *inName = results[0][kContent];
    NSString *outName = results[1][kContent];
    NSDictionary *idType = results[2];
    NSString *idNumber = results[3][kContent];
    NSString *cardNum = results[4][kContent];
    NSString *money = results[5][kContent];
    NSString *phone = results[6][kContent];

    NSString *moneyStr = [StringUtil amount2String:money];
    
    [[DeviceHelper shareDeviceHelper]swipeCardWithControler:self
                                                       type:CSwipteCardTypeKaKaTransfer
                                                      money:money
                                              otherParamter:@{kTranceCode:@"708101"}
                                                   sucBlock:^(id mess) {
                                                       
       NSDictionary *dict = @{kTranceCode:@"708101",
                              kParamName:@{@"SELLTEL_B":[UserDefaults objectForKey:KUSERNAME],
                                           @"INCARDNAM_B":inName,
                                           @"OUTCARDNAM_B":outName,
                                           @"OUT_IDTYPNAM_B":idType[@"name"],
                                           @"OUT_IDTYP_B":idType[@"code"],
                                           @"OUT_IDCARD_B":idNumber,
                                           @"CRDNO1_B":cardNum,
                                           @"MOBILE_B":phone,
                                           @"Track2_B":[mess[kCardTrac] substringFromIndex:2], //磁道信息
                                           @"TXNAMT_B":moneyStr, //交易金额
                                           @"POSTYPE_B":@"1",    //刷卡器类型
                                           @"CHECKX_B":@"0.0",     //当前经度
                                           @"CHECKY_B":@"0.0",   //当前纬度
                                           @"TERMINALNUMBER_B":[mess[kPsamNum] stringByReplacingOccurrencesOfString:@"554E" withString:@"UN"],//机器psam号
                                           @"CRDNOJLN_B":mess[kCardPin],
                                           @"MAC_B":[StringUtil stringFromHexString:mess[kMacKey]],
                                           @"TTxnTm_B":mess[@"TTXNTM"], //交易时间
                                           @"TTxnDt_B":mess[@"TTXNDT"], //交易日期
                                           @"TSeqNo_B":mess[@"TSEQNO"]
                                           }};
       
       AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                      prompt:nil
                                                                                     success:^(id obj)
                                            {
                                                if ([obj isKindOfClass:[NSDictionary class]])
                                                {
                                                    if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                    {
                                                        
                                                        [StaticTools showSuccessPageWithMess:[NSString stringWithFormat:@"转账成功，%@",obj[@"RSPMSG"]] clickHandle:^{
                                                            
                                                            [self.navigationController popViewControllerAnimated:YES];
                                                        }];
                                                        
                                                    }
                                                    else
                                                    {
                                                        [StaticTools showErrorPageWithMess:obj[@"RSPMSG"] clickHandle:nil];
                                                    }
                                                    
                                                }
                                                
                                            }
                                                                                     failure:^(NSString *errMsg)
                                            {
                                                [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
                                                
                                            }];
       
       
       
       [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在加载..." completeBlock:^(NSArray *operations) {
       }];
       
                                                   }];
    
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0)
    {
        NSDictionary *dict = credentials[buttonIndex-1];
        NSMutableDictionary *mdict = results[2];
        [mdict setObject:dict[@"name"] forKey:@"name"];
        [mdict setObject:dict[@"code"] forKey:@"code"];
        [self.listTableView reloadData];
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
    
    if (indexPath.row==titles.count||indexPath.row==titles.count-1)
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
        
        UITextField *inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(130, 16, 180, 20)];
        inputTextField.placeholder = placeHolds[indexPath.row];
        inputTextField.tag = indexPath.row+100;
        inputTextField.delegate = self;
        inputTextField.font = [UIFont systemFontOfSize:16];
        inputTextField.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:inputTextField];
        
        if (indexPath.row==0||indexPath.row==1)
        {
            inputTextField.keyboardType = UIKeyboardAppearanceDefault;
        }
        else
        {
            inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        if (indexPath.row==2)
        {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = Button_Tag_TypeSelect;
            [button setBackgroundImage:[UIImage imageNamed:@"selectbg"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(130, 8, 180, 35);
            [cell.contentView insertSubview:button belowSubview:inputTextField];
            
            inputTextField.frame  = CGRectMake(130, 16, 110, 20);
            inputTextField.enabled = NO;
        }
        else
        {
            
            UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 8, 180, 35)];
            bgImgView.image = [UIImage imageNamed:@"textInput"];
            [cell.contentView insertSubview:bgImgView belowSubview:inputTextField];
            
          if(indexPath.row==titles.count-1)
            {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 47, 320, 20)];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor lightGrayColor];
                label.textAlignment = UITextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:15];
                label.text = @"资金到账后短信提醒";
                [cell.contentView addSubview:label];
            }
        }
        
        NSDictionary *dict = results[indexPath.row];
        inputTextField.text = dict[kContent];
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
