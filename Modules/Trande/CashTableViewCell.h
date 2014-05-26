//
//  CashTableViewCell.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-23.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weakLabel;
@property (weak, nonatomic) IBOutlet UILabel *monyeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
