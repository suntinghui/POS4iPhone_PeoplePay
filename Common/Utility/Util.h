#ifndef _UTIL_H
#define _UTIL_H

#define GBKENC (CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000))

#define char2num(in) ((in > '9') ? (in - 'A' + 10) : (in - '0'))
	
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned long u32;
typedef unsigned long long u64;

#ifdef __cplusplus
extern "C" {
#endif
	
/***********
功能：打印二进制数组
*************/
  void PrintBufx(unsigned char * buf, int	buflen) ;
/***********
功能：右补0
    word
*************/
int strRegihtFill(char * src, char * dest,char  word,  int length);
/***********
功能：左补0
*************/
int strLeftFill(char * src, char * dest,char  word,  int length);

/**
 * 字符串反转
 */
char *reverse(char *str);


//函 数 名：AscToHex()
//功能描述：把ASCII转换为16进制
unsigned char AscToHex(unsigned char aHex);


//函 数 名：HexToAsc()
//功能描述：把16进制转换为ASCII
unsigned char HexToAsc(unsigned char aChar);

/**
*功能：二进制串转十六进制串
*/
bool binaryToHex(const char *inStr, char *outStr);

/**
*功能：十六进制串转二进制串
*/
bool hexToBinary(const char *inStr, char *outStr);

//功能描述：把字节进制转换为16进制
int byte2hex(const unsigned char *input, unsigned long inlen, unsigned char *output, unsigned long *outlen);

//功能描述：把16进制转换为字节
int hex2byte(const unsigned char *input, unsigned long inlen, unsigned char *output, unsigned long *outlen);


int pubf_str_str2hex(unsigned char *str, unsigned char *hex, int str_len);

int pubf_str_hex2str(unsigned char *hex, unsigned char *str, int str_len);
/***********
功能：打印二进制数组
*************/
void PrintBuf(unsigned char * buf, int	buflen) ;


/************
功能：bcd->asc
****************/
int iBcdToAsc(char *pcBCD, char *pcASC, int iLength);

/***********
功能：asc->bcd
*************/
int iAscToBcd(char *pcASC, char *pcBCD, int iLength);

#ifdef __cplusplus
}
#endif

#endif
