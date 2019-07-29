//
//  ImageCacheKit.m
//  ReadBook
//
//  Created by 仁和 on 2018/9/27.
//  Copyright © 2018年 glodon. All rights reserved.
//

#import "FileCacheKit.h"
#import <CommonCrypto/CommonDigest.h>
#import "ImageHelper.h"
@interface FileCacheKit ()
{
    
}
@property(nonatomic,retain)NSCache * imageMemoryCache;
@property(nonatomic,retain)NSString * diskFilePath;
@property(nonatomic,strong)dispatch_queue_t ioQueue;
@property(nonatomic,strong)NSFileManager * fileManger;
@end

@implementation FileCacheKit

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _imageMemoryCache = [[NSCache alloc] init];
        _imageMemoryCache.name = @"com.wfw.imageMemoryCahe";
        _imageMemoryCache.totalCostLimit = 1024*100;//100M
        _imageMemoryCache.countLimit = 0;
        
        
        NSArray * pathAy = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskFilePath = [[pathAy objectAtIndex:0] stringByAppendingPathComponent:@"com.wfw.fileCache"];
        NSLog(@"_dis = %@",_diskFilePath);
        _ioQueue = dispatch_queue_create("_ioQueue_imageMemoryCache", DISPATCH_QUEUE_CONCURRENT);
        __weak FileCacheKit * weakSelf = self;
        dispatch_barrier_async(_ioQueue, ^{
            weakSelf.fileManger = [NSFileManager defaultManager];
            [weakSelf creatDirectoryWithPath:weakSelf.diskFilePath];
        });
        
    
    }
    return self;
}
+ (FileCacheKit*)shareImageCahe
{
    
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[FileCacheKit alloc] init];

    });
    
    return instance;

}
- (BOOL)creatDirectoryWithPath:(NSString*)dirPath
{
    
    BOOL ret = YES;
    BOOL isexit = [self.fileManger fileExistsAtPath:dirPath];
    if(!isexit)
    {
        NSError * error  ;
        ret = [self.fileManger createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if(!ret)
        {
            NSLog(@"%s error %@",__FUNCTION__,error);
        }
    }
    return  ret;
}
- (NSString*)cacheFilePath
{
    __weak FileCacheKit * weakSelf = self;
    dispatch_barrier_async(_ioQueue, ^{
        [weakSelf creatDirectoryWithPath:weakSelf.diskFilePath];
    });
    return _diskFilePath;
}
#pragma mark - 图片存储相关
- (void)storeImage:(UIImage*)image withKey:(NSString*)key isMemory:(BOOL)memory isDisk:(BOOL)disk
{
    if(memory)
    {
        [self storeImageCache:image withKey:key];
    }
    if(disk)
    {
        [self storeImageDisk:image withKey:key];
    }
}
- (void)storeImageCache:(UIImage*)image withKey:(NSString*)key
{
    if(image&&image.size.width>0&&image.size.height>0)
    {
        [self.imageMemoryCache setObject:image forKey:[self MD5FileNameForKey:key] cost:image.size.width*image.size.height*image.scale*image.scale];
    }
}
- (void)storeImageDisk:(UIImage*)image withKey:(NSString*)key
{
    if(image&&image.size.width>0&&image.size.height>0)
    {
        __weak FileCacheKit * weakSelf = self;
        dispatch_barrier_async(_ioQueue, ^{
            NSData * data = UIImagePNGRepresentation(image);
            if(data.length == 0)
            {
                data = UIImageJPEGRepresentation(image, 1.0);
            }
            if(data)
            {
                [self creatDirectoryWithPath:weakSelf.diskFilePath];
                NSString * filePath = [NSString stringWithFormat:@"%@/%@",weakSelf.diskFilePath,[self MD5FileNameForKey:key]];
                BOOL success =   [weakSelf.fileManger createFileAtPath:filePath contents:data attributes:nil];
                if(success == NO)
                {
                    NSLog(@"存储大图片失败");
                }
              
            }
        });
        //存小图片
        dispatch_barrier_async(_ioQueue, ^{
            UIImage * resultImage =  [ImageHelper compressImage:image toKb:50];;//质量压缩
            NSData * data = UIImagePNGRepresentation(resultImage);
            if(data)
            {
                [self creatDirectoryWithPath:weakSelf.diskFilePath];
                NSString * filePath = [NSString stringWithFormat:@"%@/%@",weakSelf.diskFilePath,[self MD5FileNameForKey:[NSString stringWithFormat:@"small%@",key]]];
                BOOL success = [weakSelf.fileManger createFileAtPath:filePath contents:data attributes:nil];
                if(success == NO)
                {
                    NSLog(@"存储小图片失败");
                }

            }
        });
       
    }

}

- (void)getImageWithKey:(NSString*)key result:(resultBlock)block;
{
    __block UIImage * image = nil;
    image = [self.imageMemoryCache objectForKey:[self MD5FileNameForKey:key]];
    if(image)
    {
        block(image);
        return ;
    }
    __weak FileCacheKit * weakSelf = self;
    __block BOOL exists;
    dispatch_async(_ioQueue, ^{
        NSString * filePath = [NSString stringWithFormat:@"%@/%@",weakSelf.diskFilePath,[self MD5FileNameForKey:key]];
        exists = [weakSelf.fileManger fileExistsAtPath:filePath];
        if(exists)
        {
            NSData * imageData = [NSData dataWithContentsOfFile:filePath];
            image = [UIImage imageWithData:imageData];
            [self.imageMemoryCache setObject:image forKey:[self MD5FileNameForKey:key] cost:image.size.width*image.size.height*image.scale*image.scale];
            block(image);

        }
        else
        {
            block(nil);
        }
    });
}
- (UIImage*)getImagesycWithKey:(NSString*)key
{
    __block UIImage * image = nil;
    image = [self.imageMemoryCache objectForKey:[self MD5FileNameForKey:key]];
    if(image)
    {
        return image;
    }
    else{
        __block BOOL exists;
        __weak FileCacheKit * weakSelf = self;
        dispatch_sync(_ioQueue, ^{
           
            NSString * filePath = [NSString stringWithFormat:@"%@/%@",weakSelf.diskFilePath,[self MD5FileNameForKey:key]];
            exists = [weakSelf.fileManger fileExistsAtPath:filePath];
            if(exists)
            {
                NSData * imageData = [NSData dataWithContentsOfFile:filePath];
                image = [UIImage imageWithData:imageData];
                [self.imageMemoryCache setObject:image forKey:[self MD5FileNameForKey:key] cost:image.size.width*image.size.height*image.scale*image.scale];

            }
        });
    }
    return image;
}
- (void)getSmallImageWithKey:(NSString*)key result:(resultBlock)block;
{
    __block UIImage * image = nil;
    image = [self.imageMemoryCache objectForKey:[self MD5FileNameForKey:key]];
    if(image)
    {
        block(image);
        return ;
    }
    __weak FileCacheKit * weakSelf = self;
    __block BOOL exists;
    dispatch_async(_ioQueue, ^{
        NSString * filePath = [NSString stringWithFormat:@"%@/%@",weakSelf.diskFilePath,[self MD5FileNameForKey:[NSString stringWithFormat:@"small%@",key]]];
        exists = [weakSelf.fileManger fileExistsAtPath:filePath];
        if(exists)
        {
            NSData * imageData = [NSData dataWithContentsOfFile:filePath];
            image = [UIImage imageWithData:imageData];
            [self.imageMemoryCache setObject:image forKey:[self MD5FileNameForKey:key] cost:image.size.width*image.size.height*image.scale*image.scale];
            block(image);
        }
        else
        {
            block(nil);
        }
    });
}
#pragma mark - 文件存储相关
- (BOOL)storeFileWithPath:(NSString*)filePath withKey:(NSString*)key isMemory:(BOOL)memory isDisk:(BOOL)disk//现在只支持存储硬盘
{
    if(filePath.length>0)
    {
        __weak FileCacheKit * weakSelf = self;
        dispatch_barrier_async(_ioQueue, ^{
            [self creatDirectoryWithPath:weakSelf.diskFilePath];
            NSString * outfilePath = [NSString stringWithFormat:@"%@/%@",weakSelf.diskFilePath,[self MD5FileNameForKey:key]];
            NSData * data = [NSData dataWithContentsOfFile:filePath];
            [weakSelf.fileManger createFileAtPath:outfilePath contents:data attributes:nil];
            
        });
        return YES;
    }
    return NO;

}

- (BOOL)storeFileWithString:(NSString*)dataString withKey:(NSString*)key;
{
    if(dataString.length > 0)
    {
        [self.imageMemoryCache setObject:dataString forKey:[self MD5FileNameForKey:key] cost:dataString.length]; //文件存储缓存
        __weak FileCacheKit * weakSelf = self;
        dispatch_barrier_async(_ioQueue, ^{
            [self creatDirectoryWithPath:weakSelf.diskFilePath];
            NSString * outfilePath = [NSString stringWithFormat:@"%@/%@",weakSelf.diskFilePath,[self MD5FileNameForKey:key]];
            [weakSelf.fileManger removeItemAtPath:outfilePath error:nil];
            NSData *data =[dataString dataUsingEncoding:NSUTF8StringEncoding];
            [weakSelf.fileManger createFileAtPath:outfilePath contents:data attributes:nil];
            
        });
        return YES;
    }
    return NO;
    
}

- (void)getFileArrarWithKey:(NSString *)key result:(resultBlock)block;
{
    __weak FileCacheKit * weakSelf = self;
    __block BOOL exists;
    __block NSString * dataStr = nil;
    
    dataStr = [self.imageMemoryCache objectForKey:[self MD5FileNameForKey:key]];
    if(dataStr.length>0)
    {
        block(dataStr);
        return;
    }
    dispatch_async(_ioQueue, ^{
        NSString * filePath = [NSString stringWithFormat:@"%@/%@",weakSelf.diskFilePath,[self MD5FileNameForKey:[NSString stringWithFormat:@"%@",key]]];
        exists = [weakSelf.fileManger fileExistsAtPath:filePath];
        if(exists)
        {
            NSData * data = [NSData dataWithContentsOfFile:filePath];
            dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [self.imageMemoryCache setObject:dataStr forKey:[self MD5FileNameForKey:key] cost:dataStr.length]; //重新加载到文件存储缓存
            block(dataStr);
            
        }
        else
        {
            block(nil);
        }
    });
}
- (NSString*)getFileStringWithKey:(NSString *)key
{
    
    __weak FileCacheKit * weakSelf = self;
    __block BOOL exists;
    __block NSString * dataStr = nil;
    
    dataStr = [self.imageMemoryCache objectForKey:[self MD5FileNameForKey:key]];
    if(dataStr.length>0)
    {
        return dataStr;
    }
    dispatch_sync(_ioQueue, ^{
        NSString * filePath = [NSString stringWithFormat:@"%@/%@",weakSelf.diskFilePath,[self MD5FileNameForKey:[NSString stringWithFormat:@"%@",key]]];
        exists = [weakSelf.fileManger fileExistsAtPath:filePath];
        if(exists)
        {
            NSData * data = [NSData dataWithContentsOfFile:filePath];
            dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [self.imageMemoryCache setObject:dataStr forKey:[self MD5FileNameForKey:key] cost:dataStr.length]; //重新加载到文件存储缓存
            
        }
    });
    return dataStr;
}

- (NSString *)MD5FileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

- (BOOL)clearAllCache
{
    NSArray * pathAy = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cachePath = [pathAy objectAtIndex:0];
    [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    return YES;
}
@end
