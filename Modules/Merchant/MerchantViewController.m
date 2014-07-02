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
#import "ChangePasswordViewController.h"
#import "Base64.h"
#import "BasicInfoViewController.h"
#import "MyAccountViewController.h"

#define Button_Tag_Logout        100 //退出登录
#define Button_Tag_ChangeHeadImg 101 //修改头像
#define Button_Tag_ChangeBg      102 //修改大背景图

#define Alert_Tag_Logout         200 //退出登录alert

#define View_Tag_StateImg        300

#define Action_Tag_Phone         400
#define Action_Tag_Camara        401

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
    
   
    [self getMerchantInfo];
    
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
    [logOutBtn setBackgroundImage:[UIImage imageNamed:@"ip_button2"] forState:UIControlStateHighlighted];
    [logOutBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [logOutBtn setTitle:@"安全退出" forState:UIControlStateNormal];
    [footView addSubview:logOutBtn];
    
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logOutBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.listTableView.tableFooterView = footView;
    
}

- (NSString*)getText:(NSString*)text
{
    if ([StaticTools isEmptyString:text])
    {
        return @"";
    }
    return text;
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
        case Button_Tag_ChangeHeadImg: //修改头像
        {
            camaType = 0;
            
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"照相机", nil];
            sheet.tag = Action_Tag_Camara;
            [sheet showInView:self.view.window];
      
        }
            break;
        case Button_Tag_ChangeBg: //修改大背景图
        {
            camaType = 1;
            
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"照相机", nil];
            sheet.tag = Action_Tag_Camara;
            [sheet showInView:self.view.window];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == Action_Tag_Phone)
    {
        if (buttonIndex==0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006269987"]];
        }
    }
    else if(actionSheet.tag == Action_Tag_Camara)
    {
        if (buttonIndex==0)
        {
               imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }
        else if(buttonIndex==1)
        {
               imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }
    }
   
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (camaType==0)
    {
        image = [self imageWithImage:image scaledToSize:CGSizeMake(100,100)];
        
        //    self.headImgView.image = [StaticTools circleImage:image withParam:0];
        [self upLoadHeadImage:image];
    }
    else if(camaType ==1)
    {
        image = [self imageWithImage:image scaledToSize:CGSizeMake(320,160)];
        
        [self upLoadBigBackImage:image];
    }

    
	[picker dismissViewControllerAnimated:YES completion:^{}];
   
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
	UIGraphicsBeginImageContext(newSize);
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

#pragma mark- HTTP请求
/**
 *  头像上传
 *
 *  @param image
 */
- (void)upLoadHeadImage:(UIImage*)image
{
    NSDictionary *dict = @{kTranceCode:@"200000",
                           kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                                        @"HEADIMG":[Base64 encode:UIImagePNGRepresentation(image)],
                                        @"operationId":@"setHeadImg"}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"000000"])
                                                 {
                                                  
                                                     UIImage  *imageChange = [StaticTools circleImage:image withParam:0];
//                                                     self.headImgView.image = imageChange;
                                                     [self.headBtn setBackgroundImage:imageChange forState:UIControlStateNormal];
                                                     [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
                                                     
                                                 }
                                                 else
                                                 {
                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"上传失败，请稍后再试!"];
                                             
                                         }];
    
    
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在上传..." completeBlock:^(NSArray *operations) {
    }];
    
}

/**
 *  头像下载
 *
 *  @param image
 */
- (void)downLoadHeadImg
{
    NSDictionary *dict = @{kTranceCode:@"200001",
                           kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                                        @"operationId":@"getHeadImg"}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"000000"])
                                                 {
                                                     NSString *headStr = obj[@"HEADIMG"];
                                                     
                                                     NSData *data = [Base64 decode:headStr];
                                                    UIImage *image = [UIImage imageWithData:data scale:1];
                                                     
                                                     image = [StaticTools circleImage:image withParam:0];
//                                                     self.headImgView.image = image;
                                                     [UserDefaults setObject:UIImagePNGRepresentation(image) forKey:kUserHeadImage];
                                                     [UserDefaults synchronize];
                                                     
                                                     [self.headBtn setBackgroundImage:image forState:UIControlStateNormal];
                                                     
                                                 }
                                                 else //头像下载失败 不做任何提示
                                                 {
//                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"头像下载失败，请稍后再试!"];
                                             
                                         }];
    
    
    
    NSDictionary *bgdict = @{kTranceCode:@"200006",
                           kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                                        @"operationId":@"getStreetImg"}};
    
    AFHTTPRequestOperation *bgoperation = [[Transfer sharedTransfer] TransferWithRequestDic:bgdict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"000000"])
                                                 {
                                                     NSString *headStr = obj[@"HEADIMG"];
                                                     
                                                     NSData *data = [Base64 decode:headStr];
                                                     UIImage *image = [UIImage imageWithData:data scale:1];

                                                     [self.bgBtn setBackgroundImage:image forState:UIControlStateNormal];
                                                     
                                                 }
                                                 else //背景大图下载失败 不做任何提示
                                                 {
                                                     //                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"下载失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, bgoperation,nil] prompt:nil completeBlock:^(NSArray *operations) {
    }];

}

/**
 *  获取商户信息
 */
