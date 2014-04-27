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
        TBXMLElement *bodyElement = [TBXML childElementNamed:@"EPOSPROTOCOL" parentElement:rootElement];
        while (bodyElement) {
            if ([reqName isEqualToString:@"199002"]) //登录
            {
                
                
            }
        }
       
    }
    
     return nil;
}

@end
