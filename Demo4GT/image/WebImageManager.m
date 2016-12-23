//
//  WebImageManager.m
//  Demo4GT
//
//  Created   on 13-6-4.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import "WebImageManager.h"
#import "WebImageDownloader.h"
#import "ImageCache.h"
#import "ImageStat.h"

static WebImageManager *instance;

@implementation WebImageManager

- (id)init
{
    if ((self = [super init]))
    {
        downloadDelegates = [[NSMutableArray alloc] init];
        downloaders = [[NSMutableArray alloc] init];
        cacheDelegates = [[NSMutableArray alloc] init];
        downloaderForURL = [[NSMutableDictionary alloc] init];
        failedURLs = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelCurrentDownloading) name:@"cancelConnection" object:nil];
        
        downloadQueue = [[NSOperationQueue alloc] init];
        downloadQueue.maxConcurrentOperationCount = 1;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDownloadFinish:) name:WebImageDownloadFinishNotification object:nil];
    }
    return self;
}

-(void)cancelCurrentDownloading{
    NSMutableArray *connections = [downloadDelegates copy];
    for (id url in connections) {
        [self cancelForDelegate:url];
    }
    downloadCount = 0;
    [connections release];
}

+ (id)sharedManager
{
    if (instance == nil)
    {
        instance = [[WebImageManager alloc] init];
        
    }
    
    return instance;
}

/**
 * @deprecated
 */
- (UIImage *)imageWithURL:(NSURL *)url
{
    return [[ImageCache sharedImageCache] imageFromKey:[url absoluteString]];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<WebImageManagerDelegate>)delegate
{
    [self downloadWithURL: url delegate:delegate retryFailed:NO];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<WebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed
{
    [self downloadWithURL:url delegate:delegate retryFailed:retryFailed lowPriority:NO];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<WebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed lowPriority:(BOOL)lowPriority
{
    if (!url || !delegate || (!retryFailed && [failedURLs containsObject:url]))
    {
        return;
    }
    
    NSString *threadNum = @"1";
#ifndef GT_DEBUG_DISABLE
    // GT Usage(输入参数) 设置并发线程数
    threadNum = GT_OC_IN_GET(@"并发线程数", NO, @"1");
#endif
    [downloadQueue setMaxConcurrentOperationCount:[threadNum integerValue]];
    
    // Check the on-disk cache async so we don't block the main thread
    [cacheDelegates addObject:delegate];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:delegate, @"delegate", url, @"url", [NSNumber numberWithBool:lowPriority], @"low_priority", nil];
    [[ImageCache sharedImageCache] queryDiskCacheForKey:[url absoluteString] delegate:self userInfo:info];
}

- (void)cancelForDelegate:(id<WebImageManagerDelegate>)delegate
{
    // Remove all instances of delegate from cacheDelegates.
    // (removeObjectIdenticalTo: does this, despite its singular name.)
    [cacheDelegates removeObjectIdenticalTo:delegate];
    
    NSUInteger idx;
    while ((idx = [downloadDelegates indexOfObjectIdenticalTo:delegate]) != NSNotFound)
    {
        WebImageDownloader *downloader = [downloaders objectAtIndex:idx] ;
        
        [downloadDelegates removeObjectAtIndex:idx];
        [downloaders removeObjectAtIndex:idx];
        
        if (![downloaders containsObject:downloader])
        {
            // No more delegate are waiting for this download, cancel it
            // NSLog(@"取消的是%@",downloader.url);
            [downloader cancel];
            [downloaderForURL removeObjectForKey:downloader.url];
        }
        
        
    }
}


#pragma mark ImageCacheDelegate

- (void)imageCache:(ImageCache *)imageCache didFindImage:(UIImage *)image forKey:(NSString *)key userInfo:(NSDictionary *)info
{
    id<WebImageManagerDelegate> delegate = [info objectForKey:@"delegate"];
    
    NSUInteger idx = [cacheDelegates indexOfObjectIdenticalTo:delegate];
    if (idx == NSNotFound)
    {
        // Request has since been canceled
        return;
    }
    
    if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:)])
    {
        [delegate performSelector:@selector(webImageManager:didFinishWithImage:) withObject:self withObject:image];
    }
    
    // Remove one instance of delegate from the array,
    // not all of them (as |removeObjectIdenticalTo:| would)
    // in case multiple requests are issued.
    [cacheDelegates removeObjectAtIndex:idx];
}

- (void)imageCache:(ImageCache *)imageCache didNotFindImageForKey:(NSString *)key userInfo:(NSDictionary *)info
{
    NSURL *url = [info objectForKey:@"url"];
    id<WebImageManagerDelegate> delegate = [info objectForKey:@"delegate"];
    BOOL lowPriority = [[info objectForKey:@"low_priority"] boolValue];
    
    NSUInteger idx = [cacheDelegates indexOfObjectIdenticalTo:delegate];
    if (idx == NSNotFound)
    {
        // Request has since been canceled
        return;
    }
    
    [cacheDelegates removeObjectAtIndex:idx];
// hannhaliao
//    if ([delegate isKindOfClass:[UrlImageView class]]) {
//        ((UrlImageView *)delegate)._animated=YES;
//    }
    
    
    // Share the same downloader for identical URLs so we don't download the same URL several times
    WebImageDownloader *downloader = [downloaderForURL objectForKey:url];
    if (!downloader)
    {
        downloader = [WebImageDownloader downloaderWithURL:url delegate:self userInfo:nil lowPriority:lowPriority];
        [downloaderForURL setObject:downloader forKey:url];
        
        [downloadDelegates addObject:delegate];
        [downloaders addObject:downloader];
        
        
        [downloadQueue addOperation:downloader];
        downloadCount++;
    }
    
    // If we get a normal priority request, make sure to change type since downloader is shared
    if (!lowPriority && downloader.lowPriority)
    {
        downloader.lowPriority = NO;
    }
    
    
}


