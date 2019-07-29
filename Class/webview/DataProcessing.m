//
//  DataProcessing.m
//  ReadBook
//
//  Created by 仁和 on 15/8/4.
//  Copyright (c) 2015年 glodon. All rights reserved.
//

#import "DataProcessing.h"

@implementation DataProcessing

+ (BOOL)objectIsValidate:(id)object
{
    if (object==nil || object==NULL||([object isKindOfClass: [NSString class]]&&[object isEqualToString:@""]))
    {
        return NO;
    }
    return ([object isKindOfClass:[NSString class]]||
            [object isKindOfClass:[NSArray class]]||
            [object isKindOfClass:[NSMutableArray class]]||
            [object isKindOfClass:[NSDictionary class]]||
            [object isKindOfClass:[NSMutableDictionary class]]||
            [object isKindOfClass:[NSData class]]||
            [object isKindOfClass:[NSNumber class]]);
}
//生成数组
+(NSArray *)parseArrayObject:(id)_ori
{
    if (_ori==nil || [_ori isKindOfClass:[NSNull class]] || ![_ori isKindOfClass:[NSArray class]])
    {
        return @[];
    }
    return _ori;
}

//生成字典
+(NSDictionary *)parseDictionaryObject:(id)_ori
{
    if (_ori==nil || [_ori isKindOfClass:[NSNull class]] || ![_ori isKindOfClass:[NSDictionary class]])
    {
        return @{@"NoKey" : @"NoValue"};
    }
    return _ori;
}

//生成string数据  会有些冗余命令，不过为了防御！
+(NSString *)parseStringValue:(id)_ori autoFillString:(NSString *)_str
{
    if (_ori==nil || _ori==NULL)
    {
        //if (_str!=nil && _str!=NULL)
        if ([self stringNotNull:_str])
        {
            return _str;
        }
        else
        {
            return @"";
        }
    }
    
    NSString *getString=[NSString stringWithFormat:@"%@",_ori];
    
    if (![[self class] stringNotNull:getString])
    {
        if ([[self class] stringNotNull:_str])
        {
            return _str;
        }
        else
        {
            return @"";
        }
    }
    return getString;
}

//生成int数据
+ (NSInteger)parseIntegerValue:(id)_ori
{
    if (_ori==nil || [_ori isKindOfClass:[NSNull class]])
    {
        return 0;
    }
    else if ([_ori isKindOfClass:[NSString class]])
    {
        if ([_ori isEqualToString:@""])
        {
            return 0;
        }
    }
    return [_ori integerValue];
}

//生成long数据
+ (long)parseLongIntValue:(id)_ori
{
    if (_ori==nil || [_ori isKindOfClass:[NSNull class]])
    {
        return 0;
    }
    else if ([_ori isKindOfClass:[NSString class]])
    {
        if ([_ori isEqualToString:@""])
        {
            return 0;
        }else{
            return [_ori integerValue];
        }
    }
    return [_ori longValue];
}

//生成long long数据
+ (long long)parseLongLongIntValue:(id)_ori
{
    if (_ori==nil || [_ori isKindOfClass:[NSNull class]])
    {
        return 0;
    }
    else if ([_ori isKindOfClass:[NSString class]])
    {
        if ([_ori isEqualToString:@""])
        {
            return 0;
        }
    }
    return [_ori longLongValue];
}

//生成float数据
+(float)parseFloatValue:(id)_ori
{
    if (_ori==nil || [_ori isKindOfClass:[NSNull class]])
    {
        return 0.0;
    }
    else if ([_ori isKindOfClass:[NSString class]])
    {
        if ([_ori isEqualToString:@""])
        {
            return 0.0;
        }
    }
    return [_ori floatValue];
}

//生成double数据
+ (double)parseDoubleValue:(id)_ori
{
    if (_ori==nil || [_ori isKindOfClass:[NSNull class]])
    {
        return 0.0;
    }
    else if ([_ori isKindOfClass:[NSString class]])
    {
        if ([_ori isEqualToString:@""])
        {
            return 0.0;
        }
    }
    return [_ori doubleValue];
}

//生成时间double数据
+ (NSTimeInterval)parseTimeStampValue:(id)_ori
{
    if (_ori==nil || [_ori isKindOfClass:[NSNull class]])
    {
        return 0.0;
    }
    else if ([_ori isKindOfClass:[NSString class]])
    {
        if ([_ori isEqualToString:@""])
        {
            return 0.0;
        }
    }
    else if ([_ori doubleValue]>9999999999.9)//位数转换，超过十位视为毫秒数据，转化为秒
    {
        return [_ori doubleValue]/1000.0;
    }
    return [_ori doubleValue];
}

//生成bool数据
+(BOOL)parseBoolValue:(id)_ori
{
    if (_ori==nil || [_ori isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if ([_ori isKindOfClass:[NSString class]])
    {
        if ([_ori isEqualToString:@"0"] || [[_ori lowercaseString] isEqualToString:@"false"] || [[_ori lowercaseString] isEqualToString:@"no"] || [_ori isEqualToString:@""])//
        {
            return NO;
        }
        else if ([_ori isEqualToString:@"1"] || [[_ori lowercaseString] isEqualToString:@"true"] || [_ori isEqualToString:@"yes"])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if (_ori==NULL)
    {
        return NO;
    }
    return [_ori boolValue];
}

+(BOOL)stringNotNull:(NSString *)string//重要方法，测试无误后替换本类其他判断字符串非空处
{//使用时需要注意，该方法判断字符串非空，并非字符串是否有效，即无效字符串也按空串处理
    return (string!=nil&&
            ![string isKindOfClass:[NSNull class]]&&
            string!=NULL&&
            [string isKindOfClass:[NSString class]]&&
            ![string isEqualToString:@""]&&
            string.length>0&&
            ![[string lowercaseString] isEqualToString:@"<null>"]&&
            ![[string lowercaseString] isEqualToString:@"null"]&&
            ![[string lowercaseString] isEqualToString:@"(null)"]);
}
//生成NSNnumber类型
+ (NSNumber*)parseNumberValue:(id)_ori
{
    if (_ori==nil || [_ori isKindOfClass:[NSNull class]])
    {
        return @0;
    }
    else if ([_ori isKindOfClass:[NSString class]])
    {
        if ([_ori isEqualToString:@""])
        {
            return @0;
        }
    }
    return [NSNumber numberWithInteger:[_ori integerValue]];
}

@end
