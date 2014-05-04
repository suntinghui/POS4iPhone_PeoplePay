//
//  AES.m
//  POS4iPhone_PeoplePay
//
//  Created by  STH on 4/29/14.
//  Copyright (c) 2014 文彬. All rights reserved.
//

#import "AES.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <openssl/aes.h>
#include <openssl/evp.h>

@implementation AES

#define AES_BITS 128
#define MSG_LEN 64

int aes()
{
    const EVP_CIPHER *cipher;
    unsigned char key[16]={0xAA, 0x70, 0xCD, 0x77, 0x12, 0x5F, 0xC3, 0x04,0,0,0,0,0,0,0,0};
	unsigned char iv[16]={1, 2,3,4,5,6,7,8,0,0,0,0,0,0,0,0};
	unsigned char in[300]="<?xml version=\"1.0\" encoding=\"UTF-8\"?><EPOSPROTOCOL><PASSWORD>1234qwer</PASSWORD><TRANCODE>199002</TRANCODE><PCSIM>获取不到</PCSIM><PHONENUMBER>18811068526</PHONENUMBER><PACKAGEMAC>854CB00CAC01A1B164EA511997A47B50</PACKAGEMAC></EPOSPROTOCOL>\n";
	unsigned char out[300],de[300];
    int i,len,inl=strlen((char *)in);
	int outl,total=0;
    
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
    
    printf("－－－－－－－－－－－－－－－－－－－－－－\n");
    
    printf("dec %lu:",strlen((char*)out));
    printf("%s\n",out);
    
    printf("－－－－－－－－－－－－－－－－－－－－－－\n");
    

	
	return 0;
}


int aes_encrypt(char* in, char* key, char* out)//, int olen)可能会设置buf长度
{
    if(!in || !key || !out)
        return 0;
    
    unsigned char iv[AES_BLOCK_SIZE] = "0102030405060708";//加密的初始化向量
    
    AES_KEY aes;
    if(AES_set_encrypt_key((unsigned char*)key, 128, &aes) < 0)
    {
        return 0;
    }
    int len=strlen(in);//这里的长度是char*in的长度，但是如果in中间包含'\0'字符的话
    
    //那么就只会加密前面'\0'前面的一段，所以，这个len可以作为参数传进来，记录in的长度
    
    //至于解密也是一个道理，光以'\0'来判断字符串长度，确有不妥，后面都是一个道理。
    AES_cbc_encrypt((unsigned char*)in, (unsigned char*)out, len, &aes, iv, AES_ENCRYPT);
    return 1;
}

int aes_decrypt(char* in, char* key, char* out)
{
    if(!in || !key || !out)
        return 0;
    
    unsigned char iv[AES_BLOCK_SIZE] = "0102030405060708";//加密的初始化向量
    
    AES_KEY aes;
    if(AES_set_decrypt_key((unsigned char*)key, 128, &aes) < 0)
    {
        return 0;
    }
    int len=strlen(in);
    AES_cbc_encrypt((unsigned char*)in, (unsigned char*)out, len, &aes, iv, AES_DECRYPT);
    return 1;
}

int p()
{
    char sourceStringTemp[MSG_LEN];
    char dstStringTemp[MSG_LEN];
    
    memset((char*)sourceStringTemp, 0 ,MSG_LEN);
    memset((char*)dstStringTemp, 0 ,MSG_LEN);
    
    
    //strcpy((char*)sourceStringTemp, argv[1]);
    
    char key[AES_BLOCK_SIZE] = "AA70CD77125FC304";
    
    char *temp = "1111111111111111";
    
    if(!aes_encrypt(temp,key,dstStringTemp))
    {
    	printf("encrypt error\n");
    	return -1;
    }

    printf("enc %d:",strlen((char*)dstStringTemp));
    int i;
    for(i= 0;dstStringTemp[i];i+=1){
        printf("%x",(unsigned char)dstStringTemp[i]);
    }
    
    memset((char*)sourceStringTemp, 0 ,MSG_LEN);
    
    
    
    if(!aes_decrypt(dstStringTemp,key,sourceStringTemp))
    {
    	printf("decrypt error\n");
    	return -1;
    }
    printf("\n");
    printf("dec %lu:",strlen(sourceStringTemp));
    printf("%s\n",sourceStringTemp);
    
//    for(i= 0;sourceStringTemp[i];i+=1){
//        printf("%x",(unsigned char)sourceStringTemp[i]);
//    }
    printf("\n");
    return 0;
}


@end