- (void)getMerchantInfo
{
    NSDictionary *infodict = @{kTranceCode:@"199011",
                               kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME]}};
    
    AFHTTPRequestOperation *infoOperation = [[Transfer sharedTransfer] TransferWithRequestDic:infodict
                                                                                       prompt:nil
                                                                                      success:^(id obj)
                                             {
                                                  [self downLoadHeadImg];
                                                 
                                                 if ([obj isKindOfClass:[NSDictionary class]])
                                                 {
                                                     
                                                     if ([obj[@"RSPCOD"] isEqualToString:@"000000"])
                                                     {
                                                         self.infoDict = [NSDictionary dictionaryWithDictionary:obj];
                                                         
                                                         self.nameLabel.text = self.infoDict[@"MERNAM"];
                                                         [self.listTableView reloadData];
                                                         
                                                     }
                                                     else
                                                     {
                                                         [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                     }
                                                     
                                                 }
                                                 
                                             }
                                                                                      failure:^(NSString *errMsg)
                                             {
                                                  [self downLoadHeadImg];
                                                 [SVProgressHUD showErrorWithStatus:@"商户信息查询失败!"];
                                                 
                                             }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:infoOperation, nil] prompt:nil completeBlock:^(NSArray *operations) {
    }];

}

/**
 *  背景大图上传
 *
 *  @param image
 */
- (void)upLoadBigBackImage:(UIImage*)image
{
    NSDictionary *dict = @{kTranceCode:@"200005",
                           kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                                        @"HEADIMG":[Base64 encode:UIImagePNGRepresentation(image)],
                                        @"operationId":@"setStreetImg"}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"000000"])
                                                 {
                                                     [self.bgBtn setBackgroundImage:image forState:UIControlStateNormal];
                                                     [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                                     
                                                 }
                                                 else
                                                 {
                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"上传失败，请稍后再试!"];
                                             
                                         }];
    
    
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在上传..." completeBlock:^(NSArray *operations) {
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==Alert_Tag_Logout&&buttonIndex!=alertView.cancelButtonIndex)
    {
        UINavigationController *rootNav = (UINavigationController*)ApplicationDelegate.window.rootViewController;
        [rootNav popToRootViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] removeObserver:ApplicationDelegate];
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
        return 5;
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
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.section==0&&indexPath.row==1)
    {
      
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"入账信息";
        [cell.contentView addSubview:titleLabel];
        titleLabel.textColor = [UIColor darkGrayColor];
        
        UILabel *cardNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 300, 20)];
        cardNumLabel.backgroundColor = [UIColor clearColor];
        cardNumLabel.font = [UIFont systemFontOfSize:15];
        
        if ([StaticTools isEmptyString:self.infoDict[@"ACTNO"]])
        {
            cardNumLabel.text = @"银行卡号：";

        }
        else
        {
            cardNumLabel.text = [NSString stringWithFormat:@"银行卡号：%@",[StaticTools insertComaInCardNumber:self.infoDict[@"ACTNO"]]];
        }
     
        [cell.contentView addSubview:cardNumLabel];
        cardNumLabel.textColor = [UIColor lightGrayColor];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, 300, 20)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.text = [NSString stringWithFormat:@"开户名：   %@",[self getText:self.infoDict[@"ACTNAM"]]];
        [cell.contentView addSubview:nameLabel];
        nameLabel.textColor = [UIColor lightGrayColor];
        
        UILabel *bankLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 300, 20)];
        bankLabel.backgroundColor = [UIColor clearColor];
        bankLabel.font = [UIFont systemFontOfSize:15];
        
        bankLabel.text = [NSString stringWithFormat:@"开户银行：%@",[self getText:self.infoDict[@"OPNBNK"]]];
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
            float angel = 0;
            if (state==0) {
                
                angel = 0;
            }
            else
            {
                angel = M_PI;
            }
            stateImgView.transform = CGAffineTransformMakeRotation(angel);
         
           
            [cell.contentView addSubview:stateImgView];
        
        }
       else  if (indexPath.section==1)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (indexPath.row==0)
            {
                titleLabel.text = @"账户提现";
                headImgView.image = [UIImage imageNamed:@"ip-xgmm"];
            }
            else if(indexPath.row==1)
            {
                titleLabel.text = @"实名认证";
                headImgView.image = [UIImage imageNamed:@"ip-xgmm"];
            }
            if (indexPath.row==2)
            {
                titleLabel.text = @"修改密码";
                headImgView.image = [UIImage imageNamed:@"ip-xgmm"];
            }
            else if (indexPath.row==3)
            {
                titleLabel.text = @"更多设置";
                headImgView.image = [UIImage imageNamed:@"ip-gdsz"];
            }
            else if (indexPath.row==4)
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
    }
    else if(indexPath.section==0&&indexPath.row==1) //没有获取到商户信息时 点击该行  重新获取
    {
        if (self.infoDict==nil)
        {
            [self getMerchantInfo];
        }
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0) //提现
        {
            MyAccountViewController *myAccountController = [[MyAccountViewController alloc]init];
            myAccountController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myAccountController animated:YES];
        }
        else if (indexPath.row==1) //实名认证
        {
            BasicInfoViewController *basicInfoController = [[BasicInfoViewController alloc]init];
            basicInfoController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:basicInfoController animated:YES];
        }
        else if (indexPath.row==2) //修改密码
        {
            ChangePasswordViewController *changePswController = [[ChangePasswordViewController alloc]init];
            changePswController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:changePswController animated:YES];
            changePswController.hidesBottomBarWhenPushed = YES;

        }
        else if(indexPath.row==3) //更多设置
        {
            SettingMainViewController *settingMainController = [[SettingMainViewController alloc]init];
            settingMainController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingMainController animated:YES];
        }
        else if(indexPath.row==4) //联系客服
        {
         
            UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"客服热线" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拨打--4006269987", nil];
            sheet.tag = Action_Tag_Phone;
            [sheet showInView:self.view.window];
            
        }
    }
}

@end
