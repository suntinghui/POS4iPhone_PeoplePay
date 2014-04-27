//
//  Transfer+Parser.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-4-26.
//  Copyright (c) 2014年 文彬. All rights reserved.
//

#import "Transfer.h"

@interface Transfer (Parser)

- (id) ParseXMLWithReqCode:(NSString *) reqName
                 xmlString:(NSString *) xml;

@end
