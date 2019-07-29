//
//  Util+LoadingView.h
//  ReadBook
//
//  Created by 仁和 on 2018/9/14.
//  Copyright © 2018年 glodon. All rights reserved.
//

#import "Util.h"
#import "MBProgressHUD.h"
#import "TYMActivityIndicatorView.h"

typedef void (^blockImage) ( UIImage * image);


@interface Util (UIView)
+ (void)showLoadingMessage:(NSString *)message inView:(UIView *)parentView;
+ (void)hideLoadingFromView:(UIView *)parentView animate:(BOOL)animate;
+ (void)showToastMessage:(NSString *)message;
+ (void)hiddenToast;
+ (void)getNewImageViewWithOldImage:(UIImage*)image  andTitle:(NSString*)title size:(CGSize)size key:(NSString*)key complteImage:(blockImage)blockimage;
+ (UIImage*)getNewImageViewWithOldImage:(UIImage*)image  andTitle:(NSString*)title size:(CGSize)size key:(NSString*)key;
+ (void)removeAllTargetWithBt:(UIButton*)bt;
+ (UIWindow*)getRootWindow;
@end
