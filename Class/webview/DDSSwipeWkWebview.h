//
//  DDSSwipeWkWebview.h
//  DingDangShop
//
//  Created by 仁和 on 2017/5/26.
//  Copyright © 2017年 WorkGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WebViewDelegate.h"

@interface DDSSwipeWkWebview : UIView
{
    CGFloat panX;
    UIPanGestureRecognizer  *swipeRight;
    NSMutableArray * captureWebViewAy;
    BOOL backTag;
    
    //不通用
    NSMutableArray * jsMethondDicAy;
    
    NSMutableArray * webToNavDicAy;
    
    WKNavigation * backNavigation;
    
}

@property(nonatomic,retain)WKWebView * _Nullable swipeWebView;
@property(nonatomic,retain)UIImageView * _Nullable backImageView;

@property(nullable,nonatomic,assign)id<WebViewDelegate>swipeDelegate;

//加载url
- (void)loadUrlString:(NSString*_Nullable)urlString cachePolicy:(NSURLRequestCachePolicy)cachePolicy;
/*
 解决和系统返回手势冲突的问题
 */
//加入手势
- (void)addPanGes;
//取消手势
- (void)removePanGes;
/*
 必须调用这个方法，就行网页的返回
 */
//网页返回方法
- (void)goBack;


/*
 加载空白页
 */
//加载空白页
- (void)loadBlankPage;
- (void)execJsString:(NSString*_Nullable)jsString;
- (void)clearWebVieCache;
@end
