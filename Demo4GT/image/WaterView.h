//
//  WaterView.h
//  Demo4GT
//
//  Created   on 13-6-4.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import <UIKit/UIKit.h>
#import "MessView.h"


@interface WaterView : UIScrollView<imageDelegate>
{
    UIView *v1;// 第一列view
    UIView *v2;// 第二列view
    UIView *v3;// 第三列view
    
    int higher;//最高列
    int lower;//最低列
    float highValue;//最高列高度
    
    int row ;//行数
    BOOL _reloading;
}

//初始化view
-(id)initWithDataArray:(NSMutableArray *)array;
//刷新view
-(void)refreshView:(NSMutableArray *)array;
//获取下一页
-(void)getNextPage:(NSMutableArray *)array;
@end
