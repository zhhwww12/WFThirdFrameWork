//
//  DDSBadgeView.m
//  DingDangShop
//
//  Created by 仁和 on 2017/6/23.
//  Copyright © 2017年 WorkGroup. All rights reserved.
//

#import "DDSBadgeView.h"

@interface DDSBadgeView ()
{
    UIImageView * rectImageView;
    UILabel * textLale;
}
@end

@implementation DDSBadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        rectImageView = [[UIImageView alloc] init];
        [self addSubview:rectImageView];
        
    
        textLale  = [[UILabel alloc] init];
        textLale.font = [UIFont systemFontOfSize:10];
        textLale.textColor = [UIColor whiteColor];
        textLale.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textLale];
        
    }
    return self;
}

- (void)setBadgeNumer:(NSString *)badgeNumer
{
    if(badgeNumer == nil||badgeNumer.integerValue == 0)
    {
        rectImageView.hidden = YES;
        textLale.hidden = YES;
    }
    else{
        
        rectImageView.hidden = NO;
        textLale.hidden = NO;
        
        textLale.text = badgeNumer;
        [textLale sizeToFit];
        
        CGFloat minWidth = self.frame.size.width;
        CGFloat width = textLale.bounds.size.width+6;
        width = width<minWidth?minWidth:width;
        
        rectImageView.frame =  CGRectMake(0, 0, width, self.frame.size.height);
        textLale.frame = CGRectMake(0, 0, width, self.frame.size.height);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
        self.center = CGPointMake(self.superview.frame.size.width, self.frame.size.height/2);
        
        UIImage * image = [UIImage imageNamed:@"qipao"];
        image = [image stretchableImageWithLeftCapWidth:8 topCapHeight:0];
        rectImageView.image = image;

    }
    
}
@end
