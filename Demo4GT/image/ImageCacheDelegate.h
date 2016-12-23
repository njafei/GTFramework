//
//  ImageCacheDelegate.h
//  Demo4GT
//
//  Created   on 13-6-4.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import <Foundation/Foundation.h>

@class ImageCache;

@protocol ImageCacheDelegate <NSObject>

@optional
- (void)imageCache:(ImageCache *)imageCache didFindImage:(UIImage *)image forKey:(NSString *)key userInfo:(NSDictionary *)info;
- (void)imageCache:(ImageCache *)imageCache didNotFindImageForKey:(NSString *)key userInfo:(NSDictionary *)info;

@end
