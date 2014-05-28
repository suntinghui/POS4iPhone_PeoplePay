//
//  CashTableViewCell.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-23.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "CashTableViewCell.h"

@implementation CashTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
    self.bgView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
