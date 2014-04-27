#include "Util.h"

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

static const char *num = "0123456789ABCDEF";

/***********
功能：打印二进制数组
*************/
 void PrintBufx(unsigned char * buf, int	buflen) {
char temp[32]={0};
#if 1
	int i;
	printf("len = %d\n", buflen);
	printf("%s： \t", "十六进制数");
	for (i = 0; i<buflen; i++) {
		if (i % 32 != 31){
			temp[i]=buf[i];
			printf("%02x,", buf[i]);
		}else{
			printf("%02x\n", buf[i]);
		}
	}
	printf("\n %s: \t ","ASCII");
	printf(" %s\n", buf);
	return;
#endif
}

/***********
功能：右补0
    word
*************/
int strRegihtFill(char * src, char * dest,char  word,  int length){
	int len = strlen(src);
	memset(dest, word, length);
	memcpy(dest, src, len);
	//memccpy(dest, src, 0, len);
	return 0;
}

/***********
功能：左补0
*************/
int strLeftFill(char * src, char * dest,char  word,  int length){
	memset(dest, word, length);
	int len = strlen(src);
	//memccpy(dest, src, length - len, length);
	for (int i = 0; i < len; i++){
		dest[length - len + i] = src[i];
	}
	return 0;
}

/**
 * 字符串反转
 */
char *reverse(char *str)
{
    char *addr=str,temp;
    int i,j=0;
    i=strlen(str)-1;
    while(i>j)
    {
        temp=*(str+i);
        *(str+i--)=*(str+j);
        *(str+j++)=temp;
        }
    return addr;
    }


//函 数 名：AscToHex()
//功能描述：把ASCII转换为16进制
unsigned char AscToHex(unsigned char aHex){

	if ((aHex >= 0) && (aHex <= 9))

		aHex += 0x30;

	else if ((aHex >= 10) && (aHex <= 15))//A-F

		aHex += 0x37;

	else aHex = 0xff;

	return aHex;
}


//函 数 名：HexToAsc()
//功能描述：把16进制转换为ASCII
unsigned char HexToAsc(unsigned char aChar){

	if ((aChar >= 0x30) && (aChar <= 0x39))

		aChar -= 0x30;

	else if ((aChar >= 0x41) && (aChar <= 0x46))//大写字母

		aChar -= 0x37;

	else if ((aChar >= 0x61) && (aChar <= 0x66))//小写字母

		aChar -= 0x57;

	else aChar = 0xff;

	return aChar;
}

/**
*功能：二进制串转十六进制串
*/
bool binaryToHex(const char *inStr, char *outStr) {
	static char hex[] = "0123456789ABCDEF";
	int len = strlen(inStr) / 4;
	int i = strlen(inStr) % 4;
	char current = 0;
	if (i) {
		//如果二进制长度不是4的整数倍
		while (i--) {
			current = (current << 1) | (*inStr - '0');
			inStr++;
		}
		*outStr = hex[(int) current];
		++outStr;
	}
	while (len--)  //后续的长度为4的整数倍
	{
		current = 0;
		for (i = 0; i < 4; ++i) {
			current = (current << 1) | (*inStr - '0');
			inStr++;
		}
		*outStr = hex[(int) current];
		++outStr;
	}
	*outStr = 0; //加结束符
	return true;
}

/**
*功能：十六进制串转二进制串
*/
bool hexToBinary(const char *inStr, char *outStr) {
	int inlen = strlen(inStr);
	int len = 0;
	for (int i = 0; i < inlen; inStr++, i++) {
		char a = *inStr;
		len = strlen(outStr);
		//memccpy(outStr + 4, var, len, len + 4);
		switch (a) {
		case '0':
			memcpy(outStr + len, "0000", 4);
			break;
		case '1':
			memcpy(outStr + len, "0001", 4);
			break;
		case '2':
			memcpy(outStr + len, "0010", 4);
			break;
		case '3':
			memcpy(outStr + len, "0011", 4);
			break;
		case '4':
			memcpy(outStr + len, "0100", 4);
			break;
		case '5':
			memcpy(outStr + len, "0101", 4);
			break;
		case '6':
			memcpy(outStr + len, "0110", 4);
			break;
		case '7':
			memcpy(outStr + len, "0111", 4);
			break;
		case '8':
			memcpy(outStr + len, "1000", 4);
			break;
		case '9':
			memcpy(outStr + len, "1001", 4);
			break;
		case 'A':
        case 'a':
			memcpy(outStr + len, "1010", 4);
			break;
		case 'B':
		case 'b':
			memcpy(outStr + len, "1011", 4);
			break;
		case 'C':
		case 'c':
			memcpy(outStr + len, "1100", 4);
			break;
		case 'D':
		case 'd':
			memcpy(outStr + len, "1101", 4);
			break;
		case 'E':
		case 'e':
			memcpy(outStr + len, "1110", 4);
			break;
		case 'F':
		case 'f':                
			memcpy(outStr + len, "1111", 4);
			break;
		}
	}
	return true;
}

