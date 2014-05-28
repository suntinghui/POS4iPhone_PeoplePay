//
//  MJRefreshTableFooterView.h
//  MJRefresh
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  上拉加载更多

#import "MJRefreshBaseView.h"

@interface MJRefreshFooterView : MJRefreshBaseView
{
    BOOL footFreshSwith;  //上拉刷新开关
}

+ (instancetype)footer;


- (void)hideFreshView;

- (void)showFreshView;

@end