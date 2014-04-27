//
//  FileManagerUtil.m
//  LKOA4iPhone
//
//  Created by  STH on 8/1/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "FileManagerUtil.h"

@implementation FileManagerUtil

+ (BOOL) fileExistWithName:(NSString *) fileName
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (BOOL) deleteFileWithName:(NSString *) fileName
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    return NO;
}

+ (NSArray*) allFilesAtPath
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (NSString* fileName in tempArray) {
        BOOL flag = YES;
        NSString* fullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [array addObject:fullPath];
            }
        }
    }
    return array;
}

+ (void) deleteAllFiles
{
    for (NSString *path in [self allFilesAtPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

+ (void) showFileContent:(UIViewController *) parentController withFileName:(NSString *) fileName
{
//    ShowContentViewController *vc = [[ShowContentViewController alloc] initWithFileName:fileName];
//    [parentController.navigationController pushViewController:vc animated:YES];
}



@end
