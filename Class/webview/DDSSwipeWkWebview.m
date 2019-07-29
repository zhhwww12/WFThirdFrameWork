//
//  DDSSwipeWkWebview.m
//  DingDangShop
//
//  Created by 仁和 on 2017/5/26.
//  Copyright © 2017年 WorkGroup. All rights reserved.
//

#import "DDSSwipeWkWebview.h"
#import <AdSupport/ASIdentifierManager.h>
#import "DDSSwipeWkWebview+WevViewExtend.h"
#import "UtilSdk.h"
#import "WebViewManger.h"
@interface DDSSwipeWkWebview ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@end

@implementation DDSSwipeWkWebview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        backTag = NO;
        
        WKWebViewConfiguration *configuretion = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preference = [[WKPreferences alloc] init];
        configuretion.preferences = preference;
        
        
        WKUserContentController *contentController = [[WKUserContentController alloc] init];
        

        configuretion.userContentController = contentController;


        NSLog(@"nnnn = %@",contentController.userScripts);
        
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        _swipeWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ([[UIScreen mainScreen]bounds].size.width), frame.size.height) configuration:configuretion];
        _swipeWebView.userInteractionEnabled = YES;
        _swipeWebView.backgroundColor = self.backgroundColor;
        [_swipeWebView.configuration.userContentController addScriptMessageHandler:self name:@"DDKY"];
        
        
        [self addSubview:_swipeWebView];
        
        
        _swipeWebView.UIDelegate = self;
        _swipeWebView.navigationDelegate = self;
        
        swipeRight = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.backImageView.image = [UIImage imageNamed:@"default720"];
        
        [self insertSubview:self.backImageView belowSubview:_swipeWebView];
        
        
        captureWebViewAy = [[NSMutableArray alloc] init];
        
        jsMethondDicAy = [[NSMutableArray alloc] init];
        webToNavDicAy = [[NSMutableArray alloc] init];
        
        
    }
    return self;
}

//加载url
- (void)loadUrlString:(NSString*_Nullable)urlString cachePolicy:(NSURLRequestCachePolicy)cachePolicy
{
    NSString * addressString = urlString;

    NSLog(@"addressString=====%@",addressString);
    [self.swipeWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:addressString] cachePolicy:cachePolicy timeoutInterval:30]];
}
/*
 解决和系统返回手势冲突的问题
 */
//加入手势
- (void)addPanGes
{
    [_swipeWebView addGestureRecognizer:swipeRight];

}
//取消手势
- (void)removePanGes
{
    [_swipeWebView removeGestureRecognizer:swipeRight];
 
}
/*
 必须调用这个方法，就行网页的返回
 */
//网页返回方法
- (void)goBack
{
    backTag = YES;
    [captureWebViewAy removeLastObject];

    backNavigation =  [_swipeWebView goBack];

}
- (void)reloadError
{
    [_swipeWebView reload];

}
/*
 加载空白页
 */
- (void)loadBlankPage
{
    [_swipeWebView evaluateJavaScript:@"document.open();document.close()" completionHandler:^(id object,NSError *error) {
        
    }];

}
-(void)swipe:(UIPanGestureRecognizer *)g{
    
    
    if(_swipeWebView.canGoBack)
    {
        
        UIImage * lastImage = [captureWebViewAy lastObject];
        
        self.backImageView.image = lastImage;
        
        CGPoint location = [g locationInView:self];
        
        
        __weak DDSSwipeWkWebview * weakSelf = self;
        
        
        if(g.state == UIGestureRecognizerStateBegan)
        {
            panX = location.x;
            //背景偏移30
            self.backImageView.frame = CGRectMake(-60, self.backImageView.frame.origin.y, self.backImageView.frame.size.width, self.backImageView.frame.size.height);
        }
        else if (g.state == UIGestureRecognizerStateChanged)
        {
            CGFloat panWidth = location.x-panX;
            panWidth = panWidth>0?panWidth:0;
            
            _swipeWebView.frame = CGRectMake(panWidth, _swipeWebView.frame.origin.y, _swipeWebView.frame.size.width, _swipeWebView.frame.size.height);
            
            CGFloat backWidth = panWidth;
            backWidth = backWidth>([[UIScreen mainScreen]bounds].size.width)?([[UIScreen mainScreen]bounds].size.width):backWidth;
            
            self.backImageView.frame = CGRectMake(-60+backWidth*60/([[UIScreen mainScreen]bounds].size.width), self.backImageView.frame.origin.y, self.backImageView.frame.size.width, self.backImageView.frame.size.height);
        }
        else if(g.state == UIGestureRecognizerStateCancelled||g.state == UIGestureRecognizerStateEnded)
        {
            
            CGFloat panWidth = location.x-panX;
            panWidth = panWidth>0?panWidth:0;
            if(panWidth<=([[UIScreen mainScreen]bounds].size.width)/2)
            {
                
                [UIView animateWithDuration:0.2 animations:^{
                    weakSelf.swipeWebView.frame = CGRectMake(0,  weakSelf.swipeWebView.frame.origin.y,  weakSelf.swipeWebView.frame.size.width,  weakSelf.swipeWebView.frame.size.height);
        
                    
                } completion:^(BOOL finished) {
                    
                    weakSelf.backImageView.frame = CGRectMake(0, weakSelf.backImageView.frame.origin.y, weakSelf.backImageView.frame.size.width, weakSelf.backImageView.frame.size.height);
                }];
                
            }
            else
            {
                [UIView animateWithDuration:0.2 animations:^{
                     weakSelf.swipeWebView.frame = CGRectMake(([[UIScreen mainScreen]bounds].size.width),  weakSelf.swipeWebView.frame.origin.y,  weakSelf.swipeWebView.frame.size.width,  weakSelf.swipeWebView.frame.size.height);
                    
                } completion:^(BOOL finished) {
                    
                    weakSelf.swipeWebView.frame = CGRectMake(0,  weakSelf.swipeWebView.frame.origin.y,  weakSelf.swipeWebView.frame.size.width,  weakSelf.swipeWebView.frame.size.height);
                    weakSelf.backImageView.frame = CGRectMake(0, weakSelf.backImageView.frame.origin.y, weakSelf.backImageView.frame.size.width, weakSelf.backImageView.frame.size.height);
                    
                    [self goBack];
                    
                }];
                
            }
        }
        
    }
    
}


