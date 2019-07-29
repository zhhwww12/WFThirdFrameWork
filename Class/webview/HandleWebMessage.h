//
//  HandleWebMessage.h
//  DingDangShop
//
//  Created by 仁和 on 2017/6/2.
//  Copyright © 2017年 WorkGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HandleWebMessage : NSObject
+ (void)handH5MessageCode:(NSNumber*)code message:(NSString*)jsonStriing;
+ (NSString*)handNativeToH5PromptValue:(NSString*)Prompt defaultText:(NSString*)defaultText;

@end
