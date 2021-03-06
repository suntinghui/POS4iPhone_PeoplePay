//
//  Transfer+Parser.m
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-26.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "Transfer+Parser.h"
#import "TBXML.h"

@implementation Transfer (Parser)


- (id) ParseXMLWithReqCode:(NSString *) reqName
                 xmlString:(NSString *) xml
{
    NSError *error = nil;
    TBXML *tbXML = [[TBXML alloc] initWithXMLString:xml error:&error];
    if (error) {
        NSLog(@"%@->ParseXML[%@]:%@", [self class] , reqName, [error localizedDescription]);
        return nil;
    }
    
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if (rootElement) {
        if ([reqName isEqualToString:@"199002"]||[reqName isEqualToString:@"200008"]) //登录
        {
            return [self login:rootElement];
        }
        else if([reqName isEqualToString:@"199018"]) //获取短信验证码
        {
            return [self getCustomMess:rootElement];
        }
        else if([reqName isEqualToString:@"199008"]) //流水查询
        {
            return [self getRradeList:rootElement];
        }
        else if([reqName isEqualToString:@"199003"]||[reqName isEqualToString:@"200009"]) //修改密码
        {
            return [self getCustomMess:rootElement];
        }
        else if([reqName isEqualToString:@"200000"]||[reqName isEqualToString:@"200005"]) //头像上传
        {
            return [self getCustomMess:rootElement];
        }
        else if([reqName isEqualToString:@"200001"]||[reqName isEqualToString:@"200006"]) //头像下载
        {
            return [self getHeadImg:rootElement];
        }
        else if([reqName isEqualToString:@"199020"]) //签到
        {
            return [self doSign:rootElement];
        }
        else if([reqName isEqualToString:@"199053"]) //消费
        {
            return [self getTradeInfo:rootElement];
        }
        else if([reqName isEqualToString:@"199006"]) //消费撤销
        {
            return [self getCustomMess:rootElement];
        }
        else if([reqName isEqualToString:@"199022"]) //商户信息查询
        {
            return [self getMerchantInfo:rootElement];
        }
        else if([reqName isEqualToString:@"200002"]) //现金记账
        {
            return [self getCustomMess:rootElement];
        }
        else if([reqName isEqualToString:@"200003"]) //现金流水列表
        {
            return [self getCashList:rootElement];
        }
        else if([reqName isEqualToString:@"200004"]) //现金流水删除
        {
            return [self getCustomMess:rootElement];
        }
        else if([reqName isEqualToString:@"199004"]) //重置密码
        {
            return [self getCustomMess:rootElement];
        }
        else if([reqName isEqualToString:@"200007"]) //用户注册
        {
            return [self getCustomMess:rootElement];
        }
        else if([reqName isEqualToString:@"199031"]||//获取省份
                [reqName isEqualToString:@"199032"])//获取城市
        {
            return [self getProvinceList:rootElement];
        }
        else if([reqName isEqualToString:@"199035"]||//获取银行列表
                [reqName isEqualToString:@"199034"]) //获取支行列表
        {
            return [self getBankList:rootElement];
        }
        else if([reqName isEqualToString:@"199026"]) //获取我的账户信息
        {
            return [self getMyAccountInfo:rootElement];
        }
        else if([reqName isEqualToString:@"P77022"]) //实名认证
        {
            return [self realNameAuth:rootElement];
        }
        else if([reqName isEqualToString:@"199038"]) //获取扣率
        {
            return [self getRateInfo:rootElement];
        }
        else if([reqName isEqualToString:@"P77023"]) //获取用户实名认证数据
        {
            return [self getAutoInfo:rootElement];
        }
        else if([reqName isEqualToString:@"199037"]|| //获取交易小票
                [reqName isEqualToString:@"199010"]|| //上传签名图片
                [reqName isEqualToString:@"708103"]|| //手机充值
                [reqName isEqualToString:@"708102"]|| //信用卡还款
                [reqName isEqualToString:@"199025"]|| //账户提现
                [reqName isEqualToString:@"708101"]|| //卡卡转账
                [reqName isEqualToString:@"199001"]|| //注册（UN）
                [reqName isEqualToString:@"P77024"]|| //获取设备类型
                [reqName isEqualToString:@"P77025"]|| //上传实名认证文本信息
                [reqName isEqualToString:@"199019"]   //短信码验证
                )
        {
            return [self getCustomMess:rootElement];
        }
    }
    
     return nil;
}

