//
//  MD5Utility.h
//  MD5Test
//
//  Created by Alexander on 14-12-16.
//  Copyright (c) 2014年 WorkGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5Utility : NSObject

+ (NSString *)md5:(NSString *)str;
+ (NSString *)file_md5:(NSString *)path;

@end
