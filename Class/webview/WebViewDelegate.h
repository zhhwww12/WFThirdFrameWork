//
//  WebViewDelegate.h
//  DingDangShop
//
//  Created by 仁和 on 2017/5/26.
//  Copyright © 2017年 WorkGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@protocol WebViewDelegate <NSObject>

@optional
/*
 wkwebview delegate
 
 */
- (void)swipewebView:(WKWebView *_Nullable)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
- (void)swipewebView:(WKWebView *_Nullable)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
- (void)swipewebView:(WKWebView *_Nullable)webView decidePolicyForNavigationAction:(WKNavigationAction *_Nullable)navigationAction decisionHandler:(void (^_Nullable)(WKNavigationActionPolicy))decisionHandler;
- (nullable WKWebView *)swipewebView:(WKWebView *_Nullable)webView createWebViewWithConfiguration:(WKWebViewConfiguration *_Nullable)configuration forNavigationAction:(WKNavigationAction *_Nullable)navigationAction windowFeatures:(WKWindowFeatures *_Nullable)windowFeatures;
- (void)SswipeWebView:(WKWebView *_Nullable)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *_Nullable)error;
@end
