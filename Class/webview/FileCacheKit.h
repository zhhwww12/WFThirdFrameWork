//
//  ImageCacheKit.h
//  ReadBook
//
//  Created by 仁和 on 2018/9/27.
//  Copyright © 2018年 glodon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^resultBlock)(id _Nullable  object);
NS_ASSUME_NONNULL_BEGIN

@interface FileCacheKit : NSObject
{
    
    
    
}
+ (FileCacheKit*)shareImageCahe;
- (void)storeImage:(UIImage*)image withKey:(NSString*)key isMemory:(BOOL)memory isDisk:(BOOL)disk;
- (void)getImageWithKey:(NSString*)key result:(resultBlock)block;
- (UIImage*)getImagesycWithKey:(NSString*)key;
- (void)getSmallImageWithKey:(NSString*)key result:(resultBlock)block;
- (BOOL)storeFileWithPath:(NSString*)filePath  withKey:(NSString*)key isMemory:(BOOL)memory isDisk:(BOOL)disk;//现在只支持存储硬盘
- (NSString*)cacheFilePath;

- (BOOL)storeFileWithString:(NSString*)dataString withKey:(NSString*)key;
- (void)getFileArrarWithKey:(NSString *)key result:(resultBlock)block;
- (NSString*)getFileStringWithKey:(NSString *)key;

- (BOOL)creatDirectoryWithPath:(NSString*)dirPath;
- (BOOL)clearAllCache;
@end

NS_ASSUME_NONNULL_END
