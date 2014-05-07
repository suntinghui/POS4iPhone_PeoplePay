//
//  SecurityUtil.m
//  BLECard
//
//  Created by  STH on 3/15/14.
//  Copyright (c) 2014 Jason. All rights reserved.
//

#import "SecurityUtil.h"

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonCrypto.h>
#import "ConvertUtil.h"

@implementation SecurityUtil

+ (NSString *) md5Crypto:(NSString *) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *) encryptUseDES:(NSData *)textData key:(NSData *)keyData
{
    NSString *ciphertext = nil;
    
    NSUInteger dataLength = [textData length];
    
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          [keyData bytes], kCCKeySizeDES,
                                          nil,
                                          [textData bytes]	, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //NSLog(@"DES加密成功");
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [ConvertUtil data2HexString:data];
    }else{
        NSLog(@"DES加密失败");
    }
    return ciphertext;
}

+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *cleartext = nil;
    
    NSData *textData = [ConvertUtil parseHexToByteArray:plainText];
    NSUInteger dataLength = [textData length];
    
    NSData *keyData = [ConvertUtil parseHexToByteArray:key];
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          [keyData bytes], kCCKeySizeDES,
                                          nil,
                                          [textData bytes]	, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
//        NSLog(@"DES解密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [ConvertUtil data2HexString:data];
    }else{
        NSLog(@"DES解密失败");
    }
    return cleartext;
}

// 一定要注意，密钥必须是24字节，如果是16字节的话，可以将前8字节再放在最后，组成24字节。
+ (NSString *) encryptUseTripleDES:(NSString *)clearText key:(NSString *)key
{
    NSString *ciphertext = nil;
    
    NSData *textData = [ConvertUtil parseHexToByteArray:clearText];
    NSUInteger dataLength = [textData length];
    
    NSData *keyData = [ConvertUtil parseHexToByteArray:key];
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithm3DES,
                                          kCCOptionECBMode,
                                          [keyData bytes], kCCKeySize3DES,
                                          nil,
                                          [textData bytes]	, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
//        NSLog(@"DES加密成功");
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        Byte* bb = (Byte*)[data bytes];
        ciphertext = [ConvertUtil parseByteArray2HexString:bb];
    }else{
        NSLog(@"DES加密失败");
    }
    return ciphertext;
}

+ (NSString *) decryptUseTripleDES:(NSString *)plainText key:(NSString *)key
{
    NSString *cleartext = nil;
    
    NSData *textData = [ConvertUtil parseHexToByteArray:plainText];
    NSUInteger dataLength = [textData length];
    
    NSData *keyData = [ConvertUtil parseHexToByteArray:key];
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithm3DES,
                                          kCCOptionECBMode,
                                          [keyData bytes], kCCKeySize3DES,
                                          nil,
                                          [textData bytes]	, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
//        NSLog(@"DES解密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [ConvertUtil data2HexString:data];
    }else{
        NSLog(@"DES解密失败");
    }
    return cleartext;
}

+ (NSString *) encryptUseXOR:(NSString *) data withKey:(NSString *)key
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:data];
    while (str.length % 16 != 0) {
        [str appendString:@"00"];
    }
    
    NSData *dataData = [ConvertUtil parseHexToByteArray:str];
    NSData *keyData = [ConvertUtil parseHexToByteArray:key];
    
    NSData *result = [SecurityUtil encryptXOR:dataData withKey:keyData];
    
    return [ConvertUtil data2HexString:result];
}

