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
#import "CashTableViewCell.h"

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
    
    
    ScrollSelectView *scrollSelectView  = [[ScrollSelectView alloc]initWithFrame:CGRectMake(0, 0, 320, 40) titles:@[@"交易流水",@"现金流水"]];
    scrollSelectView.delegate = self;
    [self.view addSubview:scrollSelectView];
    
    [self addHeader];
    
    [self refreshList];
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
        
        if (operateType==0)
        {
            [self getTradeList];
        }
        else if(operateType==1)
        {
            
            [self getCashAccount];
        }
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

- (void)refreshList
{
    [headerView beginRefreshing];
    
    if (operateType==0)
    {
        [self getTradeList];
    }
    else if(operateType==1)
    {
     
        [self getCashAccount];
    }
    
}

/**
 *  设置顶部金额和交易笔数
 */
- (void)setTitleCount
{
    int count; //笔数
    float amount = 0; //金额
    if (operateType==0)
    {
        count = self.trades.count;
        
        for (NSDictionary *dict in self.trades)
        {
            amount+=[[StringUtil string2AmountFloat:dict[@"TXNAMT"]] floatValue];
        }
    }
    else if(operateType==1)
    {
        count = self.cashs.count;
        
        for (NSDictionary *dict in self.cashs)
        {
            amount+=[dict[@"TRANSAMT"] floatValue];
        }
    }
    
    self.numLabel.text = [NSString stringWithFormat:@"%d",count];
    
    self.numLabel.frame = CGRectMake(self.numLabel.frame.origin.x, self.numLabel.frame.origin.y, [StaticTools getLabelWidth:self.numLabel.text defautWidth:320 defautHeight:self.numLabel.frame.size.height fontSize:self.numLabel.font.pointSize], self.numLabel.frame.size.height);
    self.txtLabel.frame = CGRectMake(self.numLabel.frame.origin.x+self.numLabel.frame.size.width+3, self.txtLabel.frame.origin.y, self.txtLabel.frame.size.width, self.txtLabel.frame.size.height);
    
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",amount];
}

#pragma mark--SrollSelectViewDelegate
- (void)ScrollSelectDidCickWith:(int)num
{
    
//    [headerView endRefreshing];
    
    if (num==0) //交易流水
    {
        operateType = 0;
        
        if (self.trades==nil)
        {
            [self refreshList];
        }
    }
    else //现金流水
    {
        operateType = 1;
        if (self.cashs==nil)
        {
            [self refreshList];
        }
    }
    
    [self setTitleCount];
    [self.listTableView reloadData];
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
                                           
                                             [self setTitleCount];
                                             
                                             [self.listTableView reloadData];
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"加载失败，请稍后再试!"];
                                             
                                            [headerView endRefreshing];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:nil completeBlock:^(NSArray *operations) {
    }];
}



/**
 *  现金流水
 */
- (void)getCashAccount
{
    NSDictionary *dict = @{kTranceCode:@"200003",
                           kParamName:@{@"PHONENUMBER":[UserDefaults objectForKey:KUSERNAME],
                                        @"operationId":@"getTransaction"}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             [headerView endRefreshing];
                                             
                                             self.cashs = [NSMutableArray arrayWithArray:obj];
                                             NSLog(@"cahs %@",self.cashs);
                                             [self setTitleCount];
                                             
                                             [self.listTableView reloadData];
                                             
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
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
    if (operateType==0)
    {
        return self.trades.count;
    }
    return self.cashs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (operateType==0)
    {
        return 90;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (operateType==0)
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
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        return cell;
    }
    else if(operateType==1)
    {
        static NSString *Identifier = @"Identifier";
        CashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CashTableViewCell" owner:nil options:nil]objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dict = self.cashs[indexPath.row];
        cell.dateLabel.text = dict[@"TRANSDATE"];
        cell.weakLabel.text = [StaticTools getWeekdayWithStr:cell.dateLabel.text];
        cell.monyeLabel.text = [NSString stringWithFormat:@"￥%@",dict[@"TRANSAMT"]];
        
        return cell;
        
    }
   
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (operateType==0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSDictionary *dict = self.trades[indexPath.row];
        TradeDetailViewController *tradeDetailCotnroller = [[TradeDetailViewController alloc]init];
        tradeDetailCotnroller.infoDict = dict;
        tradeDetailCotnroller.fatherController = self;
        [self.navigationController pushViewController:tradeDetailCotnroller animated:YES];
    }

}

@end
