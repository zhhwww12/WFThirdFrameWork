//
//  WebViewManger.h
//  ThirdFrameWorks
//
//  Created by 仁和 on 2019/3/18.
//  Copyright © 2019 wfw. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


#pragma mark - webViewManger protocol

@protocol handleMessageProtocol <NSObject>

@optional
- (void)handH5MessageCode:(NSNumber*)code message:(NSString*)jsonStriing;
- (NSString*)handNativeToH5PromptValue:(NSString*)Prompt defaultText:(NSString*)defaultText;

@end



@interface WebViewManger : NSObject


@property(nullable, nonatomic,strong)id <handleMessageProtocol> handMessage;

+ (WebViewManger*)webViewEngine;
- (void)regiesthandMessageObject:(id<handleMessageProtocol>)object;
@end

NS_ASSUME_NONNULL_END
