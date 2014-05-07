//
//  AESUtil.h
//  POS4iPhone_PeoplePay
//
//  Created by  STH on 5/7/14.
//  Copyright (c) 2014 文彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AESUtil : NSObject

+ (NSString *) encryptUseAES:(NSString *) plainText;

+ (NSString *) decryptUseAES:(NSString *) clearText;

@end
