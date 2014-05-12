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
            return [self getVerCode:rootElement];
        }
        else if([reqName isEqualToString:@"199008"]) //流水查询
        {
            return [self getRradeList:rootElement];
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

#pragma mark -获取短信验证码
- (id) getVerCode:(TBXMLElement *) bodyElement
{

    NSString *rspCode = [TBXML textForElement:[TBXML childElementNamed:@"RSPCOD" parentElement:bodyElement]];
    NSString *rspMess = [TBXML textForElement:[TBXML childElementNamed:@"RSPMSG" parentElement:bodyElement]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:rspCode forKey:@"RSPCOD"];
    [dict setObject:rspMess forKey:@"RSPMSG"];
    
    return dict;
}

#pragma mark -交易列表查询
- (id) getRradeList:(TBXMLElement *) bodyElement
{
    
    NSString *rspCode = [TBXML textForElement:[TBXML childElementNamed:@"RSPCOD" parentElement:bodyElement]];
    NSString *rspMess = [TBXML textForElement:[TBXML childElementNamed:@"RSPMSG" parentElement:bodyElement]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:rspCode forKey:@"RSPCOD"];
    [dict setObject:rspMess forKey:@"RSPMSG"];
    
    return dict;
}
@end
