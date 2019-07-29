//
//  DDSWebPageViewController.h
//  DingDangShop
//
//  Created by YangJinglin on 14/12/29.
//  Copyright (c) 2014年 WorkGroup. All rights reserved.
//

#import "BaseViewController.h"
#import "DDSSwipeWkWebview.h"
#import "WebViewDelegate.h"

@interface DDSWebPageViewController : BaseViewController

<WebViewDelegate,UINavigationControllerDelegate>
{
    
 
    
    NSString * webViewTitle;
    DDSSwipeWkWebview *contentWebView;

}

@property (nonatomic,copy) NSString *addressString;

@property(nonatomic,assign)BOOL isShowTitle;
@property(nonatomic,retain)NSString * shareId;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
@property(nonatomic,retain)DDSSwipeWkWebview *  contentWebView;
#else
@property(nonatomic,retain)DDSSwipeUIWebView *contentWebView;
#endif

//4.4


//首页分享的内容
@property(nonatomic,copy)NSString *origionalAddressStr;


/**
 *
 * addressString 网页地址
 *
 * title 导航栏title
 */
- (id)initWithAddressString:(NSString *)addressString andTitle:(NSString *)title;


- (void)loadH5UrlQuest;
- (void)backButtonTapped;



@end
