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
        if ([reqName isEqualToString:@"199002"]) //登录
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
        else if([reqName isEqualToString:@"199003"]) //修改密码
        {
            return [self getCustomMess:rootElement];
        }
        else if([reqName isEqualToString:@"200000"]) //头像上传
        {
            return [self getCustomMess:rootElement];
        }
        else if([reqName isEqualToString:@"200001"]) //头像下载
        {
            return [self getHeadImg:rootElement];
        }
        else if([reqName isEqualToString:@"199020"]) //签到
        {
            return [self doSign:rootElement];
        }
        else if([reqName isEqualToString:@"199005"]) //消费
        {
            return [self getCustomMess:rootElement];
        }
        else if([reqName isEqualToString:@"199006"]) //消费撤销
        {
            return [self getCustomMess:rootElement];
        }
        else if([reqName isEqualToString:@"199011"]) //商户信息查询
        {
            return [self getMerchantInfo:rootElement];
        }
        else if([reqName isEqual:@"200002"]) //现金记账
        {
            return [self getCustomMess:rootElement];
        }
        else if([reqName isEqual:@"200003"]) //现金流水列表
        {
            return [self getCashList:rootElement];
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
    
    if ([dict[@"RSPCOD"] isEqualToString:@"000000"])
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
@end
