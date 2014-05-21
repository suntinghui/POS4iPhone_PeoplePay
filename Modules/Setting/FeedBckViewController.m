//
//  FeedBckViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-20.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "FeedBckViewController.h"


@interface FeedBckViewController ()

@end

@implementation FeedBckViewController

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
    
    self.navigationItem.title = @"意见反馈";
    
    self.messLabel.text = @"您还可以输入150个文字";
    self.inputTxtView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.inputTxtView.layer.borderWidth = 1;
    self.inputTxtView.layer.cornerRadius = 8;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    if ([StaticTools isEmptyString:self.inputTxtView.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入内容"];
        return;
    }
  
    
    [SVProgressHUD showWithStatus:@"正在发送..." maskType:SVProgressHUDMaskTypeClear];
    
    SKPSMTPMessage *sendMsg = [[SKPSMTPMessage alloc] init];
    sendMsg.fromEmail = @"jia_people@163.com";
    sendMsg.toEmail =@"tinghuisun@163.com";
    sendMsg.relayHost = @"smtp.163.com";
    sendMsg.requiresAuth = YES;
    sendMsg.login = @"jia_people@163.com";
    sendMsg.pass = @"jia_people_test";
    sendMsg.subject = @"peoplepay IOS feedback"; // 中文会乱码  意见反馈
    //testMsg.bccEmail = @"tinghuisun@163.com"; // 抄送
    sendMsg.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!
    
    // Only do this for self-signed certs!
    sendMsg.validateSSLChain = NO;
    sendMsg.delegate = self;
    
    NSString *content =   [NSString stringWithFormat:@"%@ %@", self.inputTxtView.text, [UserDefaults objectForKey:KUSERNAME]];
    /***
     NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
     content,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
     ***/
    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                               [NSString stringWithCString:[content UTF8String] encoding:NSUTF8StringEncoding],kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    
    sendMsg.parts = [NSArray arrayWithObjects:plainPart,nil];
    
    [sendMsg send];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark SKPSMTPMessage Delegate Methods
- (void)messageState:(SKPSMTPState)messageState;
{
    //    NSLog(@"HighestState:%d", HighestState);
    //    if (messageState > HighestState)
    //        HighestState = messageState;
    //
    //    ProgressBar.progress = (float)HighestState/(float)kSKPSMTPWaitingSendSuccess;
}
- (void)messageSent:(SKPSMTPMessage *)SMTPmessage
{
    [SVProgressHUD dismiss];
    
    [SVProgressHUD showSuccessWithStatus:@"提交成功"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)messageFailed:(SKPSMTPMessage *)SMTPmessage error:(NSError *)error
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"提交失败，请稍后再试"];
    NSLog(@"email faild: %@",[error localizedDescription]);

}
#pragma mark -UItextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSMutableString *str = [[NSMutableString alloc]initWithString:textView.text];
    [str replaceCharactersInRange:range withString:text];
    if (str.length>150)
    {
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    self.messLabel.text = [NSString stringWithFormat:@"您还可以输入%d个文字",150-textView.text.length];
}
@end
