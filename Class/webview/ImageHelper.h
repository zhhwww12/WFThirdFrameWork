//
//  ImageHelper.h
//  ReadBook
//
//  Created by 仁和 on 2018/9/28.
//  Copyright © 2018年 glodon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ImageHelper : NSObject
+ (BOOL)ImageDataHasPNGPreffix:(NSData *)data;
/*
 质量压缩算法 压缩率 0.5
 */
+ (UIImage*)qualityCompress:(UIImage*)image;
+ (UIImage*)qualityCompress:(UIImage*)image compress:(CGFloat)compress;
/*
 大小压缩算法1  压缩比例 原宽高1/2
 */
+ (UIImage*)sizeCompress1:(UIImage*)image;
+ (UIImage*)sizeCompress1:(UIImage*)image compress:(CGFloat)compress;
/*
 大小压缩算法2  压缩比例 原宽高1/2
 */
+ (UIImage*)sizeCompress2:(UIImage*)image;
+ (UIImage*)sizeCompress2:(UIImage*)image compress:(CGFloat)compress;

+ (BOOL)imageIsPng:(UIImage*)image;

+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;
+ (UIImage *)shotWithView:(UIView *)view;

/*
 压缩图片至小于某个大小
 */
+ (UIImage *)compressImage:(UIImage *)image toKb:(NSUInteger)kb;

//创建单色图片
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)convertViewToImage:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