#pragma mark WebImageDownloaderDelegate

- (void)imageDownloadFinishCheck
{
    downloadCount--;
#ifndef GT_DEBUG_DISABLE
    //最后一张图片
    if (downloadCount == 0) {
        // GT Usage(profiler) 图片下载总时间结束
        NSTimeInterval time = GT_OC_TIME_END(@"PIC", @"ALL");
        
        // GT Usage(输出参数) 统计本次下载的信息并设置在输出参数上便于在悬浮框上显示
        GT_OC_OUT_SET(@"下载耗时", YES, @"%.3fS", time);
        GT_OC_OUT_SET(@"本次消耗流量", YES, @"%.1fKB", [[ImageStat sharedInstance] downloadedCurrBytes]/1024.0);
        if (time != 0) {
            GT_OC_OUT_SET(@"实际带宽", YES, @"%.1fKB/S", [[ImageStat sharedInstance] downloadedCurrBytes]/time/1024.0);
        }
        NSLog(@"下载耗时：%.3fS 本次消耗流量：%.1fKB 实际带宽：%.1fKB/S", time, [[ImageStat sharedInstance] downloadedCurrBytes]/1024.0, [[ImageStat sharedInstance] downloadedCurrBytes]/time/1024.0);
    }
#endif
}

- (void)imageDownloader:(WebImageDownloader *)downloader didFinishWithImage:(UIImage *)image
{
    // Notify all the downloadDelegates with this downloader
    for (NSInteger idx = (NSInteger)[downloaders count] - 1; idx >= 0; idx--)
    {
        NSUInteger uidx = (NSUInteger)idx;
        WebImageDownloader *aDownloader = [downloaders objectAtIndex:uidx];
        if (aDownloader == downloader)
        {
            NSLog(@"url:%@ 下载完成", [[downloader url] absoluteString]);
            
            [self imageDownloadFinishCheck];
            id<WebImageManagerDelegate> delegate = [downloadDelegates objectAtIndex:uidx];
            
            if (image)
            {
                if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:)])
                {
                    [delegate performSelector:@selector(webImageManager:didFinishWithImage:) withObject:self withObject:image];
                   
                }
            }
            else
            {
                if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:)])
                {
                    [delegate performSelector:@selector(webImageManager:didFailWithError:) withObject:self withObject:nil];
                }
            }
            
            [downloaders removeObjectAtIndex:uidx];
            [downloadDelegates removeObjectAtIndex:uidx];
        }
    }
    
    if (image)
    {
        // Store the image in the cache
#ifndef GT_DEBUG_DISABLE
        // GT Usage(输入参数) 获取图片是否需要cache缓存的输入值
        NSString *needCached = GT_OC_IN_GET(@"Cache缓存", NO, @"false");
        if ([needCached isEqualToString:@"true"]) {
            [[ImageCache sharedImageCache] storeImage:image
                                            imageData:downloader.imageData
                                               forKey:[downloader.url absoluteString]
                                               toDisk:YES];
        }
#endif
    }
    else
    {
        // The image can't be downloaded from this URL, mark the URL as failed so we won't try and fail again and again
// 记录失败的url，可用于下次访问时直接拒绝
//        [failedURLs addObject:downloader.url];
    }
    
    
    // Release the downloader
    [downloaderForURL removeObjectForKey:downloader.url];
    
}

- (void)imageDownloader:(WebImageDownloader *)downloader didFailWithError:(NSError *)error;
{
    
    // Notify all the downloadDelegates with this downloader
    for (NSInteger idx = (NSInteger)[downloaders count] - 1; idx >= 0; idx--)
    {
        NSUInteger uidx = (NSUInteger)idx;
        WebImageDownloader *aDownloader = [downloaders objectAtIndex:uidx];
        if (aDownloader == downloader)
        {
            NSLog(@"url:%@ 下载失败 %@", [[downloader url] absoluteString], error);
            
            [self imageDownloadFinishCheck];
            id<WebImageManagerDelegate> delegate = [downloadDelegates objectAtIndex:uidx];
            
            if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:)])
            {
                [delegate performSelector:@selector(webImageManager:didFailWithError:) withObject:self withObject:error];
            }
            [downloaders removeObjectAtIndex:uidx];
            [downloadDelegates removeObjectAtIndex:uidx];
            
        }
    }
    
    // Release the downloader
    [downloaderForURL removeObjectForKey:downloader.url];
}

#pragma mark - Notification
- (void)handleDownloadFinish:(NSNotification *)notification
{
    NSDictionary* urlParam = [notification userInfo];
    NSString *result = [urlParam objectForKey:@"result"];
    WebImageDownloader *downloader = [urlParam objectForKey:@"downloader"];
    
    if ([result isEqualToString:@"success"]) {
        NSData *imageData = [urlParam objectForKey:@"imageData"];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [self imageDownloader:downloader didFinishWithImage:image];
        [image release];
    } else {
        NSError *error = [urlParam objectForKey:@"error"];
        [self imageDownloader:downloader didFailWithError:error];
    }
    
}

@end

