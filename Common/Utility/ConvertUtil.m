//
//  ConvertUtil.m
//  POS2iPhone
//
//  Created by  STH on 11/6/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "ConvertUtil.h"
#import "NSData+NSString.h"
#import "Util.h"

@implementation ConvertUtil

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

/**
 64编码
 */
+(NSString *)base64Encoding:(NSData*) text
{
    if (text.length == 0)
        return @"";
    
    char *characters = malloc(text.length*3/2);
    
    if (characters == NULL)
        return @"";
    
    int end = text.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;
    
    while (index <= end) {
        int d = (((int)(((char *)[text bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[text bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[text bytes])[index + 2]) & 0x0ff);
        
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];
        
        index += 3;
        
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == text.length - 2)
    {
        int d = (((int)(((char *)[text bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[text bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == text.length - 1)
    {
        int d = ((int)(((char *)[text bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    return rtnStr;
}

/**
 字节转化为16进制数
 */
+(NSString *) parseByte2HexString:(Byte *) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    return hexStr;
}


/**
 字节数组转化16进制数
 */
+(NSString *) parseByteArray2HexString:(Byte[]) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    return [hexStr uppercaseString];
}

/*
 将16进制数据转化成NSData 数组
 */
+(NSData*) parseHexToByteArray:(NSString*) hexString
{
    int j=0;
    Byte bytes[hexString.length];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    return newData;
}

+ (NSString*) data2HexString:(NSData *) data
{
    const unsigned char* bytes = (const unsigned char*)[data bytes];
    NSUInteger nbBytes = [data length];
    NSUInteger strLen = 2*nbBytes;
    
    NSMutableString* hex = [[NSMutableString alloc] initWithCapacity:strLen];
    for(NSUInteger i=0; i<nbBytes; ) {
        [hex appendFormat:@"%02X", bytes[i]];
        ++i;
    }
    
    return hex;
}

+ (NSString *) stringToHex:(NSString *)str
{
    const char *inStr = [str  UTF8String];
    char outStr[str.length/4+1];
    binaryToHex(inStr, outStr);
    NSString *hexStr = [[NSString alloc] initWithCString:outStr encoding:NSUTF8StringEncoding];
    return hexStr;
}

+ (NSString *) hexToString:(NSString *)hexStr
{
    const char *inStr = [hexStr UTF8String];
    
    char *outStr;
	outStr = (char *) malloc(64 * sizeof(char));
	memset(outStr, 0x0, 64);
    
    hexToBinary(inStr, outStr);
    
    NSString *str = [[NSString alloc] initWithCString:outStr encoding:NSUTF8StringEncoding];
    
    return str;
}

+ (NSString *) hexToBinStr:(NSString *)hex
{
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    
    for (int i=0; i<hex.length; i++) {
        NSString *s = [[hex substringWithRange:NSMakeRange(i, 1)] uppercaseString];
        if ([s isEqualToString:@"0"]) {
            [tempStr appendString:@"0000"];
        } else if ([s isEqualToString:@"1"]) {
            [tempStr appendString:@"0001"];
        }else if ([s isEqualToString:@"2"]) {
            [tempStr appendString:@"0010"];
        }else if ([s isEqualToString:@"3"]) {
            [tempStr appendString:@"0011"];
        }else if ([s isEqualToString:@"4"]) {
            [tempStr appendString:@"0100"];
        }else if ([s isEqualToString:@"5"]) {
            [tempStr appendString:@"0101"];
        }else if ([s isEqualToString:@"6"]) {
            [tempStr appendString:@"0110"];
        }else if ([s isEqualToString:@"7"]) {
            [tempStr appendString:@"0111"];
        }else if ([s isEqualToString:@"8"]) {
            [tempStr appendString:@"1000"];
        }else if ([s isEqualToString:@"9"]) {
            [tempStr appendString:@"1001"];
        }else if ([s isEqualToString:@"A"]) {
            [tempStr appendString:@"1010"];
        }else if ([s isEqualToString:@"B"]) {
            [tempStr appendString:@"1011"];
        }else if ([s isEqualToString:@"C"]) {
            [tempStr appendString:@"1100"];
        }else if ([s isEqualToString:@"D"]) {
            [tempStr appendString:@"1101"];
        }else if ([s isEqualToString:@"E"]) {
            [tempStr appendString:@"1110"];
        }else if ([s isEqualToString:@"F"]) {
            [tempStr appendString:@"1111"];
        }
    }
    
    return tempStr;
}


+ (NSData *)hexStrTOData:(NSString *)hexStr
{
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [hexStr length]/2; i++) {
        byte_chars[0] = [hexStr characterAtIndex:i*2];
        byte_chars[1] = [hexStr characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    
    return commandToSend;
}

// byte[]转十六进制
+ (NSString *) byteToHex:(NSData *)aData
{
    NSString *hexStr = [NSString string];
    
    Byte *bytes = (Byte *)[aData bytes];
    for (int i=0; i<[aData length]; i++) {
        NSString *tempStr = [NSString stringWithFormat:@"%X", bytes[i] & 0xff]; // 16进制
        if ([tempStr length] == 1) {
            hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, tempStr];
        } else {
            hexStr = [NSString stringWithFormat:@"%@%@", hexStr, tempStr];
        }
        
    }
    
    return hexStr;
}

// 十六进制转byte[]
+ (NSData *) hexStrToByte:(NSString *)hexString
{
    NSMutableData* data = [NSMutableData data];
    
    for (int idx = 0; idx+2 <= hexString.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexString substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
    
    /*
     // test method
     unsigned char bytes[] = { 0x11, 0x56, 0xFF, 0xCD, 0x34, 0x30, 0xAA, 0x22 };
     NSData* expectedData = [NSData dataWithBytes:bytes length:sizeof(bytes)];
     NSLog(@"data %@", [@"1156FFCD3430AA22" hexToBytes]);
     NSLog(@"expectedData isEqual:%d", [expectedData isEqual:[@"1156FFCD3430AA22" hexToBytes]]);
     */
}

// BCD码转字符串
+ (NSString *) BCDToString:(NSData *) aData
{
    NSMutableString *mutableStr = [NSMutableString string];
    
    Byte *bytes = (Byte *)[aData bytes];
    
    for (int i=0; i<aData.length; i++) {
        [mutableStr appendFormat:@"%X", ((bytes[i] & 0xf0) >> 4)];
        [mutableStr appendFormat:@"%X", bytes[i] & 0x0f];
    }
    
    return mutableStr;
}

// 删除最右的0
+ (NSString *) BCDToStringDeleteRightZero:(NSData *)aData
{
    NSString *tempStr = [ConvertUtil BCDToString:aData];
    return [tempStr substringToIndex:tempStr.length - 1];
}

// 删除最左的0
+ (NSString *) BCDToStringDeleteLeftZero:(NSData *)aData
{
    NSString *tempStr = [ConvertUtil BCDToString:aData];
    return [tempStr substringFromIndex:1];
}

// 检查数据是否则转为BCD编码
// 都在 0x00 ~ 0x09, 0x30 ~ 0x3F的范围中，则返回true， 否则false
+ (BOOL) shouldToBCD:(NSData *) aData
{
    Byte *bytes = (Byte *)[aData bytes];
    for (int i=0; i<aData.length; i++){
        if (bytes[i] < 0x00 || bytes[i] > 0x3F || (bytes[i] > 0x09 && bytes[i] < 0x30)) {
            return false;
        }
    }
    
    return true;
}

// 对给定的数据进行BCD装换
+ (NSData *) byteToBCD:(NSData *) aData
{
    if (aData == nil) {
        NSLog(@"不能转为BCD，传入参数为nil");
        return nil;
    }
    
    if ([aData length] == 0) {
        NSLog(@"不能转为BCD，传入参数长度为空");
        return nil;
    }
    
    if (![self shouldToBCD:aData]) {
        NSLog(@"不能转为BCD，传入的参数非法。含有 不在[0x00 ~ 0x09], [0x30 ~ 0x3F]的范围中的数据");
        // TODO 如果不能转换，则返回原值
        return aData;
    }
    
    Byte *bytes = (Byte *) [aData bytes];
    
    if ([aData length] % 2 == 0) { // 长度为偶数时
        Byte ret_bytes[[aData length]/2];
        
        for (int i=0; i<[aData length]/2; i++) {
            Byte temp1 = bytes[i*2]<0x30 ? bytes[i*2] : bytes[i*2]-0x30;
            Byte temp2 = bytes[i*2+1]<0x30 ? bytes[i*2+1] : bytes[i*2+1]-0x30;
            ret_bytes[i] = ((temp1<<4)&0xFF) | ((temp2&0xFF)&0xFF); // 前4位 ｜ 后4位
        }
        
        return [[NSData alloc] initWithBytes:ret_bytes length:[aData length]/2];
        
    } else { // 长度为奇数时
        Byte ret_bytes[[aData length]/2+1];
        
        ret_bytes[0] = bytes[0]&0xFF;
        
        for (int i=1; i<([aData length]/2+1); i++) {
            Byte temp1 = bytes[i*2-1]<0x30 ? bytes[i*2-1] : bytes[i*2-1]-0x30;
            Byte temp2 = bytes[i*2]<0x30 ? bytes[i*2] : bytes[i*2]-0x30;
            ret_bytes[i] = ((temp1<<4)&0xFF) | ((temp2&0xFF)&0xFF); // 前4位 ｜ 后4位
        }
        
        return [[NSData alloc] initWithBytes:ret_bytes length:[aData length]/2+1];
    }
}

// 右靠齐 左补0
+ (NSString *) BCDTOStringLeftFillZero:(NSData *) aData
{
    NSString *str = [[NSString alloc] initWithData:aData encoding:NSASCIIStringEncoding];
    
    const char *Src = [str cStringUsingEncoding:NSASCIIStringEncoding];
    
    char *Des[aData.length * 2];
    
    int iSrcLen = strlen(Src);
    char chTemp = 0;
    char chDes = 0;
    for (int i = 0; i < iSrcLen; i++)
    {
        chTemp = Src[i];
        chDes = chTemp >> 4;
        Des[i * 2] = chDes + '0';
        chDes = (chTemp & 0x0F) + '0';
        Des[i * 2 + 1] = chDes;
    }
    
    NSString *tempStr = [[NSString alloc] initWithCString:(const char*)Des encoding:NSASCIIStringEncoding];
    return tempStr;
}

// 左靠齐 右补0
// 10进制串转为BCD码
+ (NSData *) BCDTOStringRightFillZero:(NSString *) asc
{
    int len = [asc length];
    int mod = len % 2;
    
    if (mod != 0){
        asc = [NSString stringWithFormat:@"%@0", asc];
        len = [asc length];
    }
    
    if (len >= 2) {
        len = len / 2;
    }
    
    Byte bbt[len];
    
    Byte *abt = (Byte *)[[asc dataUsingEncoding:NSUTF8StringEncoding] bytes];
    
    int j;
    int k;
    
    for (int p=0; p<[asc length]/2; p++) {
        if ((abt[2*p] >= '0') && (abt[2*p] <= '9')) {
            j = abt[2*p] - '0';
        } else if ((abt[2*p] >= 'a') && (abt[2*p] <= 'z')) {
            j = abt[2*p] - 'a' + 0x0a;
        } else {
            j = abt[2*p] - 'A' + 0x0a;
        }
        
        if ((abt[2*p+1] >= '0') && (abt[2*p+1] <= '9')) {
            k = abt[2*p+1] - '0';
        } else if ((abt[2*p+1] >= 'a') && (abt[2*p+1] <= 'z')) {
            k = abt[2*p+1] - 'a' + 0x0a;
        } else {
            k = abt[2*p+1] - 'A' + 0x0a;
        }
        
        int a = (j << 4) + k;
        bbt[p] = a;
    }
    
    return [NSData dataWithBytes:bbt length:len];
}

+ (NSData *) decStr2BCDRight:(NSString *) arg
{
    int len = [arg length];
    int mod = len % 2;
    
    if (mod != 0) {
        arg = [NSString stringWithFormat:@"%@0", arg];
        len = [arg length];
    }
    
    if (len >= 2) {
        len = len / 2;
    }
    
    Byte bbt[len];
    
    Byte *abt = (Byte *)[[arg dataUsingEncoding:NSUTF8StringEncoding] bytes];
    
    int j,k;
    
    for (int p=0; p<[arg length]/2; p++) {
        if ((abt[2*p] >= '0') && (abt[2*p] <= '9')) {
            j = abt[2*p] - '0';
        } else if ((abt[2*p] >= 'a') && (abt[2*p] <= 'z')) {
            j = abt[2*p] - 'a' + 0x0a;
        } else {
            j = abt[2*p] - 'A' + 0x0a;
        }
        
        if ((abt[2*p+1] >= '0') && (abt[2*p+1] <= '9')) {
            k = abt[2*p+1] - '0';
        } else if ((abt[2*p+1] >= 'a') && (abt[2*p+1] <= 'z')) {
            k = abt[2*p+1] - 'a' + 0x0a;
        } else {
            k = abt[2*p+1] - 'A' + 0x0a;
        }
        
        int a = (j << 4) + k;
        bbt[p] = a;
    }
    
    return [NSData dataWithBytes:bbt length:len];
    
}

// 当arc为单数时左补零右靠起，为复数时为原值
// 10进制串转为BCD码
+ (NSData *) decStr2BCDLeft:(NSString *) arg
{
    int len = [arg length];
    int mod = len % 2;
    
    if (mod != 0) {
        arg = [NSString stringWithFormat:@"0%@", arg];
        len = [arg length];
    }
    
    if (len >= 2) {
        len = len / 2;
    }
    
    Byte bbt[len];
    
    Byte *abt = (Byte *)[[arg dataUsingEncoding:NSUTF8StringEncoding] bytes];
    
    int j,k;
    
    for (int p=0; p<[arg length]/2; p++) {
        if ((abt[2*p] >= '0') && (abt[2*p] <= '9')) {
            j = abt[2*p] - '0';
        } else if ((abt[2*p] >= 'a') && (abt[2*p] <= 'z')) {
            j = abt[2*p] - 'a' + 0x0a;
        } else {
            j = abt[2*p] - 'A' + 0x0a;
        }
        
        if ((abt[2*p+1] >= '0') && (abt[2*p+1] <= '9')) {
            k = abt[2*p+1] - '0';
        } else if ((abt[2*p+1] >= 'a') && (abt[2*p+1] <= 'z')) {
            k = abt[2*p+1] - 'a' + 0x0a;
        } else {
            k = abt[2*p+1] - 'A' + 0x0a;
        }
        
        int a = (j << 4) + k;
        bbt[p] = a;
    }
    
    return [NSData dataWithBytes:bbt length:len];
}

+ (NSData *) toBCD:(NSString *) value fieldId:(int) fieldId
{
    NSData *data = [[NSData alloc] init];
    
    // 当域值为奇数时 需要根据不同域名来指定左靠齐或右靠齐
    if (value.length % 2 == 1) {
        // 左靠齐右补零
        if (fieldId == 2 || fieldId == 22 || fieldId == 35 || fieldId == 60) {
            data = [ConvertUtil decStr2BCDRight:value];
        } else {
            data = [ConvertUtil decStr2BCDLeft:value];
        }
    } else {
        data = [ConvertUtil decStr2BCDLeft:value];
    }
    
    return data;
}

+ (NSString *) char2String:(char *) charStr
{
    char char_array[1024];
    NSString *string_content = [[NSString alloc] initWithCString:(const char*)char_array
                                                        encoding:NSASCIIStringEncoding];
    
    return string_content;
}

+ (char *) string2Char:(NSString *) str
{
    char *char_content = [str cStringUsingEncoding:NSASCIIStringEncoding];
    return char_content;
}

+ (NSString *) traceData:(NSData *) aData
{
    Byte *bytes = (Byte *)[aData bytes];
    
    NSMutableString *mutableString = [NSMutableString string];
    
    NSMutableData *mutableData = [NSMutableData dataWithLength:76];
    
    int i=0;
    int j=0;
    
    [mutableString appendString:@"-------------------------------\n"];
    for (i=0; i<[aData length]; i++){
        if (j == 0) {
            // 打印前四位 000: ;
            [mutableData replaceBytesInRange:NSMakeRange(0, 5) withBytes:[[NSString stringWithFormat:@"%03d: ", i] cStringUsingEncoding:NSUTF8StringEncoding] length:5];
            
            // 打印后四位 :015 ;
            [mutableData replaceBytesInRange:NSMakeRange(72, 4) withBytes:[[NSString stringWithFormat:@":%03d", i+16] cStringUsingEncoding:NSUTF8StringEncoding] length:4];
        }
        
        [mutableData replaceBytesInRange:NSMakeRange(j*3+5+(j>7?1:0), 3) withBytes:[[NSString stringWithFormat:@"%02X", bytes[i]] cStringUsingEncoding:NSUTF8StringEncoding] length:3];
        
        if (bytes[i] == 0x00){
            [mutableData replaceBytesInRange:NSMakeRange(j+55+(j>7?1:0), 1) withBytes:'.'];
        } else {
            [mutableData replaceBytesInRange:NSMakeRange(j+55+(j>7?1:0), 1) withBytes:bytes[i]];
        }
        
        j++;
        
        // 当j为16时换行，j重置为0 每行显示为16进制的16个字节
        if (j == 16) {
            [mutableString appendFormat:@"%@\n", [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding]];
            [mutableData resetBytesInRange:NSMakeRange(0, 76)];
            j = 0;
        }
    }
    
    if (j != 0) {
        [mutableString appendFormat:@"%@\n", [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding]];
        [mutableData resetBytesInRange:NSMakeRange(0, 76)];
    }
    
    [mutableString appendString:@"-------------------------------\n"];
    
    return mutableString;
}

+ (NSString *) stringToHexStr:(NSString *)str
{
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        // [hexString [NSString stringWithFormat:@"%02x", chars[i]]]; /*previous input*/
        [hexString appendFormat:@"%02x", chars[i]]; /*EDITED PER COMMENT BELOW*/
    }
    free(chars);
    
    return hexString ;
}

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString; 
    
    
}


+ (NSString *) GBKToUTF8:(NSString *) str
{
    NSData *valueData = [ConvertUtil parseHexToByteArray:str];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *result= [[NSString alloc] initWithData:valueData encoding:enc];
    
    return result;
}

/*
 bool StrToBCD(const char *Src,char *Des,int iDesLen)
 
 {
 if (NULL == Src)
 {
 return false;
 }
 if (NULL == Des)
 {
 return false;
 }
 if (0 == iDesLen)
 {
 return false;
 }
 
 int iSrcLen = strlen(Src);
 if (iSrcLen > iDesLen * 2)
 {
 return false;
 }
 
 char chTemp = 0;
 int i;
 for (i = 0; i < iSrcLen; i++)
 {
 if (i % 2 == 0)
 {
 chTemp = (Src[i] << 4) & 0xF0;
 }
 else
 {
 chTemp = (chTemp & 0xF0) | (Src[i] & 0x0F);
 Des[i / 2] = chTemp;
 }
 }
 if (i % 2 != 0)
 {
 Des[i / 2] = chTemp;
 }
 
 return true;
 }
 
 bool BCDToStr(const char *Src, char *Des)
 {
 if (NULL == Src)
 {
 return false;
 }
 if (NULL == Src)
 {
 return false;
 }
 
 int iSrcLen = strlen(Src);
 char chTemp = 0;
 char chDes = 0;
 for (int i = 0; i < iSrcLen; i++)
 {
 chTemp = Src[i];
 chDes = chTemp >> 4;
 Des[i * 2] = chDes + '0';
 chDes = (chTemp & 0x0F) + '0';
 Des[i * 2 + 1] = chDes;
 }
 return true;
 }
 */


@end
