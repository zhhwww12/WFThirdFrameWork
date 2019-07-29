//
//  DataProcessing.h
//  ReadBook
//
//  Created by 仁和 on 15/8/4.
//  Copyright (c) 2015年 glodon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProcessing : NSObject
+ (BOOL)objectIsValidate:(id)object;
//生成数组
+ (NSArray *)parseArrayObject:(id)_ori;

//生成字典
+ (NSDictionary *)parseDictionaryObject:(id)_ori;

//生成string数据
+ (NSString *)parseStringValue:(id)_ori autoFillString:(NSString *)_str;

//生成int数据
+ (NSInteger)parseIntegerValue:(id)_ori;

//生成long数据
+ (long)parseLongIntValue:(id)_ori;

//生成long long数据
+ (long long)parseLongLongIntValue:(id)_ori;

//生成float数据
+ (float)parseFloatValue:(id)_ori;

//生成double数据
+ (double)parseDoubleValue:(id)_ori;

//生成时间戳的double数据
+ (NSTimeInterval)parseTimeStampValue:(id)_ori;

//生成bool数据
+ (BOOL)parseBoolValue:(id)_ori;
//生成NSNumber数据
+ (NSNumber*)parseNumberValue:(id)_ori;
+ (BOOL)stringNotNull:(NSString *)string;
@end
