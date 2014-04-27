//
//  FileManagerUtil.h
//  LKOA4iPhone
//
//  Created by  STH on 8/1/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManagerUtil : NSObject

+ (BOOL) fileExistWithName:(NSString *) fileName;

+ (BOOL) deleteFileWithName:(NSString *) fileName;

+ (void) showFileContent:(UIViewController *) parentController withFileName:(NSString *) fileName;

+ (NSArray*) allFilesAtPath;

+ (void) deleteAllFiles;

@end
