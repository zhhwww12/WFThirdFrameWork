//
//  WFNavgationViewController.m
//  WFTabbar
//
//  Created by 仁和 on 15/5/27.
//  Copyright (c) 2015年 wfw. All rights reserved.
//

#import "WFNavgationViewController.h"

@interface WFNavgationViewController ()


@end

@implementation WFNavgationViewController



- (void)viewDidLoad {
    [super viewDidLoad];

}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
        
        
    }
    return self;
}
- (void)setFinishedSelectedImage:(UIImage*)selectedImage withFinishedUnselectedImage:(UIImage*)unselectedImage title:(NSString*)title
{
    _selectedImage = selectedImage;
    _unselectedImage = unselectedImage;
    _subtitle = title;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
