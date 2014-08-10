//
//  WebViewViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-20.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (strong, nonatomic) NSString *bundleFileName;
@property (strong, nonatomic) NSString *bundleFileType;
@property (strong, nonatomic) NSString *webUrl;
@property (strong, nonatomic) NSString *title;

//加载weburl
- (id)initWithWebUrl:(NSString*)url title:(NSString*)title;

//加载bundle里的文件
- (id)initWithBundleFileName:(NSString*)name type:(NSString*)type title:(NSString*)title;

@end
