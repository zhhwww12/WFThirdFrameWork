//
//  Util.h
//  ReadBook
//
//  Created by 吴付伟 on 14-8-4.
//  Copyright (c) 2014年 glodon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PwdCheckResult)
{
    PwdCheckResult_EmptyInput=0,
    PwdCheckResult_TooShort=1,
    PwdCheckResult_TooLong=2,
    PwdCheckResult_OnlyNum=3,
    PwdCheckResult_OnlyAbc=4,
    PwdCheckResult_SameChar=5,
    PwdCheckResult_IllegalChar=6,
    PwdCheckResult_OK=99
};

@interface Util : NSObject
+ (UIViewController *)appRootViewController;
+ (NSString*)genNeedTimeBy1970Time:(double)_time;
+ (CGFloat)liuhaiHeight;
+ (CAGradientLayer*)gradientColorView:(CALayer*)layer CGcolorAy:(NSArray*)cgColorAy;
+ (BOOL)isValidateEmail:(NSString *)email;
+ (NSString*)urlEncodedString:(NSString *)string;
+ (NSString*)getNowTimeString;
+ (BOOL)stringNotNull:(NSString *)string;
+ (BOOL)objectIsValidate:(id)object;
+(BOOL)kDeviceIsiPhoneX;
+ (PwdCheckResult)passwordCheck:(NSString *)password;
+ (NSString*)signWithParmAy:(NSMutableArray*)params;
+ (NSString*)signWithParmDic:(NSDictionary*)params;
+ (BOOL)setDefaultObject:(id)object forkey:(NSString*)key;
+ (id)getDefaultforkey:(NSString*)key;
+ (void)registerPushToken;
+(NSString *)dateToOld:(NSString *)birth;
//手机号中间四位*显示
+(NSString *)hideSomePhoneNum:(NSString*)phoneNum;
+ (NSInteger)lengthOfbytesFromString:(NSString *)string;
+ (BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime;
+ (BOOL)validateTime:(NSTimeInterval)time isInHours:(CGFloat)hours;
+ (void)phoneCall:(NSString *)phoneNumber;
@end