#pragma mark -登录
- (id) login:(TBXMLElement *) bodyElement
{
    NSString *phoneNum = [TBXML textForElement:[TBXML childElementNamed:@"PHONENUMBER" parentElement:bodyElement]];
    NSString *rspCode = [TBXML textForElement:[TBXML childElementNamed:@"RSPCOD" parentElement:bodyElement]];
    NSString *rspMess = [TBXML textForElement:[TBXML childElementNamed:@"RSPMSG" parentElement:bodyElement]];
    NSString *mac = [TBXML textForElement:[TBXML childElementNamed:@"PACKAGEMAC" parentElement:bodyElement]];
    return @{@"PHONENUMBER":phoneNum,@"RSPCOD":rspCode,@"RSPMSG":rspMess,@"PACKAGEMAC":mac};
}


#pragma mark -交易列表查询
- (id) getRradeList:(TBXMLElement *) bodyElement
{
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    TBXMLElement *listElement = [TBXML childElementNamed:@"TRANDETAILS" parentElement:bodyElement];
    if (listElement)
    {
        TBXMLElement *itemElement = [TBXML childElementNamed:@"TRANDETAIL" parentElement:listElement];
        
        while (itemElement) {
               
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"SYSDAT" parentElement:itemElement]] forKey:@"SYSDAT"];
            [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"MERNAM" parentElement:itemElement]] forKey:@"MERNAM"];
            [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"LOGDAT" parentElement:itemElement]] forKey:@"LOGDAT"];
            [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"LOGNO" parentElement:itemElement]] forKey:@"LOGNO"];
            [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"TXNCD" parentElement:itemElement]] forKey:@"TXNCD"];
            [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"TXNSTS" parentElement:itemElement]] forKey:@"TXNSTS"];
            [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"TXNAMT" parentElement:itemElement]] forKey:@"TXNAMT"];
            [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"CRDNO" parentElement:itemElement]] forKey:@"CRDNO"];
            
            [arr addObject:dict];
            
        
            itemElement = [TBXML nextSiblingNamed:@"TRANDETAIL" searchFromElement:itemElement];
           }
    }
    
    return arr;
}

#pragma mark- 通用解析（返回RSPCOD和RSPMSG时调用）
- (id) getCustomMess:(TBXMLElement *) bodyElement
{
    
    NSString *rspCode = [TBXML textForElement:[TBXML childElementNamed:@"RSPCOD" parentElement:bodyElement]];
    NSString *rspMess = [TBXML textForElement:[TBXML childElementNamed:@"RSPMSG" parentElement:bodyElement]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:rspCode forKey:@"RSPCOD"];
    [dict setObject:rspMess forKey:@"RSPMSG"];

    
    return dict;
}