+ (NSData *) encryptXOR:(NSData *) data withKey:(NSData *) key
{
    //TODO: #warning This needs to be thoroughly audited, I'm not sure I follow this correctly
	// From SO post http://stackoverflow.com/questions/11724527/xor-file-encryption-in-ios
	NSMutableData *result = data.mutableCopy;
    
    // Get pointer to data to obfuscate
    char *dataPtr = (char *)result.mutableBytes;
    
    // Get pointer to key data
    char *keyData = (char *)key.bytes;
    
    // Points to each char in sequence in the key
    char *keyPtr = keyData;
    int keyIndex = 0;
    
    // For each character in data, xor with current value in key
    for (int x = 0; x < data.length; x++)
    {
        // Replace current character in data with
        // current character xor'd with current key value.
        // Bump each pointer to the next character
        *dataPtr = *dataPtr ^ *keyPtr;
        dataPtr++;
        keyPtr++;
        
        // If at end of key data, reset count and
        // set key pointer back to start of key value
        if (++keyIndex == key.length)
		{
            keyIndex = 0;
			keyPtr = keyData;
		}
	}
    
    return result;
}

// 根据源数组 按每8个字节一组进行遍历异或 不满8字节补零 得到异或后的最后8个字节数组
+ (NSString *) encryptUseXOR8:(NSString *) data
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:data];
    while (str.length % 16 != 0) {
        [str appendString:@"00"];
    }
    
    
    if (str.length == 16) {
        return [SecurityUtil encryptUseXOR:str withKey:str];
        
    } else if (str.length == 32){
        NSString *temp = [SecurityUtil encryptUseXOR:[str substringToIndex:16] withKey:[str substringFromIndex:16]];
        return temp;
        
    } else {
        NSString *temp = [SecurityUtil encryptUseXOR:[str substringToIndex:16] withKey:[str substringFromIndex:16]];
        
        unsigned long count = str.length/16-1;
        for (int i=2; i<count+1; i++) {
            temp = [SecurityUtil encryptUseXOR:temp withKey:[str substringWithRange:NSMakeRange(16*i, 16)]];
        }
        
        return temp;
    }
    
}

// 根据源数组 按每16个字节一组进行遍历异或 不满16字节补零 得到异或后的最后16个字节数组
+ (NSString *) encryptUseXOR16:(NSString *) data
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:data];
    while (str.length % 32 != 0) {
        [str appendString:@"00"];
    }
    
    
    if (str.length == 32) {
        return [SecurityUtil encryptUseXOR:str withKey:str];
        
    } else if (str.length == 64){
        NSString *temp = [SecurityUtil encryptUseXOR:[str substringToIndex:32] withKey:[str substringFromIndex:32]];
        return temp;
        
    } else {
        NSString *temp = [SecurityUtil encryptUseXOR:[str substringToIndex:32] withKey:[str substringFromIndex:32]];
        
        unsigned long count = str.length/32-1;
        for (int i=2; i<count+1; i++) {
            temp = [SecurityUtil encryptUseXOR:temp withKey:[str substringWithRange:NSMakeRange(32*i, 32)]];
        }
        
        return temp;
    }
    
}

+ (NSData *) encryptXORAndMac:(NSString *) data withKey:(NSString *) macKey
{
    // 将数据进行8字节异或运算
    NSString *xorStr = [SecurityUtil encryptUseXOR8:data];
    NSData *xorData = [xorStr dataUsingEncoding:NSASCIIStringEncoding];
    
    // 取前8个字节用MAK加密(进行DES)
    NSData *macData = [ConvertUtil parseHexToByteArray:macKey];
    NSString *tempStr1 = [SecurityUtil encryptUseDES:[xorData subdataWithRange:NSMakeRange(0, 8)] key:macData];
    NSData *tempData1 = [ConvertUtil parseHexToByteArray:tempStr1];
    
    // 前8个字节进行DES的结果值与后8个字节异或运算
    NSData *tempData2 = [SecurityUtil encryptXOR:tempData1 withKey:[xorData subdataWithRange:NSMakeRange(8, 8)]];
    
    // 用异或的结果,再一次用MAK加密（单倍长密钥算法运算）（进行DES运算）
    NSString *tmp = [SecurityUtil encryptUseDES:tempData2 key:macData];
    
    NSData *tmpData = [[tmp substringToIndex:8] dataUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"***:%@", tmpData);
    return tmpData;
}

@end
