//
//  WaterView.m
//  Demo4GT
//
//  Created   on 13-6-4.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import "WaterView.h"
#import "WebImageManager.h"
#import "ImageStat.h"


#undef	M_SAFE_RELEASE_SUBVIEW
#define M_SAFE_RELEASE_SUBVIEW( __x ) if (__x)\
{ \
[__x removeFromSuperview]; \
[__x release]; \
__x = nil; \
}

@implementation WaterView

- (void)dealloc
{
    [v1 release];
    [v2 release];
    [v3 release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

//初始化视图
-(id)initWithDataArray:(NSMutableArray *)array{
    
    self=[super initWithFrame:CGRectMake(0, 0, M_GT_DEMO_SCREEN_WIDTH, M_GT_DEMO_FULL_SCREEN_HEIGHT - 64)];
    if (self) {
#ifndef GT_DEBUG_DISABLE

        // GT Usage(输出参数) 清除输出参数上一次数据
//        GT_OC_OUT_SET(@"singlePicSpeed", NO, @"0KB/S");
//        GT_OC_OUT_SET(@"下载耗时", NO, @"0S");
//        GT_OC_OUT_SET(@"本次消耗流量", NO, @"0KB");
//        GT_OC_OUT_SET(@"实际带宽", NO, @"0KB/S");
        
        // GT Usage(profiler) 图片下载总时间开始
        GT_OC_TIME_START(@"PIC", @"ALL");
#endif
        [[ImageStat sharedInstance] clearDownloadedCurr];
        [self initProperty];//初始化参数
        for (int i=0; i<array.count; i++) {
            if (i/3>0&&i%3==0) {
                row++;
            }
            DataInfo *data = (DataInfo*)[array objectAtIndex:i];
            
            [self addMessView:lower DataInfo:data];
            
            //重新判断最高和最低view
            [self getHViewAndLView];
            
            
        }
        //添加scrollView
        [self setContentSize:CGSizeMake(M_GT_DEMO_SCREEN_WIDTH, highValue)];
        [self addSubview:v1];
        [self addSubview:v2];
        [self addSubview:v3];
        
    }
    return self;
}
//初始化参数
-(void)initProperty{
    row =1;
    //初始化第一列视图
    v1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    //初始化第二列视图
    v2 = [[UIView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, 0)];
    //初始化第三列视图
    v3 = [[UIView alloc]initWithFrame:CGRectMake(WIDTH*2,0, WIDTH, 0)];
    
    //初始化最高视图
    higher =1;
    //初始化最低视图
    lower=1;
    highValue=1;
    
    
}

//向视图添加MessView
-(void)addMessView:(int)lValue DataInfo:(DataInfo *)data{
    MessView *mView=nil;
    float hValue=0;
    switch (lValue) {
        case 1:
            // 创建内容视图
            mView = [[MessView alloc] initWithData:data yPoint:v1.frame.size.height];
            hValue = mView.frame.size.height;
            v1.frame = CGRectMake(v1.frame.origin.x, v1.frame.origin.y, WIDTH, v1.frame.size.height+hValue);
            [v1 addSubview:mView];
            [mView release];
            break;
        case 2:
            // 创建内容视图
            mView = [[MessView alloc]initWithData:data yPoint:v2.frame.size.height];
            hValue = mView.frame.size.height;
            v2.frame = CGRectMake(v2.frame.origin.x, v2.frame.origin.y, WIDTH, v2.frame.size.height+hValue);
            [v2 addSubview:mView];
            [mView release];
            break;
        case 3:
            // 创建内容视图
            mView = [[MessView alloc]initWithData:data yPoint:v3.frame.size.height];
            hValue = mView.frame.size.height;
            v3.frame = CGRectMake(v3.frame.origin.x, v3.frame.origin.y, WIDTH, v3.frame.size.height+hValue);
            [v3 addSubview:mView];
            [mView release];
            break;
            
        default:
            break;
    }
    
    
}
-(void)getHViewAndLView{
    
    
    if (v1.frame.size.height >= highValue) {
        highValue = v1.frame.size.height;
        higher = 1;
    }else if(v2.frame.size.height >= highValue) {
        highValue = v2.frame.size.height;
        higher = 2;
    }else if(v3.frame.size.height >= highValue) {
        highValue = v3.frame.size.height;
        higher = 3;
    }
    float v1Height = v1.frame.size.height;
    float v2Height = v2.frame.size.height;
    float v3Height = v3.frame.size.height;
    if (v1Height <= v2Height) {
        if (v1Height <= v3Height) {
            lower = 1;
        }else{
            lower = 3;
        }
    }else{
        if (v2Height <= v3Height) {
            lower = 2;
        }else{
            lower = 3;
        }
    }
    
}

//加载数据
-(void)getNextPage:(NSMutableArray *)array
{
    for (int i=0; i<array.count; i++) {
        if (i/3>0&&i%3==0) {
            row++;
        }
        DataInfo *data = (DataInfo*)[array objectAtIndex:i];
        
        [self addMessView:lower DataInfo:data];
        
        //重新判断最高和最低view
        [self getHViewAndLView];
    }
    //添加scrollView
    [self setContentSize:CGSizeMake(M_GT_DEMO_SCREEN_WIDTH, highValue)];
}

-(void)refreshView:(NSMutableArray *)array{
    [[WebImageManager sharedManager] cancelCurrentDownloading];
#ifndef GT_DEBUG_DISABLE
    // GT Usage(输出参数) 清除输出参数上一次数据
//    GT_OC_OUT_SET(@"singlePicSpeed", NO, @"0KB/S");
//    GT_OC_OUT_SET(@"下载耗时", NO, @"0S");
//    GT_OC_OUT_SET(@"本次消耗流量", NO, @"0KB");
//    GT_OC_OUT_SET(@"实际带宽", NO, @"0KB/S");
    // GT Usage(profiler) 图片下载总时间开始
    GT_OC_TIME_START(@"PIC", @"ALL");
#endif
    [[ImageStat sharedInstance] clearDownloadedCurr];

    M_SAFE_RELEASE_SUBVIEW(v1);
    M_SAFE_RELEASE_SUBVIEW(v2);
    M_SAFE_RELEASE_SUBVIEW(v3);
    
    row =1;
    
    [self initProperty];//初始化参数
    for (int i=0; i<array.count; i++) {
        if (i/3>0&&i%3==0) {
            row++;
        }
        DataInfo *data = (DataInfo*)[array objectAtIndex:i];
        
        [self addMessView:lower DataInfo:data];
        
        //重新判断最高和最低view
        [self getHViewAndLView];
    }
    
    //添加scrollView
    [self setContentSize:CGSizeMake(M_GT_DEMO_SCREEN_WIDTH, highValue)];
    [self addSubview:v1];
    [self addSubview:v2];
    [self addSubview:v3];
}

#pragma mark - imageDelegate
-(void)click:(DataInfo *)data
{
    NSLog(@"click %@", [data title]);
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

