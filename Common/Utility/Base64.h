//
//  Base64.h
//  CryptTest
//
//  Created by Kiichi Takeuchi on 4/20/10.
//  Copyright 2010 ObjectGraph LLC. All rights reserved.
// 
// Original Source Code is donated by Cyrus
// Public Domain License
// http://www.cocoadev.com/index.pl?BaseSixtyFour

/**
 encode as:
 
 NSData* data = UIImageJPEGRepresentation(yourImage, 1.0f);
 [Base64 initialize];
 NSString *strEncoded = [Base64 encode:data];
 
 
 Decode as:
 
 [Base64 initialize];
 NSData* data = [Base64 decode:strEncoded ];
 image.image = [UIImage imageWithData:data];
 
 
 **/

#import <Foundation/Foundation.h>


@interface Base64 : NSObject {

}

+ (void) initialize;

+ (NSString*) encode:(const uint8_t*) input length:(NSInteger) length;

+ (NSString*) encode:(NSData*) rawBytes;

+ (NSData*) decode:(const char*) string length:(NSInteger) inputLength;

+ (NSData*) decode:(NSString*) string;

@end
