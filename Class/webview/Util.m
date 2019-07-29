//
//  Util.m
//  ReadBook
//
//  Created by 吴付伟 on 14-8-4.
//  Copyright (c) 2014年 glodon. All rights reserved.
//



#import "Util.h"
#import "Util+UIview.h"
#import "MD5Utility.h"

#define CFG_Key_Sign @"9JVDQ82L6S0DOA67Q0LUVS6MGJLM41R0"

//密码判断相关
#define PwdLengthMin 6
#define PwdLengthMax 20


@implementation Util
+ (UIViewController *)appRootViewController
{
    UIWindow *keyWindow = [Util getRootWindow];
    UIViewController *vc = keyWindow.rootViewController;
    UIViewController * tempVc = nil;
    while (vc)
    {
        tempVc = vc;
        
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = [(UINavigationController *)vc visibleViewController];
        }
        else if ([vc isKindOfClass:[UITabBarController class]])
        {
            vc = [(UITabBarController *)vc selectedViewController];
        }
        else
        {
            vc = vc.presentedViewController;
        }
        
    }
    return tempVc;
}
+ (NSString*)genNeedTimeBy1970Time:(double)_time
{
    NSString* result = nil;
    
    
    
    const int aminu = 60 * 60 ;
    const int aday  = 24 * aminu;
    
    //获取到现在时间
    NSDate* nowtime = [NSDate date];
    
    time_t  t;
    //struct tm  *tp;
    
    t = [nowtime timeIntervalSince1970];
    //tp = localtime(&t);
    
    //当天时间
    time_t cu_t = t;
    struct tm* current_day_tp;
    current_day_tp = localtime(&cu_t);
    current_day_tp->tm_min = 0;
    current_day_tp->tm_sec = 0;
    current_day_tp->tm_hour = 0;
    cu_t = mktime(current_day_tp);
    
    
    //昨天前时间
    time_t yestoday_t = t - aday;
    struct tm* yesday_day_tp;
    yesday_day_tp = localtime(&yestoday_t);
    yesday_day_tp->tm_min = 0;
    yesday_day_tp->tm_sec = 0;
    yesday_day_tp->tm_hour = 0;
    yestoday_t = mktime(yesday_day_tp);
    
    //七天前时间
    time_t sevenday_t = t - (7*aday);
    struct tm* seven_day_tp;
    seven_day_tp = localtime(&sevenday_t);
    seven_day_tp->tm_min = 0;
    seven_day_tp->tm_sec = 0;
    seven_day_tp->tm_hour = 0;
    sevenday_t = mktime(seven_day_tp);
    
    //今年时间
    time_t theyear_t = t;
    struct tm* theyear_day_tp;
    theyear_day_tp = localtime(&theyear_t);
    theyear_day_tp->tm_min = 0;
    theyear_day_tp->tm_sec = 0;
    theyear_day_tp->tm_hour = 0;
    theyear_day_tp->tm_mon = 0;
    theyear_day_tp->tm_mday = 1;
    theyear_day_tp->tm_mon = 0;
    theyear_t = mktime(theyear_day_tp);
    
    
    // 转化为NSDate
    NSDate* ct = [[NSDate alloc] initWithTimeIntervalSince1970:_time];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    if( _time>theyear_t )
    {
        //今年
        [formatter setDateFormat:@"MM-dd HH:mm"];
        result = [formatter stringFromDate:ct];
        
        if( _time > cu_t )
        {
            //当天
            [formatter setDateFormat:@"HH:mm"];
            result = [formatter stringFromDate:ct];
        }
        else if( _time > yestoday_t  )
        {
            //昨天
            [formatter setDateFormat:@"HH:mm"];
            result = [formatter stringFromDate:ct];
            result = [NSString stringWithFormat:@"昨天%@",result];
            
        }
        else if ( _time > sevenday_t && _time <= yestoday_t )
        {
            //七天前
            [formatter setDateFormat:@"HH:mm"];
            result = [formatter stringFromDate:ct];
            
            time_t msgtime = _time;
            struct tm* msgtime_tp = localtime(&msgtime);
            
            NSString* prx = @"";
            switch (msgtime_tp->tm_wday) {
                case 0:
                    prx = @"周日";
                    break;
                case 1:
                    prx = @"周一";
                    break;
                case 2:
                    prx = @"周二";
                    break;
                case 3:
                    prx = @"周三";
                    break;
                case 4:
                    prx = @"周四";
                    break;
                case 5:
                    prx = @"周五";
                    break;
                case 6:
                    prx = @"周六";
                    break;
                    
                    
                default:
                    break;
            }
            result = [NSString stringWithFormat:@"%@%@",prx,result];
        }
        
        
    }
    else
    {
        //以前
        [formatter setDateFormat:@"YY-MM-dd HH:mm"];
        result = [formatter stringFromDate:ct];
    }
    

    return result;
}
+ (CGFloat)liuhaiHeight
{
    CGFloat liuhaiHeight = 0;
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if(@available(iOS 11.0, *))
    {
        inset = UIApplication.sharedApplication.windows[0].safeAreaInsets;
    }
    liuhaiHeight = inset.top==0?0:20;
    return liuhaiHeight;
}
//上下渐变
+ (CAGradientLayer*)gradientColorView:(CALayer*)layer CGcolorAy:(NSArray*)cgColorAy
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = cgColorAy;
    gradientLayer.locations = @[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.frame = layer.bounds;
    [layer insertSublayer:gradientLayer atIndex:0];
    return gradientLayer;
}
/*邮箱验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateEmail:(NSString *)email
{
    if (email.length==0)
    {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+ (NSString*)urlEncodedString:(NSString *)string
{
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    
    return encodedString;
}
+ (NSString*)getNowTimeString
{
    NSDate *date1 = [NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setTimeStyle:NSDateFormatterShortStyle];
    [formatter1 setDateFormat:@"YYYYMMddhhmmss"];
    NSString *DateTime1 = [formatter1 stringFromDate:date1];
    return DateTime1;
}
//字符串非空判断
+ (BOOL)stringNotNull:(NSString *)string
{
    return (string!=nil&&
            ![string isKindOfClass:[NSNull class]]&&
            string!=NULL&&
            [string isKindOfClass:[NSString class]]&&
            string.length>0&&
            ![string isEqualToString:@""]&&
            ![[string lowercaseString] isEqualToString:@"<null>"]&&
            ![[string lowercaseString] isEqualToString:@"null"]&&
            ![[string lowercaseString] isEqualToString:@"(null)"]);
}
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
+(BOOL)kDeviceIsiPhoneX
{
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if(@available(iOS 11.0, *))
    {
        inset = UIApplication.sharedApplication.windows[0].safeAreaInsets;
        if(inset.top <= 20 )
        {
            return NO;
        }
        return YES;
    }
    else
    {
        return  NO;
    }
    return NO;
}
#pragma mark- 密码判断

+ (PwdCheckResult)passwordCheck:(NSString *)password
{
    if (![self stringNotNull:password])
    {
        NSLog(@"输入为空");
        return PwdCheckResult_EmptyInput;
    }
    
    if (password.length<PwdLengthMin)
    {
        NSLog(@"输入太短");
        return PwdCheckResult_TooShort;
    }
    
    if (password.length>PwdLengthMax)
    {
        NSLog(@"输入太长");
        return PwdCheckResult_TooLong;
    }
    
    //需要正则表达式匹配的规则
    NSRegularExpression *regex;
    NSRange rangeResult;
    
    //只有字母
    NSString *regexFormatString_Chars=@"[a-zA-Z0-9]+";
    regex=[NSRegularExpression regularExpressionWithPattern:regexFormatString_Chars options:0 error:NULL];
    rangeResult=[regex rangeOfFirstMatchInString:password options:0 range:NSMakeRange(0, password.length)];
    if (rangeResult.length!=password.length)
    {
        NSLog(@"含有非法字符");
        return PwdCheckResult_IllegalChar;
    }
    
    //只有字母
    NSString *regexFormatString_OnlyAbc=@"[a-zA-Z]+";
    regex=[NSRegularExpression regularExpressionWithPattern:regexFormatString_OnlyAbc options:0 error:NULL];
    rangeResult=[regex rangeOfFirstMatchInString:password options:0 range:NSMakeRange(0, password.length)];
    if (rangeResult.length==password.length)
    {
        NSLog(@"只有字母");
        return PwdCheckResult_OnlyAbc;
    }
    
    //只有数字
    NSString *regexFormatString_OnlyNum=@"[0-9]+";
    regex=[NSRegularExpression regularExpressionWithPattern:regexFormatString_OnlyNum options:0 error:NULL];
    rangeResult=[regex rangeOfFirstMatchInString:password options:0 range:NSMakeRange(0, password.length)];
    if (rangeResult.length==password.length)
    {
        NSLog(@"只有数字");
        return PwdCheckResult_OnlyNum;
    }
    
    NSLog(@"密码可用");
    return PwdCheckResult_OK;
}
#pragma mark- 计算参数的签名

+ (NSString*)signWithParmAy:(NSMutableArray*)params
{
    //加入一个MD5校验参数
    NSMutableArray *paramsStringArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableArray *paramsDictArray=[[NSMutableArray alloc] initWithArray:params];
    [paramsDictArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1=[[((NSDictionary *)obj1) allKeys] objectAtIndex:0];
        NSString *str2=[[((NSDictionary *)obj2) allKeys] objectAtIndex:0];
        return [str1 compare:str2];
    }];
    
    for (NSDictionary *dict in paramsDictArray)
    {
        NSString *paramString=[NSString stringWithFormat:@"%@%@", [[dict allKeys] objectAtIndex:0], [[dict allValues] objectAtIndex:0]];
        [paramsStringArray addObject:paramString];
    }
    
    NSString *allParamsString=@"";
    for (NSDictionary *dict in params)
    {
        if ([[[dict allKeys] objectAtIndex:0] isEqualToString:@"method"])
        {
            allParamsString=[dict valueForKey:@"method"];
        }
    }
    
    for (NSString *string in paramsStringArray)
    {
        allParamsString=[allParamsString stringByAppendingString:string];
    }
    
    allParamsString=[allParamsString stringByAppendingString:CFG_Key_Sign];
    
    NSString *paramsStringToMD5String=[MD5Utility md5:allParamsString];
    
    return [paramsStringToMD5String uppercaseString];
}
+ (NSString*)signWithParmDic:(NSDictionary*)params
{
    //加入一个MD5校验参数
    NSMutableArray *paramsStringArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableArray *paramskeyArray=[[NSMutableArray alloc] initWithArray:params.allKeys];
    [paramskeyArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    
    for (NSString *key in paramskeyArray)
    {
        NSString *paramString=[NSString stringWithFormat:@"%@%@",key, [params objectForKey:key]];
        [paramsStringArray addObject:paramString];
    }
    
    NSString *allParamsString= [NSString stringWithFormat:@"%@",[params objectForKey:@"method"]];
    for (NSString *string in paramsStringArray)
    {
        allParamsString=[allParamsString stringByAppendingString:string];
    }
    allParamsString=[allParamsString stringByAppendingString:CFG_Key_Sign];
    
    NSString *paramsStringToMD5String=[MD5Utility md5:allParamsString];
    
    return [paramsStringToMD5String uppercaseString];
}
+ (BOOL)setDefaultObject:(id)object forkey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    return  [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (id)getDefaultforkey:(NSString*)key
{
    id object =  [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return object;
}
+ (void)registerPushToken
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    
    
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        
    }
}
+(NSString *)dateToOld:(NSString *)birth{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    //获得当前系统时间
    NSDate *currentDate = [NSDate date];
    //获得当前系统时间与出生日期之间的时间间隔
    NSTimeInterval time = [currentDate timeIntervalSinceDate:birthDay];
    //时间间隔以秒作为单位,求年的话除以60*60*24*356
    int age = ((int)time)/(3600*24*365);
    return [NSString stringWithFormat:@"%d",age];
}

+(NSString *)hideSomePhoneNum:(NSString*)phoneNum
{
    NSString *subPhoneNum = @"";
    if (phoneNum.length == 11)
    {
        NSRange phoneRange = NSMakeRange(3, 4);
        NSString *subStr = [phoneNum substringWithRange:phoneRange];
        NSString *subPhone = [phoneNum stringByReplacingOccurrencesOfString:subStr withString:@"****"];
        subPhoneNum = subPhone;
    }else
    {
        subPhoneNum = phoneNum;
    }
    return subPhoneNum;
}
#pragma mark- 计算字符串的半角长度，每个全角字符返回2，每个半角字符返回1

+ (NSInteger)lengthOfbytesFromString:(NSString *)string
{
    NSString *targetString=[NSString stringWithString:string];
    
    NSString *regexFormatStringDouble=@"[^\\x00-\\xff]";
    
    BOOL matched=YES;
    
    while (matched==YES)
    {
        matched=NO;
        
        NSError *error;
        NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:regexFormatStringDouble options:0 error:&error];
        NSRange rangeResult=[regex rangeOfFirstMatchInString:targetString options:0 range:NSMakeRange(0, targetString.length)];
        if (rangeResult.length>0)
        {
            matched=YES;
            targetString=[targetString stringByReplacingCharactersInRange:rangeResult withString:@"aa"];
        }
    }
    
    return targetString.length;
}
/**
 *  判断当前时间是否处于某个时间段内
 *
 *  @param startTime        开始时间
 *  @param expireTime       结束时间
 */

+ (BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime
{
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
    
    NSDate *start = [dateFormat dateFromString:startTime];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}
/**
 *  判断某个时间是否处于距现在时间多少小时内
 *
 *  @param time        时间点
 *  @param hours       距现在的时间
 */
+ (BOOL)validateTime:(NSTimeInterval)time isInHours:(CGFloat)hours
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval nowtTime=[dat timeIntervalSince1970];
    NSTimeInterval oldTime = nowtTime-hours*60*60;
    if(time<nowtTime&&time>oldTime)
    {
        return YES;
    }
    return NO;
}
+ (void)phoneCall:(NSString *)phoneNumber
{
    NSString *string=[NSString stringWithFormat:@"%@", phoneNumber];
    if (![self stringNotNull:string])
    {
        return;
    }

    NSString *phoneNumberString=[NSString stringWithFormat:@"%@", phoneNumber];
    phoneNumberString=[phoneNumberString stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumberString=[phoneNumberString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNumberString=[phoneNumberString stringByReplacingOccurrencesOfString:@"*" withString:@""];
    phoneNumberString=[phoneNumberString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    NSString *callingNumber = [@"tel://" stringByAppendingString:phoneNumberString];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callingNumber]];
}
@end
