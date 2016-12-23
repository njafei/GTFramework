//
//  WebImageDownloader.m
//  Demo4GT
//
//  Created   on 13-6-4.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import "WebImageDownloader.h"
#import "ImageStat.h"


@interface WebImageDownloader ()
@property (nonatomic, retain) NSURLConnection *connection;
@end

@implementation WebImageDownloader
@synthesize url, delegate, connection, imageData, userInfo, lowPriority;
@synthesize startDate;

#pragma mark Public Methods

+ (id)downloaderWithURL:(NSURL *)url delegate:(id<WebImageDownloaderDelegate>)delegate
{
    return [self downloaderWithURL:url delegate:delegate userInfo:nil];
}

+ (id)downloaderWithURL:(NSURL *)url delegate:(id<WebImageDownloaderDelegate>)delegate userInfo:(id)userInfo
{
    
    return [self downloaderWithURL:url delegate:delegate userInfo:userInfo lowPriority:NO];
}

+ (id)downloaderWithURL:(NSURL *)url delegate:(id<WebImageDownloaderDelegate>)delegate userInfo:(id)userInfo lowPriority:(BOOL)lowPriority
{
    // To use it, just add #import "SDNetworkActivityIndicator.h" in addition to the SDWebImage import
    if (NSClassFromString(@"NetworkActivityIndicator"))
    {
        id activityIndicator = [NSClassFromString(@"NetworkActivityIndicator") performSelector:NSSelectorFromString(@"sharedActivityIndicator")];
        [[NSNotificationCenter defaultCenter] addObserver:activityIndicator
                                                 selector:NSSelectorFromString(@"startActivity")
                                                     name:WebImageDownloadStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:activityIndicator
                                                 selector:NSSelectorFromString(@"stopActivity")
                                                     name:WebImageDownloadStopNotification object:nil];
    }
    
    
    
    WebImageDownloader *downloader = [[[WebImageDownloader alloc] init] autorelease];
    downloader.url = url;
    downloader.delegate = delegate;
    downloader.userInfo = userInfo;
    downloader.lowPriority = lowPriority;
//    [downloader performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:YES];
    return downloader;
}

- (id)init
{
    self = [super init];
    if (self) {
        _bFinished = NO;
    }
    
    return self;
}

- (void)dealloc {
    self.url = nil;
    self.connection = nil;
    self.imageData = nil;
    self.startDate = nil;
    [super dealloc];
}

+ (void)setMaxConcurrentDownloads:(NSUInteger)max
{
    // NOOP
}

// 如果不重载下面的函数，异步方式调用会出错
-(BOOL)isConcurrent {
  return YES;//返回yes表示支持异步调用，否则为支持同步调用
}

- (BOOL)isExecuting
{
    return _bExecuting;
}

- (BOOL)isFinished
{
    return _bFinished;
}

- (BOOL)isCancelled
{
    return _bCancelled;
}

- (void)start
{
    if (![self isCancelled]) {
        // 以异步方式处理事件，并设置代理
        
        // In order to prevent from potential duplicate caching (NSURLCache + SDImageCache) we disable the cache for image requests
        NSString *timeoutStr = @"40";
        NSString *kaliveStr = @"true";
#ifndef GT_DEBUG_DISABLE
        // GT Usage(日志) 打印日志
        GT_OC_LOG_D(@"ImageDownloader", @"start download...");
        // GT Usage(输入参数) 获取url请求超时和keep-alive的参数
        timeoutStr = GT_OC_IN_GET(@"读超时", NO, @"40");
        kaliveStr = GT_OC_IN_GET(@"KeepAlive", NO, @"true");
#endif
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:[timeoutStr floatValue]] autorelease];
        if ([kaliveStr isEqualToString:@"false"]) {
            [request setValue:@"Keep-Alive\r\n" forHTTPHeaderField:@"false"];
        } else {
            [request setValue:@"Keep-Alive\r\n" forHTTPHeaderField:@"true"];
        }
        
        
        self.connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO] autorelease];
        
        // If not in low priority mode, ensure we aren't blocked by UI manipulations (default runloop mode for NSURLConnection is NSEventTrackingRunLoopMode)
        if (!lowPriority)
        {
            [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        }
        [connection start];
        [self setStartDate:[NSDate date]];

#ifndef GT_DEBUG_DISABLE
        // GT Usage(profiler) 开始记录时间
        GT_OC_TIME_START_IN_THREAD(@"Downloader", @"网络图片获取");
#endif
        if (connection)
        {
            self.imageData = [NSMutableData data];
            [[NSNotificationCenter defaultCenter] postNotificationName:WebImageDownloadStartNotification object:nil];
        }
        else
        {
            if ([delegate respondsToSelector:@selector(imageDownloader:didFailWithError:)])
            {
                [delegate performSelector:@selector(imageDownloader:didFailWithError:) withObject:self withObject:nil];
                _bFinished = YES;
                return;
            }
        }
        //下面建立一个循环直到连接终止，使线程不离开主方法，否则connection的delegate方法不会被调用,因为主方法结束对象的生命周期即终止
        
        //这个问题参考http://www.cocoabuilder.com/archive/cocoa/279826-nsurlrequest-and-nsoperationqueue.html
        while(connection != nil) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        _bFinished = YES;
    }
}

