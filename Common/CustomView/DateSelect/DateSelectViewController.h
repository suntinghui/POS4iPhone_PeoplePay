//
//  DateSelectViewController.h
//  LivingService
//
//  Created by wenbin on 13-10-25.
//  Copyright (c) 2013年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件功能描述：根据pageType复用  0：包含年、月、日的选择  1：只包含年、月的选择  公用 
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

typedef enum  //日期选择的类型
    {
    kDatePickerTypeFull ,     //包含年、月、日
    kDatePickerTypeNoDay ,    //只包含年、月
    kDatePickerTypeOnlyYear,   //只包含年
    kDatePickerTypeDateAndTime //包含年月日和时间
    }kDatePickerType;

typedef void(^DateSelectAction)(NSString*selectDateStr);

@interface DateSelectViewController : UIViewController<UIPickerViewDataSource,
    UIPickerViewDelegate>

@property (assign, nonatomic) kDatePickerType pageType;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView; //用来自定义年、月选择控件
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker; //日期选择控件
@property (strong, nonatomic) NSString *indexDate;  //页面显示时的默认选中日期
@property (assign, nonatomic) int currentYear;    //选择的年份
@property (assign, nonatomic) int currentMonth;   //选择的月份
//点击确定的回调 返回选择的日期 格式为“2012-12-12”或者“2012-12” 或者@“2012”
@property (copy, nonatomic) DateSelectAction clickOkAction;

- (IBAction)buttonClickHandle:(id)sender;

@end
