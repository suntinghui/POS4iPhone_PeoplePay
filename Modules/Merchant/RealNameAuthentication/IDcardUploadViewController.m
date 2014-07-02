//
//  IDcardUploadViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-25.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "IDcardUploadViewController.h"
#import "Base64.h"

#define Button_Tag_ImageOne    100        //正面照图片按钮
#define Button_Tag_ImageTwo    101        //反面照图片按钮
#define Button_Tag_ImageThree  102        //银行卡图片按钮
#define Button_Tag_ImageFour   103        //手持照片按钮
#define Button_Tag_ImageCommit 104        //下一步按钮

#define kMyPicUrl              @"MYPIC"   //手持身份证照片上传后url
#define kIdPicOneUrl           @"IDPIC"//身份证正面照片上传后url
#define kIdPicTwoUrl           @"IDPIC2"//身份证反面照片上传后url
#define kCardPicUrl            @"CARDPIC" //银行卡照片上传后url

@interface IDcardUploadViewController ()

@end

@implementation IDcardUploadViewController

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
    self.navigationItem.title = @"图片上传";
    self.scrollView.contentSize = CGSizeMake(320, 480);
    
    resultDict = [[NSMutableDictionary alloc]init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{

    UIButton *button = (UIButton*)sender;
    switch (button.tag) {
        case Button_Tag_ImageOne:
        case Button_Tag_ImageTwo:
        case Button_Tag_ImageThree:
        case Button_Tag_ImageFour:
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            operateType = button.tag;
            [self presentModalViewController:imagePickerController animated:YES];
            
        }

            break;
        case Button_Tag_ImageCommit:
        {
            NSString *err = nil;
            if (resultDict[kIdPicOneUrl]==nil)
            {
                err = @"身份证正面照片未上传或上传失败，请重新操作！";
            }
            else  if (resultDict[kIdPicTwoUrl]==nil)
            {
                err = @"身份证反面照片未上传或上传失败，请重新操作！";
            }
            else  if (resultDict[kCardPicUrl]==nil)
            {
                err = @"银行卡照片未上传或上传失败，请重新操作！";
            }
            else  if (resultDict[kMyPicUrl]==nil)
            {
                err = @"手持身份证照片未上传或上传失败，请重新操作！";
            }
            if (![StaticTools isEmptyString:err])
            {
                [SVProgressHUD showErrorWithStatus:err];
                return;
            }
            
            [self realNameAutoentication];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @autoreleasepool
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = [StaticTools imageWithImage:image scaledToSize:CGSizeMake(620, 960)]; //TODO
        UIButton *button = (UIButton*)[self.view viewWithTag:operateType];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [picker dismissViewControllerAnimated:YES completion:^{}];
        
        [self uploadImageWithType:operateType image:image];
    }
  
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark -http请求

/**
 *  上传图片
 */
- (void)uploadImageWithType:(int)type image:(UIImage*)image
{
    NSString *fileType;
    if (type==Button_Tag_ImageOne)
    {
        fileType = @"IDPIC";
    }
    else if(type == Button_Tag_ImageTwo)
    {
        fileType = @"IDPIC2";
    }
    else if(type == Button_Tag_ImageThree)
    {
        fileType = @"CARDPIC";
    }
    else if(type == Button_Tag_ImageFour)
    {
        fileType = @"MYPIC";
    }
    
    NSDictionary *dict = @{kTranceCode:@"199021",
                           kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                                        @"FILETYPE":fileType,
                                        @"PHOTOS":[Base64 encode:UIImageJPEGRepresentation(image, 1)]}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                 {
  
                                                     [resultDict setObject:obj[@"FILENAME"] forKey:fileType];
                                                     
                                                 }
                                                 else
                                                 {
                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"图片上传失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在上传..." completeBlock:^(NSArray *operations) {
        
    }];
}

/**
 *  实名认证
 */
- (void)realNameAutoentication
{
    NSMutableDictionary *comDict = APPDataCenter.comDict;
    
    NSDictionary *dict = @{kTranceCode:@"199030",
                           kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                                        @"USERNAME":comDict[kUserName], //申请人姓名
                                        @"IDNUMBER":comDict[kUserIdCard],//身份证号码
                                        @"MERNAME":comDict[kMerchantName],//商户名称
                                        @"SCOBUS":comDict[kServiceType], //经营范围
                                        @"MERADDRESS":comDict[kServicePlace], //经营地址
                                        @"TERMID":comDict[kDeviceNumber], //设备序列号
                                        @"BANKUSERNAME":comDict[kCardName],//开户名
                                        @"BANKAREA":comDict[kCity][@"name"], //开户行所在城市
                                        @"BIGBANKCOD":comDict[kBank][@"code"], //开户行编号
                                        @"BIGBANKNAM":comDict[kBank][@"name"], //开户行名称
                                        @"BANKCOD":comDict[kBankPlace][@"code"], //开户支行编号
                                        @"BANKNAM":comDict[kBankPlace][@"name"], //开户支行编号
                                        @"BANKACCOUNT":comDict[kCardNumber], //开户账户
                                        @"MYPIC":resultDict[kMyPicUrl], //申请人照片
                                        @"IDPICURL":resultDict[kIdPicOneUrl], //身份证正面照片
                                        @"CARDPIC2":resultDict[kIdPicTwoUrl], //身份证反面照片
                                        @"CARDPIC":resultDict[kCardPicUrl], //银行卡照片
                                        }};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                 {
                                                     [SVProgressHUD showSuccessWithStatus:@"认证成功！"];
                                                     [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-4] animated:YES];
                                                    
                                                 }
                                                 else
                                                 {
                                                     [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                                 }
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在加载..." completeBlock:^(NSArray *operations) {
        
    }];

}
@end
