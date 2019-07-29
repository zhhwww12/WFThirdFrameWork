//
//  BaseViewController.h
//  ReadBook
//
//  Created by 仁和 on 15/8/3.
//  Copyright (c) 2015年 glodon. All rights reserved.
//

#import <UIKit/UIKit.h>

//打印dealloc的当前类
#define LOG_Current_Dealloc_Class NSLog(@"----------dealloc %@----------",[self class]);

#define maxPageNumer @"20"
@interface BaseViewController : UIViewController

@property(nonatomic,strong)UIView * naviBar;
@property(nonatomic,strong)UIImageView * naviBackView;


@property(nonatomic,assign)CGFloat tabbarHeight;
@property(nonatomic,assign)CGFloat navigationHeight;
@property(nonatomic,assign)CGFloat liuhaiHeight;

@property (nonatomic, assign) BOOL popGestureEnabled;

-(void)buildCustomNavigationBar;
-(void)buildCustomNavigationBarWithColor:(UIColor*)color;

-(void)setCustomTitle:(NSString *)customTitle;
-(void)setCustomTitle:(NSString *)customTitle tiltColor:(UIColor*)color;
- (void)buildCustomBackButton;
- (void)backAction;

@property(nonatomic,assign)BOOL refView;

@end
