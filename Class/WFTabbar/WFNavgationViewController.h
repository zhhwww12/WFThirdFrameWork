//
//  WFNavgationViewController.h
//  WFTabbar
//
//  Created by 仁和 on 15/5/27.
//  Copyright (c) 2015年 wfw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFNavgationViewController : UINavigationController
@property(nonatomic,retain)UIImage * selectedImage;
@property(nonatomic,retain)UIImage * unselectedImage;
@property(nonatomic,retain)NSString * subtitle;
@property(nonatomic,assign)NSInteger tag;
- (void)setFinishedSelectedImage:(UIImage*)selectedImage withFinishedUnselectedImage:(UIImage*)unselectedImage title:(NSString*)title;

@end
