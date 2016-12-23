//
//  WebImageManager.h
//  Demo4GT
//
//  Created   on 13-6-4.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import <Foundation/Foundation.h>
#import "WebImageDownloaderDelegate.h"
#import "WebImageManagerDelegate.h"
#import "ImageCache.h"

@interface WebImageManager : NSObject <WebImageDownloaderDelegate, ImageCacheDelegate>
{
    NSMutableArray *downloadDelegates;
    NSMutableArray *downloaders;
    NSMutableArray *cacheDelegates;
    NSMutableDictionary *downloaderForURL;
    NSMutableArray *failedURLs;
    
    NSOperationQueue *downloadQueue;
    NSUInteger       downloadCount;
}

+ (id)sharedManager;
- (UIImage *)imageWithURL:(NSURL *)url;
- (void)downloadWithURL:(NSURL *)url delegate:(id<WebImageManagerDelegate>)delegate;
- (void)downloadWithURL:(NSURL *)url delegate:(id<WebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed;
- (void)downloadWithURL:(NSURL *)url delegate:(id<WebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed lowPriority:(BOOL)lowPriority;
- (void)cancelForDelegate:(id<WebImageManagerDelegate>)delegate;
- (void)cancelCurrentDownloading;

@end
