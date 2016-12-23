//
//  ImageStat.h
//  Demo4GT
//
//  Created   on 13-6-6.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import <Foundation/Foundation.h>
#import "macroDef.h"

@interface ImageStat : NSObject
{
    NSUInteger     _downloadedAllCnt;
    NSUInteger     _downloadedAllBytes;
    NSTimeInterval _downloadedAllConsuming;
    
    NSUInteger     _downloadedCurrCnt;
    NSUInteger     _downloadedCurrBytes;
    NSTimeInterval _downloadedCurrConsuming;
}

M_AS_SINGLETION(ImageStat);

@property (nonatomic, assign) NSUInteger     downloadedAllCnt;
@property (nonatomic, assign) NSUInteger     downloadedAllBytes;
@property (nonatomic, assign) NSTimeInterval downloadedAllConsuming;
@property (nonatomic, assign) NSUInteger     downloadedCurrCnt;
@property (nonatomic, assign) NSUInteger     downloadedCurrBytes;
@property (nonatomic, assign) NSTimeInterval downloadedCurrConsuming;


- (void)incDownloadedCnt;
- (void)clearDownloadedCurr;

- (void)addDownloadedCurrBytes:(NSUInteger)downloadedBytes;
- (void)addDownloadedCurrConsuming:(NSTimeInterval)downloadedConsuming;
- (float)downloadedCurrSpeed;
- (float)downloadedAllSpeed;

@end
