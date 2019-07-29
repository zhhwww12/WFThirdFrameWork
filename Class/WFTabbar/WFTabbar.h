//
//  WFTabbar.h
//  WFTabbar
//
//  Created by 仁和 on 15/5/27.
//  Copyright (c) 2015年 wfw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSBadgeView.h"
@interface WFTabbar : UIButton
{
    UILabel * titleLa;
    UIImageView * imageView;
    
    

}

@property(nonatomic,retain)NSString * tabbarTitle;
@property(nonatomic,retain)UIImage * tabbarSelectedImage;
@property(nonatomic,retain)UIImage * tabbarUnSelectedImage;
@property(nonatomic,retain)UIColor * selectBackGroundColor;
@property(nonatomic,retain)UIColor * UnSelectBackGroundColor;
//字体颜色 选中
@property(nonatomic,retain)UIColor * titleSelectColor;
//字体颜色 未选中
@property(nonatomic,retain)UIColor * titleUnselectColor;

@property(nonatomic,strong)UIView * topLineView;

- (void)setBageValueString:(NSString*)bageValue;

@end
