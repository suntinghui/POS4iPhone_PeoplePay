//
//  NSData+NSString.m
//  Demo
//
//  Created by  STH on 11/9/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "NSData+NSString.h"

@implementation  NSData (NSString)

- (NSString *)toString
{
    Byte *dataPointer = (Byte *)[self bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSUInteger index;
    for (index = 0; index < [self length]; index++)
    {
        //[result appendFormat:@"0x%02x,", dataPointer[index]];
        [result appendFormat:@"%02X ", dataPointer[index]];
    }
    return result;
}

@end
