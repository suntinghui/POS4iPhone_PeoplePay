//
//  DateSelectViewController.m
//  LivingService
//
//  Created by wenbin on 13-10-25.
//  Copyright (c) 2013年 wenbin. All rights reserved.
//

#import "DateSelectViewController.h"

#define beginYear         1985 //起始年份 提供起始年份开始100年内的年份选择

#define Action_Tag_Cancel 100
#define Action_Tag_Ok     101

@interface DateSelectViewController ()
{
    NSMutableArray *yearMtbArray;   //保存年
    NSMutableArray *monthMtbArray;  //保存月
}
@end

@implementation DateSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        yearMtbArray = [[NSMutableArray alloc]init];
        for (int i=beginYear; i<beginYear+100; i++)
        {
            [yearMtbArray addObject:[NSNumber numberWithInt:i]];
        }
        
        monthMtbArray = [[NSMutableArray alloc]init];
        for (int i=1; i<13; i++)
        {
            [monthMtbArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    
    
    if(self.pageType == kDatePickerTypeFull)
    {
        self.pickerView.hidden = YES;
        
        if (self.indexDate!=nil) //设置默认选中项
        {
            [self.datePicker setDate:[StaticTools getDateFromDateStr:self.indexDate] animated:NO];
        }
    }
    else if(self.pageType == kDatePickerTypeNoDay)  //只有年、月时 分割取出年份和月份
    {
        self.datePicker.hidden = YES;
        
        if (self.indexDate !=nil)
        {
            NSArray *temArray = [self.indexDate componentsSeparatedByString:@"-"];
            if (temArray.count==2)
            {
                self.currentYear = [temArray[0] intValue];
                self.currentMonth = [temArray[1] intValue];
            }
        }
        
        if (self.currentYear>=beginYear&&self.currentMonth>=1&&self.currentYear<(beginYear+100)&&self.currentMonth<=12)
        {
            [self.pickerView selectRow:self.currentYear-beginYear inComponent:0 animated:NO];
            [self.pickerView selectRow:self.currentMonth-1 inComponent:1 animated:NO];
        }
        else
        {
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            [self.pickerView selectRow:0 inComponent:1 animated:NO];
            
            self.currentYear = [yearMtbArray[0] intValue];
            self.currentMonth = [monthMtbArray[0] intValue];
        }
        
        
    }
    else if(self.pageType == kDatePickerTypeOnlyYear)
    {
         self.datePicker.hidden = YES;
        if (self.indexDate !=Nil)
        {
            if ([self.indexDate intValue]>=beginYear&&[self.indexDate intValue]<beginYear+100)
            {
                self.currentYear = [self.indexDate intValue];
                [self.pickerView selectRow:self.currentYear-beginYear inComponent:0 animated:NO];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [self setDatePicker:nil];
    [self setPickerView:nil];
    [super viewDidUnload];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self dismissModalViewControllerAnimated:YES];
}
#pragma mark-
#pragma mark--按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Action_Tag_Cancel:
        {
            [self dismissModalViewControllerAnimated:YES];
        }
            break;
        case Action_Tag_Ok:
        {
            if(self.clickOkAction!=nil)
            {
                if (self.pageType == kDatePickerTypeFull)
                {
                    self.clickOkAction([StaticTools getDateStrWithDate:self.datePicker.date withCutStr:@"-" hasTime:NO]);
                }
                else if(self.pageType == kDatePickerTypeNoDay)
                {
                    if (self.currentMonth<10) //选择的月份小于10时 前面补个0
                    {
                        self.clickOkAction([NSString stringWithFormat:@"%d-0%d",self.currentYear,self.currentMonth]);
                    }
                    else
                    {
                        self.clickOkAction([NSString stringWithFormat:@"%d-%d",self.currentYear,self.currentMonth]);
                    }
                    
                }
                else if(self.pageType == kDatePickerTypeOnlyYear)
                {
                    self.clickOkAction([NSString stringWithFormat:@"%d",self.currentYear]);
                }
                
            }
            
            [self dismissModalViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark-
#pragma mark--UIPickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pageType == kDatePickerTypeNoDay)
    {
        return 2;
    }
    else if(self.pageType == kDatePickerTypeOnlyYear)
    {
        return 1;
    }
    
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pageType == kDatePickerTypeNoDay)
    {
        return component==0?yearMtbArray.count:monthMtbArray.count;
    }
    else if(self.pageType == kDatePickerTypeOnlyYear)
    {
        return yearMtbArray.count;
    }
    return 0;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.pageType == kDatePickerTypeNoDay)
    {
        return 150;
    }
    else if(self.pageType == kDatePickerTypeOnlyYear)
    {
        return 300;
    }
    return 300;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pageType == kDatePickerTypeNoDay)
    {
        if (component == 0)
        {
            return [NSString stringWithFormat:@"%@年",yearMtbArray[row]];
        }
        else if (component == 1)
        {
            return [NSString stringWithFormat:@"%@月",monthMtbArray[row]];
        }
    }
    else if(self.pageType == kDatePickerTypeOnlyYear)
    {
        return [NSString stringWithFormat:@"%@年",yearMtbArray[row]];
    }
    
  
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pageType == kDatePickerTypeNoDay)
    {
        if (component == 0)
        {
            self.currentYear = [yearMtbArray[row] intValue];
        }
        else if (component == 1)
        {
            self.currentMonth = [monthMtbArray[row] intValue];
        }
    }
    else if(self.pageType == kDatePickerTypeOnlyYear)
    {
         self.currentYear = [yearMtbArray[row] intValue];
    }
    
}

@end
