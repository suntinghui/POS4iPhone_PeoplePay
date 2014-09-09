//
//  CaculateViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-23.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "CaculateViewController.h"
#import "InputMoneyViewController.h"


#define Tag_Zero_Action    100  // 0
#define Tag_One_Action     101  // 1
#define Tag_Two_Action     102  // 2
#define Tag_Three_Action   103  // 3
#define Tag_Four_Action    104  // 4
#define Tag_Five_Action    105  // 5
#define Tag_Six_Action     106  // 6
#define Tag_Seven_Action   107  // 7
#define Tag_Eight_Action   108  // 8
#define Tag_Nine_Action    109  // 9
#define Tag_Point_Action   110  // .
#define Tag_Clear_Action   111  // C
#define Tag_BackWord_Action    112  // del
#define Tag_Divide_Action  113  // /
#define Tag_Multiply_Action 114 // *
#define Tag_Reduce_Action  115  // -
#define Tag_Plus_Action   116  // +
#define Tag_Result_Action 117 // =
#define Tag_Back_Action   118 //返回
#define Tag_Commit_Actin  119 //完成

@interface CaculateViewController ()

@end

@implementation CaculateViewController

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
    self.view.backgroundColor = [UIColor clearColor];
    
    if (IsIPhone5)
    {
        self.showFoperator.frame = CGRectMake(self.showFoperator.frame.origin.x, self.showFoperator.frame.origin.y+20, self.showFoperator.frame.size.width, self.showFoperator.frame.size.height);
        self.resultTxtField.frame = CGRectMake(self.resultTxtField.frame.origin.x, self.resultTxtField.frame.origin.y+20, self.resultTxtField.frame.size.width, self.resultTxtField.frame.size.height);
        self.inputBgView.frame = CGRectMake(self.inputBgView.frame.origin.x, self.inputBgView.frame.origin.y+20, self.inputBgView.frame.size.width, self.inputBgView.frame.size.height);
    }
    [self clearDisplay];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -按钮点击
