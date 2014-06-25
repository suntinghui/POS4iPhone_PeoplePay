//
//  SNSshareViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-22.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "SNSshareViewController.h"
#import "WeiBoShare.h"

@interface SNSshareViewController ()

@end

@implementation SNSshareViewController

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
    
    self.navigationItem.title = @"微博分享";
    
    self.countLabel.text = @"您还可以输入140个文字";
    self.inputTxtView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.inputTxtView.layer.borderWidth = 1;
    self.inputTxtView.layer.cornerRadius = 8;
    
    if (![[WeiBoShare sharedWeiBo] isSinaWeiBoIsSign])
    {
         [[WeiBoShare sharedWeiBo] sinaweiboLogIn];
    }
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    if ([StaticTools isEmptyString:self.inputTxtView.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入内容"];
        return;
    }
    
    [[WeiBoShare sharedWeiBo]sinaweiboSendWithTxt:self.inputTxtView.text Image:[UIImage imageNamed:@"ip_gyxtlogo"] success:^{
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark -UItextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSMutableString *str = [[NSMutableString alloc]initWithString:textView.text];
    [str replaceCharactersInRange:range withString:text];
    if (str.length>140)
    {
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    self.countLabel.text = [NSString stringWithFormat:@"您还可以输入%d个文字",140-textView.text.length];
}
@end
