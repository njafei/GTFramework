//
//  WebImageDownloader.h
//  Demo4GT
//
//  Created   on 13-6-4.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import <Foundation/Foundation.h>
#import "WebImageDownloaderDelegate.h"


#define WebImageDownloadStartNotification  @"WebImageDownloadStartNotification"
#define WebImageDownloadStopNotification   @"WebImageDownloadStopNotification"
#define WebImageDownloadFinishNotification @"WebImageDownloadFinishNotification"


@interface WebImageDownloader : NSOperation
{
@private
    BOOL _bExecuting;
    BOOL _bFinished;
    BOOL _bCancelled;
    
    NSURL *url;
    id<WebImageDownloaderDelegate> delegate;
    NSURLConnection *connection;
    NSDate          *startDate;
    NSMutableData   *imageData;
    id userInfo;
    BOOL lowPriority;
}

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) id<WebImageDownloaderDelegate> delegate;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, strong) NSMutableData *imageData;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, readwrite) BOOL lowPriority;


+ (id)downloaderWithURL:(NSURL *)url delegate:(id<WebImageDownloaderDelegate>)delegate userInfo:(id)userInfo lowPriority:(BOOL)lowPriority;
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<WebImageDownloaderDelegate>)delegate userInfo:(id)userInfo;
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<WebImageDownloaderDelegate>)delegate;
+ (void)setMaxConcurrentDownloads:(NSUInteger)max;

- (void)start;
- (void)cancel;


@end
