//
//  DemoViewController.h
//  Demo4GT
//
//  Created   on 13-6-3.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "WaterView.h"

@interface DemoViewController : UIViewController <EGORefreshTableDelegate,UIScrollViewDelegate>
{
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;

}
@property(nonatomic,strong)WaterView *waterView;

@end
