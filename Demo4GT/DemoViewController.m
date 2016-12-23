//
//  DemoViewController.m
//  Demo4GT
//
//  Created   on 13-6-3.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import "DemoViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import "GT/GT.h"
#import "ImageButton.h"
#import "DataAccess.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

@synthesize waterView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.waterView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initUI];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)rightBarButtonItems
{
    UIView *barView = nil;
    UIButton *barBtn = nil;
    
    barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 44.0)];
    barBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 44.0)];
    [barBtn addTarget:self action:@selector(onClickRefreshPic) forControlEvents:UIControlEventTouchUpInside];
    [barBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 4)];
//    [barBtn setTitle:@"Refresh" forState:UIControlStateNormal];
//    [barBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [barBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [barView addSubview:barBtn];
    [barBtn release];
    
    UIBarButtonItem *bar1 = nil;
    bar1 = [[UIBarButtonItem alloc] initWithCustomView:barView];
    [barView release];
    
    NSArray *array = [NSArray arrayWithObjects:bar1, nil];
    [bar1 release];
    
    return array;
}

- (void)initUI
{
    [self setTitle:@"IN Demo"];
    [self.view setBackgroundColor:[UIColor grayColor]];
    [self.navigationItem setRightBarButtonItems:[self rightBarButtonItems] animated:YES];
        NSMutableArray *dataArray = [DataAccess getDateArray];

    self.waterView = [[[WaterView alloc] initWithDataArray:dataArray] autorelease];
    self.waterView.delegate = self;
    [self.view addSubview:self.waterView];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
}

- (void)onClickRefreshPic
{
    NSMutableArray *dataArray = [DataAccess getDateArray];
    [self.waterView refreshView:dataArray];
}

- (void)onClickPic
{
    
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[self.waterView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

-(void)setFooterView{
//    UIEdgeInsets test = self.waterView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.waterView.contentSize.height, self.waterView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.waterView.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.waterView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.waterView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark-
#pragma mark force to show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.waterView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.waterView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        self.waterView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.waterView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
	}
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
}
//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
    
	// overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.waterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.waterView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

//刷新调用的方法
-(void)refreshView{
    NSMutableArray *dataArray = [DataAccess getDateArray];
    [self.waterView refreshView:dataArray];
    [self testFinishedLoadData];
    
}
//加载调用的方法
-(void)getNextPageView{
    [self removeFooterView];
    NSMutableArray *dataArray = [DataAccess getDateArray];

    [self.waterView getNextPage:dataArray];
    [self testFinishedLoadData];
    
}-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
}

@end
