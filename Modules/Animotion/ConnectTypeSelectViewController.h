//
//  ConnectTypeSelectViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-20.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface ConnectTypeSelectViewController : BaseViewController<GKPeerPickerControllerDelegate,
    GKSessionDelegate>

@property (nonatomic, strong) GKSession *currentSession;
@property (nonatomic, strong) GKPeerPickerController *picker;

- (IBAction)buttonClickHandle:(id)sender;

@end