#pragma mark 交互 delegate


- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED>=__IPHONE_9_0
- (void)webViewDidClose:(WKWebView *)webView
{
    
}
#endif
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertView * alter = [[UIAlertView alloc] initWithTitle:message message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alter show];
    completionHandler();
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    completionHandler(YES);
    
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
  
    
    WebViewManger * manger = [WebViewManger webViewEngine];
    
    if([manger.handMessage respondsToSelector:@selector(handNativeToH5PromptValue:defaultText:)])
    {
         NSString * resultString =[manger.handMessage handNativeToH5PromptValue:prompt defaultText:defaultText];
         completionHandler(resultString);

    }
    else
    {
        completionHandler(nil);
    }
}


- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo
API_AVAILABLE(ios(10.0)){
    return YES;
}

- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController
{
    
}


- (void)webView:(WKWebView *)webView runOpenPanelWithParameters:(WKOpenPanelParameters *)parameters initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSArray<NSURL *> * _Nullable URLs))completionHandler
{
    
}


#pragma mark nav 跳转 delegate
/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{

    if([_swipeDelegate respondsToSelector:@selector(swipewebView:decidePolicyForNavigationAction:decisionHandler:)])
    {
        [_swipeDelegate swipewebView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }
    else{
        decisionHandler(WKNavigationActionPolicyAllow);
  
    }

}
//webViewWebContentProcessDidTerminate
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    
}
/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    if(backTag == NO)
    {
        [self captureImage];
    }
    

}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"wkerror = %@",error);
    if([self.swipeDelegate respondsToSelector:@selector(SswipeWebView:didFailProvisionalNavigation:withError:)])
    {
        [self.swipeDelegate SswipeWebView:webView didFailProvisionalNavigation:navigation withError:error];
    }
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
  
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    
    if([navigation isEqual:backNavigation])
    {
        [webView reload];
        backNavigation = nil;
    }
    
    NSString * budlePathString2 = [[NSBundle mainBundle] pathForResource:@"JSIMethond2" ofType:@"js"];
    NSString * jsString2 = [[NSString alloc] initWithContentsOfFile:budlePathString2 encoding:NSUTF8StringEncoding error:nil];
    jsString2 = [jsString2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [self.swipeWebView evaluateJavaScript:jsString2 completionHandler:^(id object,NSError *error) {
        
    }];
    backTag = NO;
    if([_swipeDelegate respondsToSelector:@selector(swipewebView:didFinishNavigation:)])
    {
        [_swipeDelegate swipewebView:webView didFinishNavigation:navigation];
    }
    NSString * iosReadyJSBridge = @"DingDangJSBridgeReady()";
    [self.swipeWebView evaluateJavaScript:iosReadyJSBridge completionHandler:^(id object,NSError *error) {
        
    }];
    
}
// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"%@", message);
    NSDictionary * dic = message.body;
    NSNumber *  idString = [dic objectForKey:@"code"];
    NSString * jsonStriing =[dic objectForKey:@"json"] ;
    WebViewManger * manger = [WebViewManger webViewEngine];
    if([manger.handMessage respondsToSelector:@selector(handH5MessageCode:message:)])
    {
        [manger.handMessage handH5MessageCode:idString message:jsonStriing];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
    NSLog(@"wkwebView error = %@",error);
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    completionHandler(NSURLSessionAuthChallengeUseCredential,[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}
- (void)dealloc
{
    [self.swipeWebView.configuration.userContentController removeScriptMessageHandlerForName:@"DDKY"];
}
- (void)captureImage
{
    if(self.frame.size.height>0&&self.frame.size.width>0)
    {
        UIImage * captureImage = [self getImage];
        [captureWebViewAy addObject:captureImage];
        self.backImageView.image = captureImage;
    }
    
}
- (UIImage*)getImage
{
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,YES, [[UIScreen mainScreen] scale]);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)execJsString:(NSString*)jsString
{
    [self.swipeWebView evaluateJavaScript:jsString completionHandler:^(id object,NSError *error) {
    }];
}
- (void)clearWebVieCache //wkwebview 缓存策略对二级页面无效 主动少出缓存
{
    
    if (@available(iOS 9.0, *)) {
        NSSet *websiteDataTypes= [NSSet setWithArray:@[
                                                       WKWebsiteDataTypeDiskCache,
                                                       WKWebsiteDataTypeMemoryCache,
                                                       
                                                       ]];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    
}
@end
