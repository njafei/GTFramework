//
//  ImageStat.m
//  Demo4GT
//
//  Created   on 13-6-6.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import "ImageStat.h"

@implementation ImageStat

M_DEF_SINGLETION(ImageStat);

@synthesize downloadedAllCnt        = _downloadedAllCnt;
@synthesize downloadedAllBytes      = _downloadedAllBytes;
@synthesize downloadedAllConsuming  = _downloadedAllConsuming;
@synthesize downloadedCurrCnt       = _downloadedCurrCnt;
@synthesize downloadedCurrBytes     = _downloadedCurrBytes;
@synthesize downloadedCurrConsuming = _downloadedCurrConsuming;


- (id)init
{
    self = [super init];
    if (self) {
        _downloadedAllCnt        = 0;
        _downloadedCurrCnt       = 0;
        _downloadedCurrBytes     = 0;
        _downloadedCurrConsuming = 0;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)incDownloadedCnt
{
    _downloadedAllCnt++;
    _downloadedCurrCnt++;
}

- (void)clearDownloadedCurr
{
    _downloadedCurrCnt       = 0;
    _downloadedCurrBytes     = 0;
    _downloadedCurrConsuming = 0;
}


- (void)addDownloadedCurrBytes:(NSUInteger)downloadedBytes
{
    _downloadedCurrBytes += downloadedBytes;
    _downloadedAllBytes += downloadedBytes;
}

- (void)addDownloadedCurrConsuming:(NSTimeInterval)downloadedConsuming
{
    _downloadedCurrConsuming += downloadedConsuming;
    _downloadedAllConsuming += downloadedConsuming;
}

- (float)downloadedCurrSpeed
{
    if (_downloadedCurrConsuming == 0) {
        return 0;
    }
    
    return _downloadedCurrBytes/_downloadedCurrConsuming;
}

- (float)downloadedAllSpeed
{
    if (_downloadedAllConsuming == 0) {
        return 0;
    }
    
    return _downloadedAllBytes/_downloadedAllConsuming;
}

@end
