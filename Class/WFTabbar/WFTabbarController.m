//
//  WFTabbarController.m
//  WFTabbar
//
//  Created by 仁和 on 15/5/27.
//  Copyright (c) 2015年 wfw. All rights reserved.
//

#import "WFTabbarController.h"
#import "WFTabbar.h"
#import "WFNavgationViewController.h"


@interface WFTabbarController ()
{
    NSMutableArray * tabbarItems;

}
@end

@implementation WFTabbarController

@class UITabBarButton;
- (instancetype)init
{
    self = [super init];
    if (self) {
        tabbarItems = [[NSMutableArray alloc] init];
        self.view.backgroundColor = [UIColor whiteColor];
        
      
        
        if([UIDevice currentDevice].systemVersion.floatValue>8.9)
        {
            CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
            CGContextFillRect(context, rect);
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [self.tabBar setBackgroundImage:img];
            [self.tabBar setShadowImage:img];
        }
        else{
            
            [self.tabBar setShadowImage:[UIImage new]];
            [self.tabBar setBackgroundImage:[UIImage new]];

        }
       
      
    
    }
    return self;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    int  tag  = 0;
    
    CGFloat tabbarWidth = [UIScreen mainScreen].bounds.size.width/self.tabBar.subviews.count;
    CGFloat temptabbarHeight = 0;
    
    for (UIView * subView in self.tabBar.subviews)
    {
        WFNavgationViewController * nav = [viewControllers objectAtIndex:tag];
        WFTabbar * tabbar = [[WFTabbar alloc] initWithFrame:CGRectMake(tabbarWidth*tag, 0,tabbarWidth ,subView.frame.size.height)];
        temptabbarHeight = subView.frame.size.height;
        tabbar.selectBackGroundColor = self.selectBackGroundColor;
        tabbar.UnSelectBackGroundColor = self.UnSelectBackGroundColor;
        [tabbar setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        tabbar.backgroundColor = [UIColor whiteColor];
        tabbar.tag = tag;
        [tabbar addTarget:self action:@selector(tabbarClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:tabbar];
    
        tabbar.tabbarSelectedImage = nav.selectedImage;
        tabbar.tabbarUnSelectedImage = nav.unselectedImage;
        tabbar.tabbarTitle = nav.subtitle;
        tabbar.titleUnselectColor = self.titleUnselectColor;
        tabbar.titleSelectColor = self.titleSelectColor;
        
        
        if(tag == 0)
        {
            tabbar.selected = YES;
        }
        else
        {
            tabbar.selected = NO;
        }
        tag++;
        [tabbarItems addObject:tabbar];
        [subView removeFromSuperview];
    }
    
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    for (UIView * subView in self.tabBar.subviews)
    {
        if([subView isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            [subView removeFromSuperview];
        }
        if([subView isKindOfClass:NSClassFromString(@"_UIBarBackground")])
        {
            [subView removeFromSuperview];
        }
        
    }
    
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    for (UIView * subView in self.tabBar.subviews)
    {
        if([subView isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            [subView removeFromSuperview];
        }
        if([subView isKindOfClass:NSClassFromString(@"_UIBarBackground")])
        {
            [subView removeFromSuperview];
        }
        
    }
    
}
- (void)tabbarClick:(WFTabbar*)tab
{
    if([self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
    {
    
        BOOL select = [self.delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:tab.tag]];
        if(select == YES)
        {
            [self setSelectedIndex:tab.tag];
            if([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
            {
                [self.delegate tabBarController:self didSelectViewController:self.selectedViewController];
            }
        }
        else{
            
        }
    }

}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    
    for (int i = 0; i<tabbarItems.count; i++)
    {
        WFTabbar * oneTab = [tabbarItems objectAtIndex:i];
        if(selectedIndex == i)
        {
            oneTab.selected = YES;
        }
        else
        {
            oneTab.selected = NO;
        }
    }
    
}
- (void)setTabberIndex:(NSInteger)tabbarItemIndex badgeValue:(NSString*)badgeValue
{
    if(tabbarItems.count>tabbarItemIndex)
    {
        WFTabbar * tabbar = [tabbarItems objectAtIndex:tabbarItemIndex];
        [tabbar setBageValueString:badgeValue];
    }
    
}
- (void)viewDidLoad {

    [super viewDidLoad];
    [UITabBar appearance].translucent = NO;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}


@end
