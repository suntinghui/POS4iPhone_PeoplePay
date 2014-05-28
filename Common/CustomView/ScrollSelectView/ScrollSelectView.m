//
//  ScrollSelectView.m
//  Desea
//
//  Created by wenbin on 14-1-8.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "ScrollSelectView.h"
#import "StaticTools.h"
@implementation ScrollSelectView

/**
 *	@brief	唯一初始化函数
 *
 *	@param 	frame 	
 *	@param 	titles 	标题 数组属性
 *
 *	@return	
 */
- (id)initWithFrame:(CGRect)frame titles:(NSArray*)titles

{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        float buttonWith;
        if (titles.count<=4)
        {
            buttonWith = frame.size.width/titles.count;
        }
        else
        {
            buttonWith = frame.size.width/titles.count;
        }
        LineWith= buttonWith;
        
        backScrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //backScrView.backgroundColor =  RGBACOLOR(201, 234, 189, 1);
        backScrView.backgroundColor = RGBCOLOR(208, 217, 234);
        backScrView.scrollEnabled = NO;
        [self addSubview:backScrView];
        
        lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-4, LineWith, 3)];
        lineImgView.backgroundColor = RGBCOLOR(19, 110, 242);
       // lineImgView.image = [UIImage imageNamed:@"4"]; TODO
        [self addSubview:lineImgView];
        
        UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-2, frame.size.width, 2)];
        downLine.backgroundColor = RGBCOLOR(66, 116, 194);;
        [self addSubview:downLine];
        
        for (int i=0;i<titles.count;i++)
        {
            NSString *title = titles[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame  = CGRectMake(buttonWith*i, 0, buttonWith, frame.size.height);
            button.tag = 100+i;
            [button setTitle:title forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [backScrView addSubview:button];
            backScrView.contentSize = CGSizeMake(buttonWith*(i+1), frame.size.height);
        }
        
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)buttonClicked:(UIButton*)button
{
    //点击的是当前选择的按钮
    if (self.selectIndex == button.tag-100)
    {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        lineImgView.frame  = CGRectMake(button.frame.origin.x, self.frame.size.height-4, LineWith, 3);
    } completion:^(BOOL finished) {
        
       
        if ([self.delegate respondsToSelector:@selector(ScrollSelectDidCickWith:)])
        {
            [self.delegate ScrollSelectDidCickWith:button.tag-100];
        }
        
         self.selectIndex = button.tag-100;
        
    }];
}

@end