//功能描述：把字节进制转换为16进制
int byte2hex(const unsigned char *input, unsigned long inlen, unsigned char *output, unsigned long *outlen)
{
	unsigned long i = 0;
	unsigned char *p = output;
	if (*outlen < inlen * 2)
	{
		*outlen = inlen * 2;
		return -1;
	}
	for (i = 0; i<inlen; ++i)
	{
		*p++ = num[input[i] >> 4];
		*p++ = num[input[i] & 0x0F];
	}
	*outlen = p - output;
	return 0;
}
//功能描述：把16进制转换为字节
int hex2byte(const unsigned char *input, unsigned long inlen, unsigned char *output, unsigned long *outlen)
{
	unsigned long i = 0, q = 0;
	if (inlen % 2 != 0)
		return -1;
	if (*outlen < inlen / 2)
	{
		*outlen = inlen / 2;
		return -1;
	}
	for (q = 0; q<inlen; q += 2)
	{
		output[i] = char2num(input[q]) << 4;
		output[i++] |= char2num(input[q + 1]);
	}
	*outlen = i;
	return 0;
}


int pubf_str_str2hex(unsigned char *str, unsigned char *hex, int str_len)
{
	printf("len = %d\n", str_len);
	for (int i = 0; i < str_len; ++i)
	{
		sprintf((char *)hex + 2 * i, "%02X", str[i]);
	}
	return 0;
}
int pubf_str_hex2str(unsigned char *hex, unsigned char *str, int str_len)
{
	printf("len = %d\n", str_len);
	unsigned char tmp_buf[3] = { 0 };
	for (int i = 0; i < str_len; ++i)
	{
		memcpy(tmp_buf, hex + i * 2, 2);
		str[i] = strtol((char *)tmp_buf, NULL, 16);
		printf("%d\n", str[i] );
	}
	return 0;
}

/***********
功能：打印二进制数组
*************/
void PrintBuf(unsigned char * buf, int	buflen) {
#if 1
	int i;
	printf("len = %d\n", buflen);
	for (i = 0; i<buflen; i++) {
		if (i % 32 != 31)
			printf("%02x,", buf[i]);
		else
			printf("%02x\n,", buf[i]);

	}
	printf("\n");
	return;
#endif
}


/************
功能：bcd->asc
****************/
int iBcdToAsc(char *pcBCD, char *pcASC, int iLength){
	int i;
	for (i = 0; i<iLength; i++){
		unsigned char ch;
		ch = (unsigned char)pcBCD[i];
		ch = ch >> 4;
		if (ch >= 10){
			pcASC[2 * i] = ch - 10 + 'A';
		}
		else{
			pcASC[2 * i] = ch + '0';
		}
		ch = (unsigned char)pcBCD[i];
		ch = ch & 0x0f;
		if (ch >= 10){
			pcASC[2 * i + 1] = ch - 10 + 'A';
		}
		else{
			pcASC[2 * i + 1] = ch + '0';
		}
	}
	return(0);
}
/***********
功能：asc->bcd
*************/
int iAscToBcd(char *pcASC, char *pcBCD, int iLength){
	int i;
	for (i = 0; i<iLength / 2; i++){
		unsigned char ch1, ch2;
		ch1 = (unsigned char)pcASC[i * 2];
		ch2 = (unsigned char)pcASC[i * 2 + 1];
		if (ch1 >= 'a' && ch1 <= 'f')
			ch1 = ch1 - 'a' + 0xa;
		else if (ch1 >= 'A' && ch1 <= 'F')
			ch1 = ch1 - 'A' + 0xa;
		else
			ch1 = ch1 - '0';
		if (ch2 >= 'a' && ch2 <= 'f')
			ch2 = ch2 - 'a' + 0xa;
		else if (ch2 >= 'A' && ch2 <= 'F')
			ch2 = ch2 - 'A' + 0xa;
		else
			ch2 = ch2 - '0';
		pcBCD[i] = (ch1 << 4) | ch2;
	}
	return(0);
}


// http://hxwm1a1.blog.163.com/blog/static/5183012010921111336775/

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
            chTemp = chTemp & 0xF0 | (Src[i] & 0x0F);
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


