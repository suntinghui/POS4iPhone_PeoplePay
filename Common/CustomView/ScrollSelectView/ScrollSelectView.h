//
//  ScrollSelectView.h
//  Desea
//
//  Created by wenbin on 14-1-8.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/

#import <UIKit/UIKit.h>

@protocol ScrollSelectDelegate <NSObject>

- (void)ScrollSelectDidCickWith:(int)num;

@end
@interface ScrollSelectView : UIView
{
    UIScrollView *backScrView;
    UIImageView *lineImgView;
    float LineWith; //底部提示图片的宽度
}
@property (retain, nonatomic) NSMutableArray *titleArray;
@property (assign, nonatomic) id<ScrollSelectDelegate>delegate;
@property (assign, nonatomic) int selectIndex; //选择的项

//初始化函数
- (id)initWithFrame:(CGRect)frame titles:(NSArray*)titles;

@end
