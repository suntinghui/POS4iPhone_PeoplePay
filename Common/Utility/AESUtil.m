//
//  AESUtil.m
//  POS4iPhone_PeoplePay
//
//  Created by  STH on 5/7/14.
//  Copyright (c) 2014 文彬. All rights reserved.
//

#import "AESUtil.h"

#include <string.h>
#include <openssl/evp.h>

typedef unsigned int uint;
typedef unsigned char uint8;
typedef unsigned int uint32;

@implementation AESUtil

#ifndef MIN
#define MIN(a,b)            (((a) < (b)) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b)            (((a) < (b)) ? (b) : (a))
#endif


#define BETWEEN(VAL, vmin, vmax) ((VAL) >= (vmin) && (VAL) <= (vmax))
#define ISHEXCHAR(VAL) (BETWEEN(VAL, '0', '9') || BETWEEN(VAL, 'A', 'F') || BETWEEN(VAL, 'a', 'f'))

char BYTE2HEX(uint8 int_val)
{
    if (BETWEEN(int_val, 0, 9))
    {
        return int_val + 0x30;
    }
    
    if (BETWEEN(int_val, 0xA, 0xF))
    {
        return (int_val - 0xA) + 'A';
    }
    
    return '0';
}

uint BIN2HEX(uint8 * p_binstr, uint bin_len, uint8 * p_hexstr)
{
    uint32 index   = 0;
    uint32 hex_len = bin_len * 2;
    
    for (index = 0; index < bin_len; index++)
    {
        p_hexstr[index * 2] = BYTE2HEX((p_binstr[index] >> 4) & 0x0F);
        p_hexstr[(index * 2) + 1] = BYTE2HEX(p_binstr[index] & 0x0F);
    }
	p_hexstr[hex_len]=0;
    
    return hex_len;
}

char *hex2bin(char *hex,unsigned int hex_len)
{
	int pos = 0;
	int offset = 0;
	long long_char;
	char *endptr;
	char temp_hex[3] = "\0\0";
	char *bin;
	bin = malloc(hex_len/2 + 1);
	memset(bin,0,hex_len/2 + 1);
	while(pos <= hex_len)
	{
		memcpy(temp_hex,hex+pos,2);
		long_char = strtol(temp_hex, &endptr, 16);
		if(long_char)
		{
			offset += sprintf(bin + offset, "%c", (unsigned char)long_char);
		}
		else
		{
			offset++;
		}
		pos += 2;
	}
	return bin;
}

+ (NSString *) encryptUseAES:(NSString *) plainText
{
    const EVP_CIPHER *cipher;
    unsigned char key[17]="AA70CD77125FC304";
	unsigned char iv[17]="0102030405060708";
    
    const char *in = [plainText cStringUsingEncoding:NSUTF8StringEncoding];
    int len,inl=strlen((char *)in);
	unsigned char *out=malloc(inl+128);
	if (out==NULL)
		return NULL;
	int outl=0;
	unsigned char *hexstr=malloc(2*inl+256);
	if (hexstr==NULL){
		free(out);
		return NULL;
	}
	
    EVP_CIPHER_CTX             ctx;
    EVP_CIPHER_CTX_init(&ctx);
	
    cipher  = EVP_aes_128_cbc();
    EVP_EncryptInit_ex(&ctx, cipher, NULL, key, iv);
	
    len=0;
    
    EVP_EncryptUpdate(&ctx,out+len,&outl,in,inl);
    len+=outl;
    
    EVP_EncryptFinal_ex(&ctx,out+len,&outl);
    len+=outl;
    
    EVP_CIPHER_CTX_cleanup(&ctx);
	
	BIN2HEX(out, len, hexstr);
    
	NSString *result = [[NSString alloc] initWithCString:(const char*)hexstr encoding:NSUTF8StringEncoding];
	free(out);
	free(hexstr);
    return result;
}

+ (NSString *) decryptUseAES:(NSString *) clearText
{
    const EVP_CIPHER *cipher;
    unsigned char key[17]="AA70CD77125FC304";
	unsigned char iv[17]="0102030405060708";
	const char *hex = [clearText UTF8String];
	
    unsigned char* out = hex2bin(hex, strlen((char *)hex));
    int len,outl= strlen(hex)/2;
    int del = 0;
    unsigned char *de = malloc(outl+128);
	if(de == NULL)
		return NULL;
	
    EVP_CIPHER_CTX             ctx;
   	
    cipher  = EVP_aes_128_cbc();
    
    EVP_CIPHER_CTX_init(&ctx);
	
    EVP_DecryptInit_ex(&ctx, cipher, NULL, key, iv);
	
    
	len=0;
    EVP_DecryptUpdate(&ctx,de, &del, out,outl);
    len+=del;
    
    EVP_DecryptFinal_ex(&ctx,de+len,&del);
    len+=del;
    de[len]=0;
    EVP_CIPHER_CTX_cleanup(&ctx);
    
    NSString *result = [[NSString alloc] initWithUTF8String:de];
	return result;
}

@end
