//
//  DDSWebPageViewController.m
//  DingDangShop
//
//  Created by YangJinglin on 14/12/29.
//  Copyright (c) 2014年 WorkGroup. All rights reserved.
//

#import "DDSWebPageViewController.h"
#import <objc/runtime.h>
#import <AdSupport/ASIdentifierManager.h>
#import "DataProcessing.h"
#import "WebViewManger.h"
#define webQuestTimeout  30

@interface DDSWebPageViewController ()
{

    UIButton * shareBt;
    UIButton * closeButton;
    NSString * lastRuestUrlString;
    

    UILabel *selfTreatShareLabel;
    
    UIView *maskView;
    UIView *updatedShareView;
    UIView *selfTreatshareView;
    
    UILabel *contentLabel;
    UIButton *wechatButton;
    UILabel  *friendsLabel;
    UIButton *friendsButton;
    UILabel  *wechatLabel;
    BOOL refWebView;
    UIView *cancleShareView;

}


@property (nonatomic,copy) NSString *pageTitle;
@property (nonatomic,assign) BOOL  firstViewLoad;
@end

@implementation DDSWebPageViewController

@synthesize contentWebView = contentWebView;

- (id)initWithAddressString:(NSString *)addressString andTitle:(NSString *)title
{
    if (self=[super init])
    {
        if ([DataProcessing stringNotNull:addressString])
        {
            addressString=[addressString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            addressString=[addressString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            addressString=[addressString stringByReplacingOccurrencesOfString:@" " withString:@""];
            self.addressString=addressString;
            self.origionalAddressStr = addressString;
        }
        if ([DataProcessing stringNotNull:title])
        {
            self.pageTitle=title;
        }
        refWebView = NO;
        self.firstViewLoad = YES;


    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

   
}

- (void)loadUrlQuest
{
    if (![DataProcessing stringNotNull:self.addressString])
    {
        self.addressString=@"http://www.ddky.com/mobile.html";
    }
    self.addressString = [self.addressString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    lastRuestUrlString = self.addressString;
    [contentWebView loadUrlString:self.addressString cachePolicy:NSURLRequestReloadIgnoringCacheData];
}
- (void)loadH5UrlQuest
{

    [contentWebView loadUrlString:lastRuestUrlString cachePolicy:NSURLRequestReloadIgnoringCacheData];
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString * resultString =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return resultString;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.firstViewLoad == YES)
    {
        [self loadUrlQuest];
        self.firstViewLoad = NO;
    }
    
   // [self startWebJs];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
 
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildCustomNavigationBar];
    [self buildCustomBackButton];
    [self setCustomTitle:self.pageTitle];

    //如果之前屏幕已显示键盘，则先收回
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    [self addWebView];
    
    [contentWebView removePanGes];
    

    if ([DataProcessing stringNotNull:self.pageTitle])
    {
        [self setCustomTitle:self.pageTitle];
    }
    else
    {
        [self setCustomTitle:@""];
    }
    self.firstViewLoad = YES;
    refWebView = NO;

}

-(void)onSelectedBtn{
    [self removeShareView];
}


-(void)tapGestureActionOnView:(UITapGestureRecognizer *)tapGesture
{
    [self removeShareView];
}
- (void)removeShareView
{
    [updatedShareView removeFromSuperview];
    
    [maskView removeFromSuperview];
    maskView = nil;
}
- (void)closeAction
{
    NSLog(@"close click:");
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backAction
{
    if([contentWebView.swipeWebView canGoBack])
    {
        [contentWebView goBack];
    }
    else
    {
        if(self.navigationController)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}
- (void)startWebJs
{
    [contentWebView loadUrlString:@"http://192.168.23.154:8080/testall/index.html" cachePolicy:NSURLRequestReloadIgnoringCacheData];
}

- (void)addWebView{

    contentWebView=[[DDSSwipeWkWebview alloc] initWithFrame:CGRectMake(0, self.navigationHeight, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-self.navigationHeight)];
    contentWebView.swipeDelegate=self;
    contentWebView.swipeWebView.backgroundColor=self.view.backgroundColor;
    contentWebView.swipeWebView.userInteractionEnabled = NO;
    [self.view addSubview:contentWebView];
}
#pragma mark wkwebview delegate
- (void)SswipeWebView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if(error.code == NSURLErrorTimedOut
       ||error.code == NSURLErrorNotConnectedToInternet
       ||error.code == NSURLErrorCannotConnectToHost)
    {
        
    }
}
- (void)swipewebView:(WKWebView *_Nullable)webView decidePolicyForNavigationAction:(WKNavigationAction *_Nullable)navigationAction decisionHandler:(void (^_Nullable)(WKNavigationActionPolicy))decisionHandler
{
    self.origionalAddressStr = navigationAction.request.URL.absoluteString;
    lastRuestUrlString = navigationAction.request.URL.absoluteString;
    if ([navigationAction.request.URL.scheme isEqualToString:@"file"]||[navigationAction.request.URL.scheme isEqualToString:@"tel"]||[navigationAction.request.URL.scheme isEqualToString:@"about"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
- (void)swipewebView:(WKWebView *_Nullable)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    
    if(webView.canGoBack == YES)
    {
        closeButton.hidden = NO;
        [contentWebView addPanGes];
    }
    else
    {
        [contentWebView removePanGes];
        closeButton.hidden = YES;
    }

    NSString * webTitle = webView.title;
    webViewTitle = webTitle;
    if (_isShowTitle)
    {
        
    }
    else
    {
        if(webTitle.length>0)
            [self setCustomTitle:webTitle];
    }
    
    contentWebView.swipeWebView.userInteractionEnabled = YES;
    shareBt.userInteractionEnabled = YES;
    
}
- (void)actionBtClick:(id)sender
{
    
    [contentWebView loadUrlString:self.addressString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSString*)urlEncodedString:(NSString *)string
{
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    return encodedString;
}

- (void)dealloc
{
    [contentWebView.swipeWebView stopLoading];
    contentWebView.swipeDelegate=nil;
    contentWebView=nil;
    [self.contentWebView clearWebVieCache];
    
}
@end
