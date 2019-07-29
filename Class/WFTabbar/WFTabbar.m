//
//  WFTabbar.m
//  WFTabbar
//
//  Created by 仁和 on 15/5/27.
//  Copyright (c) 2015年 wfw. All rights reserved.
//




#import "WFTabbar.h"



///颜色转换RGB
#define OPERATION_RGBCOLOR(a,b,c)  [UIColor colorWithRed:(float)a/255.0 \
green:(float)b/255.0 \
blue:(float)c/255.0 alpha:1]

@interface WFTabbar ()
@property(nonatomic,strong)DDSBadgeView * badgeValueView;
@end
@implementation WFTabbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        titleLa = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-15, self.frame.size.width, 10)];
        titleLa.font = [UIFont systemFontOfSize:12];
        titleLa.textAlignment = NSTextAlignmentCenter;
   
        titleLa.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLa];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-10.5, (self.frame.size.height-15)/2-10.5, 21, 21)];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = NO;
        [self addSubview:imageView];
        
        self.badgeValueView = [[DDSBadgeView alloc] initWithFrame:CGRectMake(imageView.frame.size.height-6, 0, 16, 16)];
        self.badgeValueView.hidden = YES;
        [imageView addSubview:self.badgeValueView];
        
        self.topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, 0.5)];
        self.topLineView.backgroundColor =  [UIColor colorWithRed:239.0/255 green:239.0/255 blue:244.0/255 alpha:1];
        [self addSubview:self.topLineView];
        

    }
    return self;
}
- (void)setSelected:(BOOL)selected
{
   
    titleLa.text = self.tabbarTitle;
    
    if(selected == YES)
    {
        self.backgroundColor = self.selectBackGroundColor;
        imageView.image = self.tabbarSelectedImage;
        titleLa.textColor = self.titleSelectColor;
        
    }
    else
    {
        self.backgroundColor = self.UnSelectBackGroundColor;
        imageView.image = self.tabbarUnSelectedImage;
        titleLa.textColor = self.titleUnselectColor;
    }
    
}

- (void)setBageValueString:(NSString *)bageValue
{
    if(bageValue.length>0)
    {
        self.badgeValueView.hidden = NO;
        [self.badgeValueView setBadgeNumer:bageValue];
    }
    else{
        self.badgeValueView.hidden = YES;
    }
    
}

- (void)drawRect:(CGRect)rect
{
   
    
}
@end