- (void)cancel
{
    if (connection)
    {
        [connection cancel];
        self.connection = nil;
        _bCancelled = YES;
        _bFinished = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:WebImageDownloadStopNotification object:nil];
    }
}

#pragma mark NSURLConnection (delegate)

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data
{
    if (_bFinished || _bCancelled) {
        return;
    }
//    NSLog(@"正在下载的是%@",url);
    [imageData appendData:data];
}

#pragma GCC diagnostic ignored "-Wundeclared-selector"
- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    if (_bFinished || _bCancelled) {
        return;
    }
    self.connection = nil;
    
#ifndef GT_DEBUG_DISABLE
    // GT Usage(profiler) 结束记录时间
    GT_OC_TIME_END_IN_THREAD(@"Downloader", @"网络图片获取");
#endif
    [[NSNotificationCenter defaultCenter] postNotificationName:WebImageDownloadStopNotification object:nil];
    
    
    NSUInteger bytes = [imageData length];
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:startDate];
    
#ifndef GT_DEBUG_DISABLE
    // GT Usage(日志) 打印日志
    GT_OC_LOG_D(@"ImageDownloader", @"end download 下载图片大小：%.3fKB", bytes/1024.0);
#endif
    if (time != 0) {
#ifndef GT_DEBUG_DISABLE
        // GT Usage(输出参数) 输出单张图片下载信息
        GT_OC_OUT_SET(@"singlePicSpeed", YES, @"%.1fKB/S", bytes/time/1024.0);
        NSLog(@"下载图片大小：%.3fKB 速度：%.1fKB/S", bytes/1024.0, bytes/time/1024.0);
#endif
        [[ImageStat sharedInstance] incDownloadedCnt];
        [[ImageStat sharedInstance] addDownloadedCurrBytes:bytes];
        [[ImageStat sharedInstance] addDownloadedCurrConsuming:time];
#ifndef GT_DEBUG_DISABLE
        GT_OC_OUT_SET(@"numberOfDownloadedPics", YES, @"%u", [[ImageStat sharedInstance] downloadedCurrCnt]);
#endif
    }
    
    NSDictionary* dic = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dic setValue:self forKey:@"downloader"];
    [dic setValue:@"success" forKey:@"result"];
    [dic setValue:imageData forKey:@"imageData"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WebImageDownloadFinishNotification object:nil userInfo:dic];
    return;
    
    if ([delegate respondsToSelector:@selector(imageDownloaderDidFinish:)])
    {
        [delegate performSelector:@selector(imageDownloaderDidFinish:) withObject:self];
    }
    
    if ([delegate respondsToSelector:@selector(imageDownloader:didFinishWithImage:)])
    {
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [delegate performSelector:@selector(imageDownloader:didFinishWithImage:) withObject:self withObject:image];
        
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_bFinished || _bCancelled) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:WebImageDownloadStopNotification object:nil];
    
#ifndef GT_DEBUG_DISABLE
    // GT Usage(profiler) 结束记录时间，失败场景
    GT_OC_TIME_END_IN_THREAD(@"Downloader", @"网络图片获取");
    GT_OC_LOG_D(@"ImageDownloader", @"didFailWithError:%u %@ %@", [error code], [error localizedFailureReason], [error localizedDescription]);
#endif
    NSDictionary* dic = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dic setValue:self forKey:@"downloader"];
    [dic setValue:@"fail" forKey:@"result"];
    [dic setValue:error forKey:@"error"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WebImageDownloadFinishNotification object:nil userInfo:dic];
    
    self.connection = nil;
    self.imageData = nil;
    return;
    if ([delegate respondsToSelector:@selector(imageDownloader:didFailWithError:)])
    {
        [delegate performSelector:@selector(imageDownloader:didFailWithError:) withObject:self withObject:error];
    }
    
}



@end

