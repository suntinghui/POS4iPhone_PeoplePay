//
//  SecurityUtil.h
//  BLECard
//
//  Created by  STH on 3/15/14.
//  Copyright (c) 2014 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtil : NSObject

+ (NSString *) md5Crypto:(NSString *) str;

+ (NSString *) encryptUseDES:(NSData *)plainText key:(NSData *)key;

+ (NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key;

+ (NSString *) encryptUseTripleDES:(NSString *)clearText key:(NSString *)key;

+ (NSString *) decryptUseTripleDES:(NSString *)plainText key:(NSString *)key;

+ (NSString *) encryptUseXOR:(NSString *) data withKey:(NSString *)key;

+ (NSData *) encryptXOR:(NSData *) data withKey:(NSData *) key;

+ (NSString *) encryptUseXOR8:(NSString *) data;

+ (NSString *) encryptUseXOR16:(NSString *) data;

+ (NSData *) encryptXORAndMac:(NSString *) data withKey:(NSString *) macKey;


@end
