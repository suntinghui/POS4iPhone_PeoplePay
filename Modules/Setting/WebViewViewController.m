//
//  WebViewViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-20.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()

@end

@implementation WebViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *  加载本地bundle里的文件
 *
 *  @param name
 *  @param type
 *
 *  @return
 */
- (id)initWithBundleFileName:(NSString*)name type:(NSString*)type title:(NSString*)title
{
    self = [super init];
    if (self)
    {
        
        self.bundleFileName = name;
        self.bundleFileType = type;
        if (title!=nil)
        {
            self.title = title;
        }
    }
    
    return self;
}

/**
 *  加载weburl
 *
 *  @param url
 *
 *  @return
 */
- (id)initWithWebUrl:(NSString*)url title:(NSString*)title;
{
    self = [super init];
    if (self)
    {
        
        self.webUrl = url;
        if (title!=nil)
        {
            self.title = title;
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.title!=nil)
    {
        self.navigationItem.title = self.title;
    }
    
    if (self.bundleFileName!=nil)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.bundleFileName ofType:self.bundleFileType];
        
        NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self.mainWebView loadHTMLString:contents baseURL:nil];
    }
    else if(self.webUrl!=nil)
    {
        NSLog(@"laod url :%@",self.webUrl);
        [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    }
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
