//
//  WFTabbarController.h
//  WFTabbar
//
//  Created by 仁和 on 15/5/27.
//  Copyright (c) 2015年 wfw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFTabbarController : UITabBarController


@property(nonatomic,retain)UIColor * selectBackGroundColor;
@property(nonatomic,retain)UIColor * UnSelectBackGroundColor;



//字体颜色 选中
@property(nonatomic,retain)UIColor * titleSelectColor;
//字体颜色 未选中
@property(nonatomic,retain)UIColor * titleUnselectColor;



- (void)setTabberIndex:(NSInteger)tabbarItemIndex badgeValue:(NSString*)badgeValue;

@end