#pragma mark -头像下载
/**
 *  头像下载
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id) getHeadImg:(TBXMLElement *) bodyElement
{
    NSMutableDictionary * dict= [self getCustomMess:bodyElement];
    
    if ([dict[@"RSPCOD"] isEqualToString:@"000000"])
    {
        [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"HEADIMG" parentElement:bodyElement]] forKey:@"HEADIMG"];
    }
    
    return dict;
}

#pragma mark -用户签到
/**
 *  用户签到
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id) doSign:(TBXMLElement *) bodyElement
{
    NSMutableDictionary * dict= [self getCustomMess:bodyElement];
    
    if ([dict[@"RSPCOD"] isEqualToString:@"00"])
    {
        [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"PINKEY" parentElement:bodyElement]] forKey:@"PINKEY"];
        [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"MACKEY" parentElement:bodyElement]] forKey:@"MACKEY"];
        [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"ENCRYPTKEY" parentElement:bodyElement]] forKey:@"ENCRYPTKEY"];
    }
    
    return dict;
}

#pragma mark -商户信息查询
/**
 *  商户信息查询
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id) getMerchantInfo:(TBXMLElement *) bodyElement
{
    NSMutableDictionary * dict= [self getCustomMess:bodyElement];
    
    if ([dict[@"RSPCOD"] isEqualToString:@"00"])
    {
        [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"MERNAM" parentElement:bodyElement]] forKey:@"MERNAM"];
        [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"ACTNO" parentElement:bodyElement]] forKey:@"ACTNO"];
        [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"ACTNAM" parentElement:bodyElement]] forKey:@"ACTNAM"];
         [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"OPNBNK" parentElement:bodyElement]] forKey:@"OPNBNK"];
    }
    
    return dict;
}


#pragma mark -现金流水列表查询
- (id) getCashList:(TBXMLElement *) bodyElement
{
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableDictionary *dict = [self getCustomMess:bodyElement];
    if ([dict[@"RSPCOD"] isEqualToString:@"000000"])
    {
        [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"TOTALPAGE" parentElement:bodyElement]] forKey:@"TOTALPAGE"];        
        [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"TOTALTRANSAMT" parentElement:bodyElement]] forKey:@"TOTALTRANSAMT"];
        [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"TOTALROWNUMS" parentElement:bodyElement]] forKey:@"TOTALROWNUMS"];
        
        TBXMLElement *listElement = [TBXML childElementNamed:@"LIST" parentElement:bodyElement];
        if (listElement)
        {
            TBXMLElement *itemElement = [TBXML childElementNamed:@"ROW" parentElement:listElement];
            
            while (itemElement) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"TRANSID" parentElement:itemElement]] forKey:@"TRANSID"];
                [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"TRANSTYPE" parentElement:itemElement]] forKey:@"TRANSTYPE"];
                [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"TRANSAMT" parentElement:itemElement]] forKey:@"TRANSAMT"];
                [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"CURTYPE" parentElement:itemElement]] forKey:@"CURTYPE"];
                [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"TRANSDATE" parentElement:itemElement]] forKey:@"TRANSDATE"];
                [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"TRANSTIME" parentElement:itemElement]] forKey:@"TRANSTIME"];
                
                [arr addObject:dict];
                
                
                itemElement = [TBXML nextSiblingNamed:@"ROW" searchFromElement:itemElement];
            }
        }

        
    }
    [dict setObject:arr forKey:@"LIST"];
    
    return dict;
}

#pragma mark -获取省份列表
- (id) getProvinceList:(TBXMLElement *) bodyElement
{
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableDictionary *dict = [self getCustomMess:bodyElement];
    if ([dict[@"RSPCOD"] isEqualToString:@"00"])
    {
     
        TBXMLElement *listElement = [TBXML childElementNamed:@"TRANDETAILS" parentElement:bodyElement];
        if (listElement)
        {
            TBXMLElement *itemElement = [TBXML childElementNamed:@"TRANDETAIL" parentElement:listElement];
            
            while (itemElement) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                
                
                
                [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"AREANAM" parentElement:itemElement]] forKey:@"name"];
                [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"AREACOD" parentElement:itemElement]] forKey:@"code"];
                
             
                
                [arr addObject:dict];
                
                
                itemElement = [TBXML nextSiblingNamed:@"TRANDETAIL" searchFromElement:itemElement];
            }
        }
    }
    [dict setObject:arr forKey:@"LIST"];
    
    return dict;
}

#pragma mark -获取银行列表
- (id) getBankList:(TBXMLElement *) bodyElement
{
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableDictionary *dict = [self getCustomMess:bodyElement];
    if ([dict[@"RSPCOD"] isEqualToString:@"00"])
    {
        
        TBXMLElement *listElement = [TBXML childElementNamed:@"TRANDETAILS" parentElement:bodyElement];
        if (listElement)
        {
            TBXMLElement *itemElement = [TBXML childElementNamed:@"TRANDETAIL" parentElement:listElement];
            
            while (itemElement) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                
                
                
                [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"BANKNAM" parentElement:itemElement]] forKey:@"name"];
                [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"BANKCOD" parentElement:itemElement]] forKey:@"code"];
                 [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"BANKNO" parentElement:itemElement]] forKey:@"number"];
                
                [arr addObject:dict];
                
                itemElement = [TBXML nextSiblingNamed:@"TRANDETAIL" searchFromElement:itemElement];
            }
        }
    }
    
    [dict setObject:arr forKey:@"LIST"];
    
    return dict;
}

#pragma mark- 获取我的账户信息
- (id) getMyAccountInfo:(TBXMLElement *) bodyElement
{
    
    NSMutableDictionary *dict = [self getCustomMess:bodyElement];
    if ([dict[@"RSPCOD"] isEqualToString:@"00"])
    {
       [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"CASHBAL" parentElement:bodyElement]] forKey:@"CASHBAL"];
       [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"CASHACBAL" parentElement:bodyElement]] forKey:@"CASHACBAL"];
       [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"ACTNO" parentElement:bodyElement]] forKey:@"ACTNO"];
       [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"ACSTATUS" parentElement:bodyElement]] forKey:@"ACSTATUS"];
    }
    
    return dict;
}

#pragma mark- 实名认证
- (id)realNameAuth:(TBXMLElement *) bodyElement
{
    NSMutableDictionary *dict = [self getCustomMess:bodyElement];
    if ([dict[@"RSPCOD"] isEqualToString:@"00"])
    {
    
    }

   return dict;
}


#pragma mark- 消费
- (id) getTradeInfo:(TBXMLElement *) bodyElement
{
    
    NSMutableDictionary *dict = [self getCustomMess:bodyElement];
    if ([dict[@"RSPCOD"] isEqualToString:@"00"])
    {
        [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"LOGNO" parentElement:bodyElement]] forKey:@"LOGNO"];
    }
    
    return dict;
}

#pragma mark- 获取扣率信息
- (id) getRateInfo:(TBXMLElement *) bodyElement
{
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableDictionary *dict = [self getCustomMess:bodyElement];
    if ([dict[@"RSPCOD"] isEqualToString:@"00"])
    {
        
        TBXMLElement *listElement = [TBXML childElementNamed:@"TRANDETAILS" parentElement:bodyElement];
        if (listElement)
        {
            TBXMLElement *itemElement = [TBXML childElementNamed:@"TRANDETAIL" parentElement:listElement];
            
            while (itemElement) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                
                [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"IDFBAK" parentElement:itemElement]] forKey:@"IDFBAK"];
                [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"DUPLMT" parentElement:itemElement]] forKey:@"DUPLMT"];
                 [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"DFEERAT" parentElement:itemElement]] forKey:@"DFEERAT"];
                 [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"FEERAT" parentElement:itemElement]] forKey:@"FEERAT"];
                 [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"MERCID" parentElement:itemElement]] forKey:@"MERCID"];
                 [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"IDFID" parentElement:itemElement]] forKey:@"IDFID"];
                 [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"UPLMT" parentElement:itemElement]] forKey:@"UPLMT"];
                [dict setObject:[TBXML textForElement:[TBXML childElementNamed:@"IDFCHANNEL" parentElement:itemElement]] forKey:@"IDFCHANNEL"];
                
                [arr addObject:dict];
                
                itemElement = [TBXML nextSiblingNamed:@"TRANDETAIL" searchFromElement:itemElement];
            }
        }
    }
    
    [dict setObject:arr forKey:@"TRANDETAILS"];
    
    return dict;

}

#pragma mark- 获取我的实名认证信息
- (id) getAutoInfo:(TBXMLElement *) bodyElement
{
    
    NSMutableDictionary *dict = [self getCustomMess:bodyElement];
//    if ([dict[@"RSPCOD"] isEqualToString:@"00"])
//    {

        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"TERMNO" parentElement:bodyElement]] forKey:@"TERMNO"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"MERCNAM" parentElement:bodyElement]] forKey:@"MERCNAM"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"ADDRESS" parentElement:bodyElement]] forKey:@"ADDRESS"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"POSADDRESS" parentElement:bodyElement]] forKey:@"POSADDRESS"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"ACTNAM" parentElement:bodyElement]] forKey:@"ACTNAM"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"BANKCODE" parentElement:bodyElement]] forKey:@"BANKCODE"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"OPNBNKNAM" parentElement:bodyElement]] forKey:@"OPNBNKNAM"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"OPNBNK" parentElement:bodyElement]] forKey:@"OPNBNK"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"ACTNO" parentElement:bodyElement]] forKey:@"ACTNO"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"BUSNAM" parentElement:bodyElement]] forKey:@"BUSNAM"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"AREA" parentElement:bodyElement]] forKey:@"AREA"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"AREANAM" parentElement:bodyElement]] forKey:@"AREANAM"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"BANKAREA" parentElement:bodyElement]] forKey:@"BANKAREA"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"CORPORATEIDENTITY" parentElement:bodyElement]] forKey:@"CORPORATEIDENTITY"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"SCOBUS" parentElement:bodyElement]] forKey:@"SCOBUS"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"BIGBANKCOD" parentElement:bodyElement]] forKey:@"BIGBANKCOD"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"BIGBANKNAM" parentElement:bodyElement]] forKey:@"BIGBANKNAM"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"STATUS" parentElement:bodyElement]] forKey:@"STATUS"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"PROCOD" parentElement:bodyElement]] forKey:@"PROCOD"];
        [dict setValue:[TBXML textForElement:[TBXML childElementNamed:@"PRONAM" parentElement:bodyElement]] forKey:@"PRONAM"];
//    }
    
    return dict;
}
@end
