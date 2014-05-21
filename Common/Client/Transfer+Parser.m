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
    
   NSMutableDictionary * dict= [self getCustomMess:bodyElement];
    
    return dict;
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
@end
