//
//  StaticTools.h
//  Mlife
//
//  Created by xuliang on 12-12-27.
//
//

#import <Foundation/Foundation.h>


#define OUT_LOG	//正式版本可以删除

#ifdef OUT_LOG
#define OutLog(format, ...) NSLog(format, ##__VA_ARGS__)
#else
#define OutLog(format, ...)
#endif
#pragma mark 设备环境


@interface StaticTools : NSObject
{
}

@end


