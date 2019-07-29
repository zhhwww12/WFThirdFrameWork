//
//  Util+LoadingView.m
//  ReadBook
//
//  Created by 仁和 on 2018/9/14.
//  Copyright © 2018年 glodon. All rights reserved.
//

#import "Util+UIview.h"
#import "Toast+UIView.h"
#import "FileCacheKit.h"
#import "GeneralSetting.h"
@implementation Util (UIView)

+ (void)showLoadingMessage:(NSString *)message inView:(UIView *)parentView
{
    if([NSThread currentThread].isMainThread)
    {
        UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
        indicator.color=[UIColor blackColor];
        
        UIView *displayView = (parentView == nil ? [UIApplication sharedApplication].keyWindow : parentView);
        MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:displayView];
        hud.mode=MBProgressHUDModeCustomView;
        hud.customView=indicator;
        [displayView addSubview:hud];
        hud.removeFromSuperViewOnHide=YES;
        [hud show:YES];
        
        [indicator startAnimating];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
           
            UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
            indicator.color=[UIColor blackColor];
            
            UIView *displayView = (parentView == nil ? [UIApplication sharedApplication].keyWindow : parentView);
            MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:displayView];
            hud.mode=MBProgressHUDModeCustomView;
            hud.customView=indicator;
            [displayView addSubview:hud];
            hud.removeFromSuperViewOnHide=YES;
            [hud show:YES];
            
            [indicator startAnimating];
            
        });
    }
   
}
+ (void)hideLoadingFromView:(UIView *)parentView animate:(BOOL)animate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *displayView = (parentView == nil ?[self getRootWindow] : parentView);
        [MBProgressHUD hideAllHUDsForView:displayView animated:animate];
    });
}
+ (void)showToastMessage:(NSString *)message
{
    @synchronized(message)
    {
        if (message.length>0)
        {
            UIWindow *keyWindow = [self getRootWindow];
            [keyWindow makeToast:message];
        }
    }
}
+ (void)hiddenToast
{
    
    UIWindow *keyWindow = [self getRootWindow];
    [keyWindow hideToasts];

}
+ (void)getNewImageViewWithOldImage:(UIImage*)image  andTitle:(NSString*)title size:(CGSize)size key:(NSString*)key complteImage:(blockImage)blockimage;
{
    if(title.length>1)
    {
        title = [title substringToIndex:1];
    }
    [[FileCacheKit shareImageCahe] getImageWithKey:key result:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(object)
            {
                blockimage(object);
            }
            else{
                UIImageView * newImgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
                newImgeView.image = image;
                CATextLayer * textLayer = [[CATextLayer alloc] init];
                textLayer.frame = CGRectMake(0, size.height/2-14+2, size.width, 28);
                textLayer.string = title;
                textLayer.contentsScale = [UIScreen mainScreen].scale;
                textLayer.alignmentMode = kCAAlignmentCenter;
                textLayer.truncationMode = @"middle";
                textLayer.font =(__bridge CFTypeRef _Nullable)([UIFont systemFontOfSize:20]);
                textLayer.fontSize = 20;
                textLayer.foregroundColor = (__bridge CGColorRef _Nullable)(OPERATION_ColorFromRGB(0xffffff));
                [newImgeView.layer addSublayer:textLayer];
                UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
                [newImgeView.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [[FileCacheKit shareImageCahe] storeImage:image2 withKey:key isMemory:YES isDisk:YES];
                blockimage(image2);
            }
        });
    }];

}
+ (UIImage*)getNewImageViewWithOldImage:(UIImage*)image  andTitle:(NSString*)title size:(CGSize)size key:(NSString*)key
{
    if(title.length>1)
    {
        title = [title substringToIndex:1];
    }
    UIImage * returnImage = nil;
    returnImage = [[FileCacheKit shareImageCahe] getImagesycWithKey:key];
    if(returnImage)
    {
        return returnImage;
    }
    UIImageView * newImgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    newImgeView.image = image;
    CATextLayer * textLayer = [[CATextLayer alloc] init];
    textLayer.frame = CGRectMake(0, size.height/2-14+2, size.width, 28);
    textLayer.string = title;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.truncationMode = @"middle";
    textLayer.font =(__bridge CFTypeRef _Nullable)([UIFont systemFontOfSize:20]);
    textLayer.fontSize = 20;
    textLayer.foregroundColor = (__bridge CGColorRef _Nullable)(OPERATION_ColorFromRGB(0xffffff));
    [newImgeView.layer addSublayer:textLayer];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [newImgeView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[FileCacheKit shareImageCahe] storeImage:image2 withKey:title isMemory:YES isDisk:YES];
    return image2;
}
+ (void)removeAllTargetWithBt:(UIButton*)bt
{
    
}
+ (UIWindow*)getRootWindow
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if(keyWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray * windowAy = [UIApplication sharedApplication].windows;
        for (UIWindow * window in windowAy) {
            
            if(window.windowLevel == UIWindowLevelNormal&&window.hidden == NO)
            {
                keyWindow = window;
                
            }
        }
    }
    return keyWindow;
}
@end
