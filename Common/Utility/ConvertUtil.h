//
//  ConvertUtil.h
//  POS2iPhone
//
//  Created by  STH on 11/6/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertUtil : NSObject

+ (NSString *) stringToHex:(NSString *)str;

+ (NSString *) hexToString:(NSString *)str;

+ (NSString *) hexToBinStr:(NSString *)hex;

+ (NSData *) hexStrTOData:(NSString *) hexStr;

+ (NSString *) byteToHex:(NSData *) aData;

+ (NSData *) hexStrToByte:(NSString *)hexString;

+ (NSString *) BCDToString:(NSData *) aData;

+ (NSString *) BCDToStringDeleteRightZero:(NSData *)aData;

+ (NSString *) BCDToStringDeleteLeftZero:(NSData *)aData;

+ (BOOL) shouldToBCD:(NSData *) aData;

+ (NSData *) byteToBCD:(NSData *) aData;

+ (NSString *) BCDTOStringLeftFillZero:(NSData *) aData;

+ (NSData *) BCDTOStringRightFillZero:(NSString *) asc;

+ (NSData *) decStr2BCDLeft:(NSString *) arg;

+ (NSData *) decStr2BCDRight:(NSString *) arg;

+ (NSData *) toBCD:(NSString *) value fieldId:(int) fieldId;

+ (NSString *) char2String:(char *) charStr;

+ (char *) string2Char:(NSString *) str;

+ (NSString *) traceData:(NSData *) aData;

+ (NSString *) stringToHexStr:(NSString *)str;


/**
 64编码
 */
+(NSString *)base64Encoding:(NSData*) text;

/**
 字节转化为16进制数
 */
+(NSString *) parseByte2HexString:(Byte *) bytes;

/**
 字节数组转化16进制数
 */
+(NSString *) parseByteArray2HexString:(Byte[]) bytes;

/*
 将16进制数据转化成NSData 数组
 */
+(NSData*) parseHexToByteArray:(NSString*) hexString;

+ (NSString*) data2HexString:(NSData *) data;

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString;

+ (NSString *) GBKToUTF8:(NSString *) str;

@end
