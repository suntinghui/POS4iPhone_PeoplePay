//
//  IDcardUploadViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-6-25.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "IDcardUploadViewController.h"
#import "Base64.h"

#define Button_Tag_ImageOne  100
#define Button_Tag_ImageTwo  101
#define Button_Tag_ImageThree  102
#define Button_Tag_ImageFour  103
#define Button_Tag_ImageCommit  104

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
        image = [StaticTools imageWithImage:image scaledToSize:CGSizeMake(32, 48)]; //TODO
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
                                        @"PHOTOS":[Base64 encode:UIImagePNGRepresentation(image)]}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 if ([obj[@"RSPCOD"] isEqualToString:@"00"])
                                                 {
  
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


@end