- (IBAction)buttonClickHandle:(UIButton*)button
{
    switch (button.tag)
    {
        case Tag_Clear_Action:  //清空
        {
            [self clearDisplay];
        }
            break;
        case Tag_Point_Action: // "."操作
        {
            [self addDot];
        }
            break;
        case Tag_BackWord_Action: // 删除操作
        {
            [self backSpace];
        }
            break;
        case Tag_Plus_Action:      // +
        case Tag_Reduce_Action:    // -
        case Tag_Multiply_Action:  // *
        case Tag_Divide_Action:    // /
        case Tag_Result_Action:    // =
        {
            [self inputDoubleOperator:button.titleLabel.text];
        }
            break;
        case Tag_Zero_Action:  //数字输入
        case Tag_One_Action:
        case Tag_Two_Action:
        case Tag_Three_Action:
        case Tag_Four_Action:
        case Tag_Five_Action:
        case Tag_Six_Action:
        case Tag_Seven_Action:
        case Tag_Eight_Action:
        case Tag_Nine_Action:
        {
            [self inputNumber:button.titleLabel.text];
        }
            break;
        case Tag_Back_Action: //返回
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case Tag_Commit_Actin: //完成
        {
            if ([self.resultTxtField.text isEqualToString:@"err"])
            {
                return;
            }
            
            if ([self.fatherController isKindOfClass:[InputMoneyViewController class]])
            {
                InputMoneyViewController *inputController = (InputMoneyViewController*)self.fatherController;
                inputController.inputTxtField.text = self.resultTxtField.text;
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}



/**
 *	@brief	清空操作
 */
- (void)clearDisplay
{
	self.resultTxtField.text = @"0";
	self.showFoperator.text = @"C";
	operater = @"=";
	fstOperand = 0;
	sumOperand = 0;
	bBegin = YES;
}

/**
 *	@brief	 “.” 操作
 */
- (void)addDot

{
	self.showFoperator.text = @".";
	
	if(![self.resultTxtField.text isEqualToString:@""] && ![self.resultTxtField.text isEqualToString:@"-"])
	{
		NSString *currentStr = self.resultTxtField.text;
		BOOL notDot = ([self.resultTxtField.text rangeOfString:@"."].location == NSNotFound);
		if (notDot)
		{
			currentStr= [currentStr stringByAppendingString:@"."];
			self.resultTxtField.text= currentStr;
		}
	}
}


/**
 *	@brief	取正或取负操作
 */
- (void)addSign
{
	self.showFoperator.text = @"+/-";
	
	if(![self.resultTxtField.text isEqualToString:@""] && ![self.resultTxtField.text isEqualToString:@"0"] && ![self.resultTxtField.text isEqualToString:@"-"])
	{
		double number = [self.resultTxtField.text doubleValue];
		number = number*(-1);
		self.resultTxtField.text= [NSString stringWithFormat:@"%g",number];
		
		if(bBegin)
		{
			sumOperand = number;
		}
	}
}

/**
 *	@brief	删除操作
 */
- (void)backSpace

{
	self.showFoperator.text = @"←";
	
	if (backOpen)
	{
		if (self.resultTxtField.text.length == 1)
		{
			self.resultTxtField.text = @"0";
		}
		else if (![self.resultTxtField.text isEqualToString:@""])
		{
			self.resultTxtField.text = [self.resultTxtField.text substringToIndex:self.resultTxtField.text.length -1];
		}
        
	}
}

/**
 *	@brief	+ - * / = 操作
 */
- (void)inputDoubleOperator: (NSString *)dbopt

{
	self.showFoperator.text = dbopt;
	backOpen = NO;
	
	if(![self.resultTxtField.text isEqualToString:@""])
	{
		fstOperand = [self.resultTxtField.text doubleValue];
        BOOL canShowNum = NO;
		
		if(bBegin)
		{
			operater = dbopt;
		}
		else
		{
			if([operater isEqualToString:@"="])
			{
				sumOperand = fstOperand;
                canShowNum = YES;
			}
			else if([operater isEqualToString:@"+"])
			{
				sumOperand += fstOperand;
                canShowNum = YES;
            }
			else if([operater isEqualToString:@"-"])
			{
				sumOperand -= fstOperand;
                canShowNum = YES;
			}
			else if([operater isEqualToString:@"×"])
			{
				sumOperand *= fstOperand;
                canShowNum = YES;
			}
			else if([operater isEqualToString:@"÷"])
			{
				if(fstOperand!= 0)
				{
					sumOperand /= fstOperand;
                    canShowNum = YES;
				}
				else
				{
					self.resultTxtField.text = @"err";
					operater= @"=";
				}
			}
			
            if (canShowNum)
            {
                NSString *num = [NSString stringWithFormat:@"%f",sumOperand];
                if (num.length>25) //长度大于25时使用科学计数法显示 此位数根据数据大小和字体来确定
                {
                    self.resultTxtField.text = [NSString stringWithFormat:@"%g",sumOperand];
                }
                else
                {
                    //小数点后为全0时  去掉0
                    NSString *Regex = @".*\\.0+";
                    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",Regex];
                    if([Test evaluateWithObject:[NSString stringWithFormat:@"%f",sumOperand]])
                    {
                        self.resultTxtField.text = [NSString stringWithFormat:@"%.0f",sumOperand];
                    }
                    else
                    {
                        self.resultTxtField.text = [NSString stringWithFormat:@"%f",sumOperand];
                    }
                    
                }
                
                // setprecision() cout,setf(ios::fixed)
            }
			
			bBegin= YES;
			operater= dbopt;
		}
	}
}

/**
 *	@brief	数字输入操作
 */
- (void)inputNumber: (NSString *)nbstr
{
	backOpen = YES;
    
    if(bBegin)
	{
		self.showFoperator.text = @"";
		self.resultTxtField.text = nbstr;
	}
	else
	{
        self.showFoperator.text = @"";
        
        if ([self.resultTxtField.text isEqualToString:@"0"])
        {
            self.resultTxtField.text = @"";
        }
        else if([self.resultTxtField.text rangeOfString:@"."].location!=NSNotFound)
        {
            NSString *end = [self.resultTxtField.text componentsSeparatedByString:@"."][1];
            if (end.length>=2)
            {
                return;
            }
            
            if (self.resultTxtField.text.length>=15)
            {
                return;
            }
        }
        else if([self.resultTxtField.text rangeOfString:@"."].location==NSNotFound)
        {
            if (self.resultTxtField.text.length>=12)
            {
                return;
            }
        }
        
		self.resultTxtField.text = [self.resultTxtField.text stringByAppendingString:nbstr];
	}
	bBegin = NO;
}
@end
