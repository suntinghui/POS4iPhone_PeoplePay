//
//  InputMoneyViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-29.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "InputMoneyViewController.h"

#define Button_Tag_Zearo 100  //0
#define Button_Tag_One   101  //1
#define Button_Tag_Two   102  //2
#define Button_Tag_Three 103  //3
#define Button_Tag_Four  104  //4
#define Button_Tag_Five  105  //5
#define Button_Tag_Six   106  //6
#define Button_Tag_Seven 107  //7
#define Button_Tag_Eight 108  //8
#define Button_Tag_Nine  109  //9

#define Button_Tag_Plus  110  //加
#define Button_Tag_Minus 111  //减
#define Button_Tag_Multiply 112 //乘
#define Button_Tag_Division 113 //除
#define Button_Tag_Delete   114 //删除
#define Button_Tag_SwipeCard 115 //点击刷卡
#define Button_Tag_KeepAccount 116 //现金记账
#define Button_Tag_Point       117 //点


@interface InputMoneyViewController ()

@end

@implementation InputMoneyViewController

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
    self.navigationItem.hidesBackButton = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"刷卡";
    self.inputTxtField.text = @"0";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Button_Tag_One: //数字输入
        case Button_Tag_Two:
        case Button_Tag_Three:
        case Button_Tag_Four:
        case Button_Tag_Five:
        case Button_Tag_Six:
        case Button_Tag_Seven:
        case Button_Tag_Eight:
        case Button_Tag_Nine:
        case Button_Tag_Zearo:
        {
            if ([self.inputTxtField.text isEqualToString:@"0"])
            {
                self.inputTxtField.text = @"";
            }
            else if([self.inputTxtField.text rangeOfString:@"."].location!=NSNotFound)
            {
                NSString *end = [self.inputTxtField.text componentsSeparatedByString:@"."][1];
                if (end.length>=2)
                {
                    return;
                }
                
                if (self.inputTxtField.text.length>=15)
                {
                    return;
                }
            }
            else if([self.inputTxtField.text rangeOfString:@"."].location==NSNotFound)
            {
                if (self.inputTxtField.text.length>=12)
                {
                    return;
                }
            }
            
            self.inputTxtField.text = [NSString stringWithFormat:@"%@%d",self.inputTxtField.text, button.tag-100];
        }
            break;
        case Button_Tag_Point://小数点
        {
            if(![self.inputTxtField.text isEqualToString:@""] && ![self.inputTxtField.text isEqualToString:@"-"])
            {
                NSString *currentStr = self.inputTxtField.text;
                BOOL notDot = ([self.inputTxtField.text rangeOfString:@"."].location == NSNotFound);
                if (notDot)
                {
                    currentStr= [currentStr stringByAppendingString:@"."];
                    self.inputTxtField.text= currentStr;
                }
            }
        }
            break;
        case Button_Tag_Delete: //删除
        {
            if ([self.inputTxtField.text isEqualToString:@"0"])
            {
                return;
            }
            if (self.inputTxtField.text.length>0)
            {
                NSString *current = [NSString stringWithString:self.inputTxtField.text];
                self.inputTxtField.text = [current substringToIndex:current.length-1];
            }
            
            if (self.inputTxtField.text.length==0)
            {
                self.inputTxtField.text = @"0";
            }
         
        }
        case Button_Tag_SwipeCard: //刷卡
        {
            
        }
            break;
        case Button_Tag_KeepAccount: //现金记账
        {
            [SVProgressHUD showSuccessWithStatus:@"记账成功"];
            
        }
            break;
            
        default:
            break;
    }
}

@end
