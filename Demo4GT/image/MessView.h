//
//  MessView.h
//  Demo4GT
//
//  Created   on 13-6-4.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import <UIKit/UIKit.h>

#import "DataInfo.h"

#define M_GT_DEMO_SCREEN_WIDTH ([[UIScreen mainScreen] applicationFrame].size.width)
#define M_GT_DEMO_FULL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


#define WIDTH M_GT_DEMO_SCREEN_WIDTH/3



@protocol imageDelegate <NSObject>

-(void)click:(DataInfo *)data;

@end

@interface MessView : UIView
@property(nonatomic,strong)DataInfo *dataInfo;
@property(nonatomic,strong)id<imageDelegate> idelegate;

-(id)initWithData:(DataInfo *)data yPoint:(float) y;

-(void)click;
@end
