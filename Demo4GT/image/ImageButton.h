//
//  ImageButton.h
//  Demo4GT
//
//  Created   on 13-6-4.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import <UIKit/UIKit.h>
#import "WebImageManager.h"
#import "WebImageManagerDelegate.h"

@interface ImageButton : UIButton <WebImageManagerDelegate> {
    NSInteger iconIndex;
    
	CGSize scaleSize;
	BOOL    isScale;
	
	BOOL    _animated;
	BOOL    _isBackgroundImage;
}

@property (nonatomic, assign) NSInteger iconIndex;

-(UIImage*) getDefaultImage;

- (void) setImageFromUrl:(BOOL)animated withUrl:(NSString *)iconUrl;
- (void) setBackgroundImageFromUrl:(BOOL)animated withUrl:(NSString *)iconUrl;

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)cancelCurrentImageLoad;

@end
