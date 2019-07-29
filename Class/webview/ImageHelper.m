//
//  ImageHelper.m
//  ReadBook
//
//  Created by 仁和 on 2018/9/28.
//  Copyright © 2018年 glodon. All rights reserved.
//

#import "ImageHelper.h"

static unsigned char kPNGSignatureBytes[8] = {0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A};


@implementation ImageHelper

+ (BOOL)ImageDataHasPNGPreffix:(NSData *)data
{
    
    NSData * kPNGSignatureData = [NSData dataWithBytes:kPNGSignatureBytes length:8];
    NSUInteger pngSignatureLength = [kPNGSignatureData length];
    if ([data length] >= pngSignatureLength) {
        if ([[data subdataWithRange:NSMakeRange(0, pngSignatureLength)] isEqualToData:kPNGSignatureData]) {
            return YES;
        }
    }
    return NO;
}
+ (BOOL)imageIsPng:(UIImage*)image
{
    NSData * data = UIImagePNGRepresentation(image);
    if(data.length == 0)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    return [self ImageDataHasPNGPreffix:data];
}
+ (UIImage*)qualityCompress:(UIImage*)image
{
    return  [self qualityCompress:image compress:0.5];
}
+ (UIImage*)qualityCompress:(UIImage*)image compress:(CGFloat)compress
{
    NSData *data = UIImageJPEGRepresentation(image, compress);
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}
+ (UIImage*)sizeCompress1:(UIImage*)image
{
    return [self sizeCompress1:image compress:0.5];
}
+ (UIImage*)sizeCompress1:(UIImage*)image compress:(CGFloat)compress
{
    UIImage *resultImage  = nil;
    CGSize size = CGSizeMake(image.size.width*compress,image.size.height*compress);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
/*
 大小压缩算法2  压缩比例 原宽高1/2
 */
+ (UIImage*)sizeCompress2:(UIImage*)image
{
    return [self sizeCompress2:image compress:0.5];
}
+ (UIImage*)sizeCompress2:(UIImage*)image compress:(CGFloat)compress
{
    UIImage *inImage = image;
    NSAssert(inImage, @"error");
    
    NSLog(@"in %@", NSStringFromCGSize(inImage.size));
    
    CGImageRef inImageRef = [inImage CGImage];
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(inImageRef);
    CFDataRef inBitmapData       = CGDataProviderCopyData(inProvider);
    
    vImage_Buffer inBuffer = {
        .data     = (void *)CFDataGetBytePtr(inBitmapData),
        .width    = CGImageGetWidth(inImageRef),
        .height   = CGImageGetHeight(inImageRef),
        .rowBytes = CGImageGetBytesPerRow(inImageRef),
    };
    
    
    double scaleFactor      = compress;
    void *outBytes          = malloc(trunc(inBuffer.height * scaleFactor) * inBuffer.rowBytes);
    vImage_Buffer outBuffer = {
        .data     = outBytes,
        .width    = trunc(inBuffer.width * scaleFactor),
        .height   = trunc(inBuffer.height * scaleFactor),
        .rowBytes = inBuffer.rowBytes,
    };
    
    vImage_Error error =
    vImageScale_ARGB8888(&inBuffer,
                         &outBuffer,
                         NULL,
                         kvImageHighQualityResampling);
    if (error)
    {
        NSLog(@"Error: %ld", error);
    }
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef c                = CGBitmapContextCreate(outBuffer.data,
                                                          outBuffer.width,
                                                          outBuffer.height,
                                                          8,
                                                          outBuffer.rowBytes,
                                                          colorSpaceRef,
                                                          kCGImageAlphaNoneSkipLast);
    CGImageRef outImageRef = CGBitmapContextCreateImage(c);
    UIImage *outImage      = [UIImage imageWithCGImage:outImageRef];
    
    CGImageRelease(outImageRef);
    CGContextRelease(c);
    CGColorSpaceRelease(colorSpaceRef);
    CFRelease(inBitmapData);
    
    NSLog(@"out %@", NSStringFromCGSize(outImage.size));
    return outImage;
}
+ (UIImage *)compressImage:(UIImage *)image toKb:(NSUInteger)kb
{
    NSTimeInterval  time1 = [NSDate timeIntervalSinceReferenceDate];
    NSUInteger  maxLength = kb*1024;
    CGFloat compression = 1;
    NSData * data = UIImageJPEGRepresentation(image, compression);
    if (([data length]) < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if ([data length] < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    image  = [UIImage imageWithData:data];
    if ([data length] < maxLength)
    {
        return image;
    }
    CGFloat ratio = (CGFloat)maxLength / (CGFloat)([data length]);
    while ([data length] > maxLength) {
        image = [self sizeCompress2:image compress:ratio];
        data = UIImagePNGRepresentation(image);
        ratio = 0.5;
    }
    NSTimeInterval  time2 = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"time = %f秒",time2-time1);
    return image;
}
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope
{
    
    CGRect rect = CGRectZero;
    rect.size.width = scope.size.width*[UIScreen mainScreen].scale;
    rect.size.height = scope.size.height*[UIScreen mainScreen].scale;
    
    CGFloat  newViewWidth = view.bounds.size.width*[UIScreen mainScreen].scale;
    CGFloat  newViewheight = view.bounds.size.height*[UIScreen mainScreen].scale;
    
    rect.origin.x = newViewWidth*(scope.origin.x/view.bounds.size.width);
    rect.origin.y = newViewheight*(scope.origin.y/view.bounds.size.height);//用百分比做 x y
    CGImageRef imageRef = CGImageCreateWithImageInRect([self shotWithView:view].CGImage, rect);
    UIImage * image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}
+ (UIImage *)shotWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.bounds.size.width, view.bounds.size.height), NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//创建单色图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIImage *)convertViewToImage:(UIView *)view {
    
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
    
}
@end
