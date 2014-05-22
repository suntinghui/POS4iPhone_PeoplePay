//
//  TradeListViewController.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-10.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "TradeListViewController.h"
#import "TradeCell.h"
#import "TradeDetailViewController.h"
#import "StringUtil.h"

NSString *const MJTableViewCellIdentifier = @"Cell";

@interface TradeListViewController ()

@end

@implementation TradeListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"交易明细列表";
    
    [StaticTools setExtraCellLineHidden:self.listTableView];
    self.listTableView.separatorColor = [UIColor clearColor];
    [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    [self addHeader];
    
    [headerView beginRefreshing];
    [self getTradeList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDataCenter sharedAppDataCenter].leveyTabBar hidesTabBar:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[AppDataCenter sharedAppDataCenter].leveyTabBar hidesTabBar:YES animated:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -功能函数
- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.listTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        
        [self getTradeList];
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    headerView = header;
}

#pragma mark -http请求
/**
 *  获取交易列表
 */
- (void)getTradeList
{
    NSDictionary *dict = @{kTranceCode:@"199008",
                           kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME]}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             [headerView endRefreshing];
                                             NSArray *arr = (NSArray*)obj;
                                             self.trades = [[NSMutableArray alloc]init];
                                             for (int i=arr.count-1;i>=0;i--)
                                             {
                                                 [self.trades addObject:arr[i]];
                                             }
                                             self.numLabel.text = [NSString stringWithFormat:@"%d",self.trades.count];
                                             self.numLabel.frame = CGRectMake(self.numLabel.frame.origin.x, self.numLabel.frame.origin.y, [StaticTools getLabelWidth:self.numLabel.text defautWidth:320 defautHeight:self.numLabel.frame.size.height fontSize:self.numLabel.font.pointSize], self.numLabel.frame.size.height);
                                             self.txtLabel.frame = CGRectMake(self.numLabel.frame.origin.x+self.numLabel.frame.size.width+3, self.txtLabel.frame.origin.y, self.txtLabel.frame.size.width, self.txtLabel.frame.size.height);
                                             [self.listTableView reloadData];
                                             
                                             float count = 0;
                                             for (NSDictionary *dict in obj)
                                             {
                                                 count+=[[StringUtil string2AmountFloat:dict[@"TXNAMT"]] floatValue];
                                             }
                                             
                                             self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",count];
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"加载失败，请稍后再试!"];
                                             
                                            [headerView endRefreshing];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:nil completeBlock:^(NSArray *operations) {
    }];
}

#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trades.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    TradeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TradeCell" owner:nil options:nil]objectAtIndex:0];
    }
    NSDictionary *dict = self.trades[indexPath.row];
    cell.dateLabel.text = [StaticTools insertCharactorWithDateStr:dict[@"LOGDAT"] andSeper:kSeperTypeRail];
    cell.cardLabel.text = [StaticTools insertComaInCardNumber:dict[@"CRDNO"]];
    cell.stateLabel.text = [StaticTools getTradeMessWithCode:dict[@"TXNCD"] state:dict[@"TXNSTS"]];
    cell.monyeLabel.text = [StringUtil string2SymbolAmount:dict[@"TXNAMT"]];
    cell.weakLabel.text = [StaticTools getWeakWithDate:[StaticTools getDateFromDateStr:cell.dateLabel.text]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.trades[indexPath.row];
    TradeDetailViewController *tradeDetailCotnroller = [[TradeDetailViewController alloc]init];
    tradeDetailCotnroller.infoDict = dict;
    [self.navigationController pushViewController:tradeDetailCotnroller animated:YES];
}

@end
