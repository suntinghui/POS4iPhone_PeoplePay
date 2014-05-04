//
//  TestAES.m
//  POS4iPhone_PeoplePay
//
//  Created by  STH on 4/29/14.
//  Copyright (c) 2014 文彬. All rights reserved.
//

#import "TestAES.h"
#import <openssl/aes.h>

@implementation TestAES

+(NSString *)testAES:(NSString *)string
{
    AES_KEY aes;
    unsigned char key[17] = "AA70CD77125FC304";//密匙
    unsigned char iv[17] = "0102030405060708";//向量
    unsigned char* input_string; //要加密的数据
    unsigned char* encrypt_string;//加密后的数据
    unsigned char* decrypt_string;//解密后的数据
    unsigned long len;        // encrypt length (in multiple of AES_BLOCK_SIZE)
    unsigned int i;     //for 循环
    unsigned int strsize; //数据长度
    
    
    strsize = strlen([string UTF8String]);
    NSLog(@"strsize == %d",strsize);
    
    
    len = 0;
    if ((strsize + 1) % AES_BLOCK_SIZE == 0)
    {
        len = strsize + 1;
        input_string = (unsigned char*)calloc(len, sizeof(unsigned char));
        memset(input_string,16,len);
    } else {
        len = ((strsize + 1) / AES_BLOCK_SIZE + 1) * AES_BLOCK_SIZE;
        input_string = (unsigned char*)calloc(len, sizeof(unsigned char));
        int len_temp = len - strsize;
        memset(input_string,len_temp,len);
    }
    
    NSLog(@"len == %ld",len);
    // set the input string
    
    if (input_string == NULL) {
        //        fprintf(stderr, "Unable to allocate memory for input_string\n");
        NSLog(@"Unable to allocate memory for input_string");
        exit(-1);
    }
    
    strncpy((char*)input_string, [string UTF8String], strsize);
    
    if (AES_set_encrypt_key(key, 128, &aes) < 0) {
        NSLog(@"Unable to set encryption key in AES");
        //        fprintf(stderr, "Unable to set encryption key in AES\n");
        exit(-1);
    }
    // alloc encrypt_string
    encrypt_string = (unsigned char*)calloc(len, sizeof(unsigned char));
    if (encrypt_string == NULL) {
        NSLog(@"Unable to allocate memory for encrypt_string");
        exit(-1);
    }
    // encrypt (iv will change)
    AES_cbc_encrypt(input_string, encrypt_string, len, &aes, iv, AES_ENCRYPT);
    
    
    // alloc decrypt_string
    decrypt_string = (unsigned char*)calloc(len, sizeof(unsigned char));
    if (decrypt_string == NULL) {
        NSLog(@"Unable to allocate memory for decrypt_string");
        exit(-1);
    }
    
    if (AES_set_decrypt_key(key, 128, &aes) < 0) {
        NSLog(@"Unable to set decryption key in AES");
        exit(-1);
    }

    
    // decrypt
    AES_cbc_encrypt(encrypt_string, decrypt_string, len, &aes, iv, AES_DECRYPT);

    
    // print
    printf("input_string = %s\n", input_string);
    printf("encrypted string = ");
    for (i=0; i<len; ++i) {
        printf("%x%x", (encrypt_string[i] >> 4) & 0xf,
               encrypt_string[i] & 0xf);
    }
    printf("\n");
    printf("decrypted string = %s\n", decrypt_string);
    
    return @"";
    
}

@end
