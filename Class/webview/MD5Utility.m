//
//  MD5Utility.m
//  MD5Test
//
//  Created by Alexander on 14-12-16.
//  Copyright (c) 2014年 WorkGroup. All rights reserved.
//

#import "MD5Utility.h"

#import <CommonCrypto/CommonDigest.h>

@implementation MD5Utility

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [hash appendFormat:@"%02X",result[i]];
    }
    
    return [hash lowercaseString];
}

#define CHUNK_SIZE 1024

+ (NSString *)file_md5:(NSString *)path
{
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    if(handle == nil)
    {
        return nil;
    }
    
    CC_MD5_CTX md5_ctx;
    CC_MD5_Init(&md5_ctx);
    
    NSData* filedata;
    
    while([filedata length])
    {
        filedata = [handle readDataOfLength:CHUNK_SIZE];
        CC_MD5_Update(&md5_ctx, [filedata bytes], (CC_LONG)[filedata length]);
    }
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(result, &md5_ctx);
    
    [handle closeFile];
    
    NSMutableString *hash = [NSMutableString string];
    
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [hash appendFormat:@"%02x",result[i]];
    }
    
    return [hash lowercaseString];  
    
}

@end
