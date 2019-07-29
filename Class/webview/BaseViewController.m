//
//  BaseViewController.m
//  ReadBook
//
//  Created by 仁和 on 15/8/3.
//  Copyright (c) 2015年 glodon. All rights reserved.
//

#import "BaseViewController.h"
#import <objc/runtime.h>
#import "GeneralSetting.h"
#import "UtilSdk.h"
#define TITLELABLE_TAG @"TITLELABLE_TAG"


@interface BaseViewController ()
{
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate=nil;
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
    
    //滑动返回手势
    self.popGestureEnabled=YES;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1]];

    if(IOSVERSION>6.9)
    {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    
    
    //适配刘海屏幕
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if(@available(iOS 11.0, *))
    {
        inset = UIApplication.sharedApplication.windows[0].safeAreaInsets;
    }
    self.liuhaiHeight = inset.top==0?0:20;
    self.tabbarHeight = self.tabBarController.tabBar.bounds.size.height;
    self.navigationHeight = 64+self.liuhaiHeight;
    
    self.refView = NO;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden=YES;
    
    if (self.navigationController.viewControllers.count<=1)
    {
        self.popGestureEnabled=NO;
    }
    
}
- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if(@available(iOS 11.0, *))
    {
        inset = UIApplication.sharedApplication.windows[0].safeAreaInsets;
        
    }
    self.liuhaiHeight = inset.top==0?0:20;
    self.tabbarHeight = self.tabBarController.tabBar.frame.size.height;
    self.navigationHeight = 64+self.liuhaiHeight;
    
        
}

-(void)buildCustomNavigationBar
{
    [self buildCustomNavigationBarWithColor:[UIColor whiteColor]];
}
-(void)buildCustomNavigationBarWithColor:(UIColor*)color
{
    self.navigationController.navigationBar.hidden=YES;
    float ios7Offset=20;
    
    self.naviBackView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44+ios7Offset+self.liuhaiHeight)];
    self.naviBackView.image=[UIImage imageNamed:@"nav_bar_ios7.png"];
    self.naviBackView.backgroundColor = color;
    self.naviBackView.userInteractionEnabled=YES;
    
    [self.view addSubview:self.naviBackView];
    
    self.naviBar=[[UIView alloc] initWithFrame:CGRectMake(0, self.liuhaiHeight, [UIScreen mainScreen].bounds.size.width, 44+ios7Offset)];
    self.naviBar.userInteractionEnabled=YES;
    self.naviBar.backgroundColor=[UIColor clearColor];
    [self.naviBackView addSubview:self.naviBar];
    
    UIView * lineView = [[UIView alloc] init];
    if(CGColorEqualToColor(color.CGColor, [UIColor whiteColor].CGColor))
    {
        lineView.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];

    }
    else{
        lineView.backgroundColor  = color;
    }
    lineView.frame = CGRectMake(0, self.naviBackView.frame.size.height-0.5, ScreenWidth, 0.5);
    [self.naviBackView addSubview:lineView];
}
-(void)setCustomTitle:(NSString *)customTitle
{
    [self setCustomTitle:customTitle tiltColor:OPERATION_ColorFromRGB(0x333333)];
}
-(void)setCustomTitle:(NSString *)customTitle tiltColor:(UIColor*)color
{
    NSString *titleString=customTitle;
    
    if (titleString.length==0)
    {
        titleString=@"";
    }
    
    UIFont *titleFont=[UIFont systemFontOfSize:20];
    UILabel * titleLabel = objc_getAssociatedObject(self, TITLELABLE_TAG);
    if(!titleLabel)
    {
        titleLabel=[[UILabel alloc] init];
        objc_setAssociatedObject(self, TITLELABLE_TAG , titleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else
    {
        [titleLabel removeFromSuperview];
    }
    
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=titleFont;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=color;
    titleLabel.text=titleString;
    [titleLabel sizeToFit];
    //4.21 ui修改
    titleLabel.frame = CGRectMake(44, 0, ScreenWidth-88, 20);
   // titleLabel.frame = CGRectMake(0, 0, titleLabel.bounds.size.width, 20);
    titleLabel.userInteractionEnabled  = YES;
    
    
    if (self.naviBar)
    {
        float ios7Offset=20;
        titleLabel.center=CGPointMake(self.naviBar.frame.size.width/2, self.naviBar.frame.size.height/2+ios7Offset/2);
        [self.naviBar addSubview:titleLabel];
    }
    else
    {
        self.navigationItem.titleView=titleLabel;
    }
    
}

- (void)buildCustomBackButton
{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor=[UIColor clearColor];
    backButton.frame=CGRectMake(0, 0, 64, 44);
    
    UIImageView *backImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, (44-24)/2, 24, 24)];
    backImgView.image=[UIImage imageNamed:@"back.png"];
    [backButton addSubview:backImgView];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
 
    if (self.naviBar)
    {
        float ios7Offset= 20;
        backButton.center=CGPointMake(backButton.frame.size.width/2, self.naviBar.frame.size.height/2+ios7Offset/2);
        [self.naviBar addSubview:backButton];
    }
    else
    {
        UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem=leftItem;
    }
    self.popGestureEnabled=YES;

}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- 返回手势的控制

- (void)setPopGestureEnabled:(BOOL)popGestureEnabled
{
    @synchronized (self)
    {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        {
            _popGestureEnabled=popGestureEnabled;
            
            self.navigationController.interactivePopGestureRecognizer.delegate=nil;
            self.navigationController.interactivePopGestureRecognizer.enabled=popGestureEnabled;
        }
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}
- (void)viewDidLayoutSubviews
{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    LOG_Current_Dealloc_Class
}
@end
