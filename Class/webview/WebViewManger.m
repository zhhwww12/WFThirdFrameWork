//
//  WebViewManger.m
//  ThirdFrameWorks
//
//  Created by 仁和 on 2019/3/18.
//  Copyright © 2019 wfw. All rights reserved.
//

#import "WebViewManger.h"

@interface WebViewManger ()


@end

@implementation WebViewManger

+ (WebViewManger*)webViewEngine;
{
    static dispatch_once_t onceTokenBIMobclock;
    static WebViewManger * g_shareBIMobiclickInstance;
    
    dispatch_once(&onceTokenBIMobclock, ^{
        g_shareBIMobiclickInstance = [[WebViewManger alloc] init];
    });
    return g_shareBIMobiclickInstance;
}
- (void)regiesthandMessageObject:(id<handleMessageProtocol>)object
{
    self.handMessage = object;
}
@end
