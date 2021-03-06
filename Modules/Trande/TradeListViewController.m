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

#define Alert_Tag_Delete 100

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
    self.navigationItem.title = @"流水列表";
    
     self.cashs = [[NSMutableArray alloc]init];
  
    [StaticTools setExtraCellLineHidden:self.listTableView];
    self.listTableView.separatorColor = [UIColor clearColor];
    
    [self.moneyLabel setAdjustsFontSizeToFitWidth:YES];
    self.timeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.timeBtn.layer.borderWidth = 0.5;
    self.timeBtn.layer.cornerRadius = 5;
    if (operateType==1)
    {
    }
    else
    {
        self.timeBtn.hidden = YES;
        self.arrowImage.hidden = YES;
    }
    
    
//    [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    
    
    ScrollSelectView *scrollSelectView  = [[ScrollSelectView alloc]initWithFrame:CGRectMake(0, 0, 320, 40) titles:@[@"交易流水",@"现金流水"]];
    scrollSelectView.delegate = self;
    [self.view addSubview:scrollSelectView];
    
    [self addHeader];
    
    [self addFooter];
    
    [self refreshList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    footView.scrollView = self.listTableView;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
        
        isFresh = YES;
        
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

- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {

        if (currentPage==totalPage)
        {
            [SVProgressHUD showErrorWithStatus:@"无更多信息"];
            [footView endRefreshing];
            return ;
        }
        
        [self getCashAccount];
        
    };
    
    footView.scrollView = self.listTableView;
    footView = footer;
    [footView hideFreshView];
}


- (void)refreshList
{
    [headerView beginRefreshing];
    
}

/**
 *  把2013-01变成2013年01月
 *
 *  @param dateStr
 *
 *  @return
 */
- (NSString*)insertWordInDate:(NSString*)dateStr
{
    dateStr  = [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    return [NSString stringWithFormat:@"%@月",dateStr];
}

/**
 *  把2013年01月变成2013-01
 *
 *  @param dateStr
 *
 *  @return 
 */
- (NSString*)changeWordToCharect:(NSString*)dateStr
{
    dateStr  = [dateStr stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    dateStr  = [dateStr stringByReplacingOccurrencesOfString:@"月" withString:@""];
    return dateStr;
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
        count = [self.totalCount integerValue]; //self.cashs.count;
        amount = [self.totalMoney floatValue];
    }
    
    self.numLabel.text = [NSString stringWithFormat:@"%d",count];
    
    float with =[StaticTools getLabelWidth:self.numLabel.text defautWidth:320 defautHeight:self.numLabel.frame.size.height fontSize:22];
    if (with>50) //防止笔数字数较多时和月份重叠
    {
        with=50;
        [self.numLabel setAdjustsFontSizeToFitWidth:YES];
    }
    self.numLabel.frame = CGRectMake(self.numLabel.frame.origin.x, self.numLabel.frame.origin.y, with+2, self.numLabel.frame.size.height);
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
        self.timeBtn.hidden = YES;
        self.arrowImage.hidden = YES;
        if (self.trades==nil)
        {
            [self refreshList];
        }
        
//        footView.scrollView = nil;
        
        [footView hideFreshView];

    }
    else //现金流水
    {
        operateType = 1;
        self.timeBtn.hidden = NO;
        self.arrowImage.hidden = NO;
        if ([StaticTools isEmptyString:self.timeBtn.titleLabel.text] )
        {
            
            NSString *date = [StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:YES];
            date = [date substringToIndex:7];
            [self.timeBtn setTitle:[self insertWordInDate:date] forState:UIControlStateNormal];
        }
        
        if (self.cashs.count==0)
        {
            [self refreshList];
        }
        
//        footView.scrollView = self.listTableView;
        
        [footView showFreshView];
        
    }
    
    [self setTitleCount];
    [self.listTableView reloadData];
}
#pragma mark - 按钮点击
- (void)buttonClickHandle:(UIButton*)button
{
    if (button.tag==99)
    {
        [StaticTools showDateSelectInViewController:ApplicationDelegate.window.rootViewController indexDate:[self changeWordToCharect:self.timeBtn.titleLabel.text] type:kDatePickerTypeNoDay clickOk:^(NSString *selectDateStr) {
            
            [self.timeBtn setTitle:[self insertWordInDate:selectDateStr] forState:UIControlStateNormal];
            
            isFresh = YES;
            [self refreshList];
        }];
    }
    else
    {
        [StaticTools showAlertWithTag:Alert_Tag_Delete
                                title:nil
                              message:@"您确定要删除该条记录吗？"
                            AlertType:CAlertTypeCacel
                            SuperView:self];
        
        deleteIndex = button.tag-100;
    }
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == Alert_Tag_Delete&&buttonIndex!=alertView.cancelButtonIndex)
    {
     
        [self deleCash];
    }
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
                                        @"operationId":@"getTransaction",
                                        @"pageIndex":[NSString stringWithFormat:@"%d",isFresh?0:currentPage],
                                        @"dateStr":[self changeWordToCharect:self.timeBtn.titleLabel.text],
                                        @"pageSize":kOnePageSize}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             [headerView endRefreshing];
                                             [footView endRefreshing];
                                             
                                             if ([obj[@"RSPCOD"] isEqualToString:@"000000"])
                                             {
                                                
                                                 totalPage = [obj[@"TOTALPAGE"] intValue];
                                                 self.totalMoney =obj[@"TOTALTRANSAMT"];
                                                 self.totalCount =obj[@"TOTALROWNUMS"];
                                                 
                                                if (isFresh)
                                                 {
                                                     currentPage=0;
                                                     [self.cashs removeAllObjects];
                                                    
                                                 }
                                                 
                                                  currentPage++;
                                                 
                                                 [self.cashs addObjectsFromArray:obj[@"LIST"]];
                                                 
                                                 [self setTitleCount];
                                                 
                                                 [self.listTableView reloadData];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                             }
                                             
                                              isFresh = NO;
                                             
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
                                             [headerView endRefreshing];
                                             [footView endRefreshing];
                                             
                                             if (isFresh)
                                             {
                                                 currentPage=0;
                                                 [self.cashs removeAllObjects];
                                                 [self.listTableView reloadData];
                                                 
                                             }
                                              isFresh = NO;
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:nil completeBlock:^(NSArray *operations) {
    }];
}

/**
 *  现金流水删除
 */
- (void)deleCash
{
    NSString *idStr = self.cashs[deleteIndex][@"TRANSID"];
    NSDictionary *dict = @{kTranceCode:@"200004",
                           kParamName:@{@"operationId":@"delTransaInfo",
                                        @"transId":idStr}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj[@"RSPCOD"] isEqualToString:@"000000"])
                                             {
                                                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                                                 [self.cashs removeObjectAtIndex:deleteIndex];
                                                 
                                                 [self setTitleCount];
                                                 [self.listTableView reloadData];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:obj[@"RSPMSG"]];
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
                                             
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
        
        cell.deleteBtn.tag = 100+indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
   
    return nil;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (operateType==0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSDictionary *dict = self.trades[indexPath.row];
        TradeDetailViewController *tradeDetailCotnroller = [[TradeDetailViewController alloc]init];
        tradeDetailCotnroller.hidesBottomBarWhenPushed = YES;
        tradeDetailCotnroller.infoDict = dict;
        tradeDetailCotnroller.fatherController = self;
        [self.navigationController pushViewController:tradeDetailCotnroller animated:YES];
    }

}

@end
