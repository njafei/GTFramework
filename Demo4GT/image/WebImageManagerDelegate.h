//
//  WebImageManagerDelegate.h
//  Demo4GT
//
//  Created   on 13-6-4.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import <Foundation/Foundation.h>

@class WebImageManager;

@protocol WebImageManagerDelegate <NSObject>
@optional

- (void)webImageManager:(WebImageManager *)imageManager didFinishWithImage:(UIImage *)image;
- (void)webImageManager:(WebImageManager *)imageManager didFailWithError:(NSError *)error;

@end
