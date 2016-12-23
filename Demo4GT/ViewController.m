//
//  ViewController.m
//  Demo4GT
//
//  Created   on 13-6-3.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GT/GT.h"
#import "DemoViewController.h"
#import <sys/sysctl.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc
{
    [_label1 release];
    [_label2 release];
    [_btn1 release];
    [_btn2 release];
    [_btn3 release];
    [_btn4 release];
    [_btn5 release];
    [_btn6 release];
    [_btn7 release];
    [_btn8 release];
    [_locationManager release];
    if (_addedMem != nil) {
        free(_addedMem);
        _addedMem = nil;
    }
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    GT_OC_LOG_D(@"mem warning", @"did received memory warning");
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (UIInterfaceOrientationMaskPortrait == interfaceOrientation);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGRect frame = self.view.frame;
    
    //坐标对换一下
    CGFloat width = frame.size.width;
    frame.size.width = frame.size.height;
    frame.size.height = width;
    
    [self layoutView];
}

- (void)layoutView
{
    NSString *text  = nil;
    CGFloat  btnHeight = 50;
    CGFloat  screenWidth = 0;
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    if (([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft) || ([self interfaceOrientation] == UIInterfaceOrientationLandscapeRight)) {
        //坐标对换一下
        CGFloat width = frame.size.width;
        frame.size.width = frame.size.height;
        frame.size.height = width;
    }
    
    frame.origin.x = 5;
    frame.origin.y = 5;
    frame.size.height = btnHeight;
    frame.size.width -= 2*frame.origin.x;
    
    screenWidth = frame.size.width;
    
    CGFloat btnWidth = frame.size.width/3;
    
    //    text = @"隐藏GT图标";
    [_label1 setFrame:frame];
    
    
    frame.origin.x = 5;
    frame.origin.y += frame.size.height + 5;
    frame.size.width = btnWidth - 5;
    frame.size.height = btnHeight;
    [_btn1 setFrame:frame];
    
    
    frame.origin.x = 5 + btnWidth;
    frame.size.height = btnHeight;
    [_btn2 setFrame:frame];
    
    frame.origin.x = 5 + btnWidth*2;
    frame.size.height = btnHeight;
    [_btn3 setFrame:frame];
    
    text = @"0、点击下方\"Into Demo\"进入demo \r1、demo演示了从网络下载10张图片并显示到界面上的简单功能\r2、连接方式、线程数到底该设置多少？可以通过“输入参数”实时调整尝试\r3、设置的值是否更合理？可以通过“输出参数”在悬浮窗中实时观察结果\r4、设置的值对性能消耗如何？可以通过GT控制台的Profiler界面实时展示性能统计数据（线程中、线程间耗时）";
    
    frame.origin.x = 5;
    frame.origin.y += frame.size.height + 5;
    frame.size.width = screenWidth - 2*frame.origin.x;
    CGSize constrainedToSize = CGSizeMake(frame.size.width, 900);
    frame.size.height = [text sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:constrainedToSize].height;
    [_label2 setFrame:frame];
    _label2.text = text;
    
}

- (void)initUI
{
    NSString *text  = nil;
    CGFloat  btnHeight = 50;
    CGFloat  screenWidth = 0;
    
    [self setTitle:@"GT Demo"];
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    if (([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft) || ([self interfaceOrientation] == UIInterfaceOrientationLandscapeRight)) {
        //坐标对换一下
        CGFloat width = frame.size.width;
        frame.size.width = frame.size.height;
        frame.size.height = width;
    }
    
    frame.origin.x = 5;
    frame.origin.y = 5;
    frame.size.height = btnHeight;
    frame.size.width -= 2*frame.origin.x;
    
    screenWidth = frame.size.width;
    
    CGFloat btnWidth = frame.size.width/4;
    
    text = @"点击下面按钮更多体验";
    frame.size.height = [text sizeWithFont:[UIFont systemFontOfSize:15.0]].height;
    _label1 = [[UILabel alloc] initWithFrame:frame];
    _label1.text = text;
    _label1.font = [UIFont systemFontOfSize:15.0];
    _label1.textColor = [UIColor blackColor];
    _label1.textAlignment = NSTextAlignmentLeft;
    _label1.lineBreakMode = NSLineBreakByWordWrapping;
    _label1.numberOfLines = 0;
    _label1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_label1];
    
    frame.origin.x = 5;
    frame.origin.y += frame.size.height + 5;
    frame.size.width = btnWidth - 5;
    frame.size.height = btnHeight;
    _btn1 = [[UIButton alloc] initWithFrame:frame];
    [_btn1 addTarget:self action:@selector(onClickShowGT) forControlEvents:UIControlEventTouchUpInside];
    [_btn1.titleLabel setTextColor:[UIColor whiteColor]];
    [_btn1 setTitle:@"HIDE GT" forState:UIControlStateNormal];
    [_btn1.titleLabel setFont:[UIFont systemFontOfSize:12]];
    //    _btn2.backgroundColor = [UIColor blackColor];
    _btn1.layer.borderColor = [UIColor blackColor].CGColor;
    _btn1.layer.borderWidth = 1.0f;
    [self.view addSubview:_btn1];
    
    frame.origin.x = 5 + btnWidth;
    frame.size.height = btnHeight;
    
    _btn2 = [[UIButton alloc] initWithFrame:frame];
    [_btn2 addTarget:self action:@selector(onClickToDemo) forControlEvents:UIControlEventTouchUpInside];
    [_btn2.titleLabel setTextColor:[UIColor whiteColor]];
    [_btn2 setTitle:@"Into Demo" forState:UIControlStateNormal];
    [_btn2.titleLabel setFont:[UIFont systemFontOfSize:12]];
    //    _btn2.backgroundColor = [UIColor blackColor];
    _btn2.layer.borderColor = [UIColor blackColor].CGColor;
    _btn2.layer.borderWidth = 1.0f;
    [self.view addSubview:_btn2];
    
    frame.origin.x = 5 + btnWidth*2;
    frame.size.height = btnHeight;
    _btn3 = [[UIButton alloc] initWithFrame:frame];
    [_btn3 addTarget:self action:@selector(onClickCrash) forControlEvents:UIControlEventTouchUpInside];
    [_btn3.titleLabel setTextColor:[UIColor whiteColor]];
    [_btn3 setTitle:@"Click Crash" forState:UIControlStateNormal];
    [_btn3.titleLabel setFont:[UIFont systemFontOfSize:12]];
    _btn3.layer.borderColor = [UIColor blackColor].CGColor;
    _btn3.layer.borderWidth = 1.0f;
    [self.view addSubview:_btn3];
    
    _highCPU = NO;
    frame.origin.x = 5 + btnWidth*3;
    frame.size.height = btnHeight;
    _btn4 = [[UIButton alloc] initWithFrame:frame];
    [_btn4 addTarget:self action:@selector(onHighCPU) forControlEvents:UIControlEventTouchUpInside];
    [_btn4.titleLabel setTextColor:[UIColor whiteColor]];
    [_btn4 setTitle:@"High CPU" forState:UIControlStateNormal];
    [_btn4.titleLabel setFont:[UIFont systemFontOfSize:12]];
    _btn4.layer.borderColor = [UIColor blackColor].CGColor;
    _btn4.layer.borderWidth = 1.0f;
    [self.view addSubview:_btn4];
    
    _highMem = NO;
    _addedMem = nil;
    frame.origin.x = 5;
    frame.origin.y += btnHeight + 5;
    _btn5 = [[UIButton alloc] initWithFrame:frame];
    [_btn5 addTarget:self action:@selector(onHighMemory) forControlEvents:UIControlEventTouchUpInside];
    [_btn5.titleLabel setTextColor:[UIColor whiteColor]];
    [_btn5 setTitle:@"High Mem" forState:UIControlStateNormal];
    [_btn5.titleLabel setFont:[UIFont systemFontOfSize:12]];
    _btn5.layer.borderColor = [UIColor blackColor].CGColor;
    _btn5.layer.borderWidth = 1.0f;
    [self.view addSubview:_btn5];
    
    frame.origin.x += btnWidth;
    //    frame.origin.y += btnHeight + 5;
    _btn6 = [[UIButton alloc] initWithFrame:frame];
    [_btn6 addTarget:self action:@selector(onHighBattery) forControlEvents:UIControlEventTouchUpInside];
    [_btn6.titleLabel setTextColor:[UIColor whiteColor]];
    [_btn6 setTitle:@"High Battery" forState:UIControlStateNormal];
    [_btn6.titleLabel setFont:[UIFont systemFontOfSize:12]];
    _btn6.layer.borderColor = [UIColor blackColor].CGColor;
    _btn6.layer.borderWidth = 1.0f;
    [self.view addSubview:_btn6];
    _highBattery = NO;
    
    frame.origin.x += btnWidth;
    _btn7 = [[UIButton alloc] initWithFrame:frame];
    [_btn7 addTarget:self action:@selector(onStartTest) forControlEvents:UIControlEventTouchUpInside];
    [_btn7.titleLabel setTextColor:[UIColor whiteColor]];
    [_btn7 setTitle:@"Start Test" forState:UIControlStateNormal];
    [_btn7.titleLabel setFont:[UIFont systemFontOfSize:12]];
    _btn7.layer.borderColor = [UIColor blackColor].CGColor;
    _btn7.layer.borderWidth = 1.0f;
    [self.view addSubview:_btn7];
    
    frame.origin.x += btnWidth;
    _btn8 = [[UIButton alloc] initWithFrame:frame];
    [_btn8 addTarget:self action:@selector(onStopTest) forControlEvents:UIControlEventTouchUpInside];
    [_btn8.titleLabel setTextColor:[UIColor whiteColor]];
    [_btn8 setTitle:@"Stop Test" forState:UIControlStateNormal];
    [_btn8.titleLabel setFont:[UIFont systemFontOfSize:12]];
    _btn8.layer.borderColor = [UIColor blackColor].CGColor;
    _btn8.layer.borderWidth = 1.0f;
    [self.view addSubview:_btn8];
    
    text = @"0、点击下方\"Into Demo\"进入demo \r1、demo演示了从网络下载10张图片并显示到界面上的简单功能\r2、连接方式、线程数到底该设置多少？可以通过“输入参数”实时调整尝试\r3、设置的值是否更合理？可以通过“输出参数”在悬浮窗中实时观察结果\r4、设置的值对性能消耗如何？可以通过GT控制台的Profiler界面实时展示性能统计数据（线程中、线程间耗时）";
    
    frame.origin.x = 5;
    frame.origin.y += frame.size.height + 5;
    frame.size.width = screenWidth - 2*frame.origin.x;
    CGSize constrainedToSize = CGSizeMake(frame.size.width, 900);
    frame.size.height = [text sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:constrainedToSize].height;
    
    _label2 = [[UILabel alloc] initWithFrame:frame];
    _label2.text = text;
    _label2.font = [UIFont systemFontOfSize:15.0];
    _label2.textColor = [UIColor blackColor];
    _label2.textAlignment = NSTextAlignmentLeft;
    _label2.lineBreakMode = NSLineBreakByWordWrapping;
    _label2.numberOfLines = 0;
    _label2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_label2];
}

- (void)test
{
    @autoreleasepool {
        NSDate *start = [NSDate date];
        
        
        for(int i = 0;i < 10000000; i++) {
            
            //c=14.923332
            //            double seconds = time(NULL);
            
            //c=14.303930
            //            struct  timeval    tv;
            //            struct  timezone   tz;
            //            gettimeofday(&tv,&tz);
            //            NSTimeInterval time = tv.tv_sec + tv.tv_usec/1000000.0;
            
            //c=27.013108
            //            NSDate *date = [NSDate date];
            
            //c=28.491457
            //            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            
            //avg=0.030204 c=0.000004
            
            //         {
            //         //avg=0.034632 内存基本稳定不变 c=0.000004
            //         char a[]="abcc";
            //         }
            
            //         {
            //         //avg=0.026101 内存基本稳定不变 c=0.000005
            //         NSString *astring = @"abcc";
            //         }
            
            //         {
            //         //avg=0.278873 内存基本稳定不变 c=1.583132
            //         NSString *astring = [[NSString alloc] init];
            //         astring = @"abcc";
            //         [astring release];
            //         }
            
            //         {
            //         //avg=3.619728 内存增长过快 c=2.933851
            //         NSString *a=[NSString stringWithString:@"abcc"];
            //         }
            
            //         {
            //         //avg=0.594266 内存基本稳定不变 c=3.060234
            //         NSString *t=[[NSString alloc] initWithString:@"abccc"];
            //         [t release];
            //         }
            
            //         {
            //         //avg=2.276076 内存基本稳定不变 c=6.070140
            //         char a[32];
            //         sprintf(a,"abcc%d",i);
            //         }
            
            //         {
            //         //avg=2.737541 内存基本稳定不变 c=15.387647
            //         char *Cstring = "abcc";
            //         NSString *astring = [[NSString alloc] initWithCString:Cstring];
            //         [astring release];
            //         }
            
            //         {
            //         //太长时间，内存增长过快 c=55.075225 Received memory warning.
            //         NSString *a=[NSString stringWithFormat:@"abcc%d",i];
            //         }
            
            //         {
            //         //18.1555 内存稍有增长 c=63.796145
            //         NSString *a=[[NSString alloc] initWithFormat:@"abcc%d",i];
            //         [a release];
            //         }
            
            //         {
            //         //太长时间，内存增长过快 Received memory error
            //         NSMutableString *a=[[NSMutableString alloc] init];
            //         [a stringByAppendingFormat:@"abcc%d",i];
            //         [a release];
            //         }
            
        }
        NSTimeInterval c = [[NSDate date] timeIntervalSinceDate:start];
        NSLog(@"c=%f", c);
    }
    
}



- (void)onClickShowGT
{
    //    [self test];
    //    char a[32] = {0};
    //    sprintf(a, "a");
    //    int i = 6;
    //    sprintf(a,"abcc%lu",i);
    //    NSLog(@"sizeof(a):%u strlen(a):%u", sizeof(a), strlen(a));
    //    return;
#ifndef GT_DEBUG_DISABLE
    
    // GT Usage(合入) 隐藏和显示logo处理
    if (GT_DEBUG_HIDDEN) {
        GT_DEBUG_SET_HIDDEN(NO);
        [_btn1 setTitle:@"HIDE GT" forState:UIControlStateNormal];
    } else {
        GT_DEBUG_SET_HIDDEN(YES);
        [_btn1 setTitle:@"SHOW GT" forState:UIControlStateNormal];
    }
#endif
}


- (void)onClickToDemo
{
    DemoViewController *vc = [[[DemoViewController alloc] init] autorelease];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onClickCrash
{
    // crash
    NSArray *array = [NSArray arrayWithObject:@"1"];
    [array objectAtIndex:1];
}

- (void)onHighCPU
{
    _highCPU = !_highCPU;
    if (_highCPU) {
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadProc:) object:nil];
        _thread.name = [NSString stringWithFormat:@"%@", NSStringFromClass([self class])];
        [_thread start];
        
        [_btn4 setTitle:@"STOP" forState:UIControlStateNormal];
    } else {
        [_thread cancel];
        [_thread release];
        _thread = nil;
        
        [_btn4 setTitle:@"High CPU" forState:UIControlStateNormal];
    }
    
}

- (void)threadProc:(id)obj
{
    while (TRUE) {
        
        if ([[NSThread currentThread] isCancelled]) {
            [NSThread exit];
        }
        
    }
}

- (void)onHighMemory
{
    _highMem = !_highMem;
    if (_highMem) {
        [self startLocation];
        _memThread = [[NSThread alloc] initWithTarget:self selector:@selector(addMem:) object:nil];
        _memThread.name = [NSString stringWithFormat:@"%@", NSStringFromClass([self class])];
        [_memThread start];
        
        [_btn5 setTitle:@"STOP" forState:UIControlStateNormal];
    } else {
        [self stopLocation];
        [_memThread cancel];
        [_memThread release];
        _memThread = nil;
        
        [NSThread sleepForTimeInterval:0.1];
        
        if (_addedMem != nil) {
            free(_addedMem);
            _addedMem = nil;
            
        }
        [_btn5 setTitle:@"High Mem" forState:UIControlStateNormal];
    }
    
}
- (void)addMem:(id)obj
{
    int addedMemSize = MAX(50,GT_IN_GET_INT("AddedMem", false, 150));
    int interval = MAX(1,GT_IN_GET_INT("Interval", false, 5));
    NSLog(@"%d, %d", addedMemSize, interval);
    while (TRUE) {
        
        if ([[NSThread currentThread] isCancelled]) {
            [NSThread exit];
        }
        if (_addedMem == NULL) {
            _addedMem = malloc(1024*1024*addedMemSize);
            if (_addedMem != NULL) {
                memset(_addedMem, 0, 1024*1024*addedMemSize);
            }
            else{
                GT_OC_LOG_D(@"warning!!", false, @"add mem failed!" );
            }
            
        }
        
        
        [NSThread sleepForTimeInterval:interval];
        if ([[NSThread currentThread] isCancelled]) {
            [NSThread exit];
        }
        
        if (_addedMem != nil) {
            free(_addedMem);
            _addedMem = nil;
            
        }
        
        [NSThread sleepForTimeInterval:interval];
    }
}
- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    return _locationManager;
}

- (void)startLocation {
    [[self locationManager] startUpdatingLocation];
}


- (void)stopLocation {
    [[self locationManager] stopUpdatingLocation];
    [[self locationManager] stopUpdatingHeading];
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (newLocation.horizontalAccuracy < 0.0) {
        return;
    }
    GT_OC_LOG_D(@"location", @"%ld, %ld", newLocation.coordinate.longitude, newLocation.coordinate.latitude);
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
}

- (void)onHighBattery
{
    if (!_highBattery) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"!!!警告!!!" message:@"该操作会消耗大量流量,请确认关闭3G网络！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
        [alertView release];
    } else {
        [self highBatteryProc];
    }
    
}

- (void)highBatteryProc
{
    _highBattery = !_highBattery;
    if (_highBattery) {
        [self startLocation];
        _bThread = [[NSThread alloc] initWithTarget:self selector:@selector(bThreadProc:) object:nil];
        _bThread.name = [NSString stringWithFormat:@"%@", NSStringFromClass([self class])];
        [_bThread start];
        GT_NSLOG_SWITCH_SET(true);
        
        [_btn6 setTitle:@"STOP" forState:UIControlStateNormal];
    } else {
        [self stopLocation];
        [_bThread cancel];
        [_bThread release];
        _bThread = nil;
        GT_NSLOG_SWITCH_SET(false);
        
        [_btn6 setTitle:@"High Battery" forState:UIControlStateNormal];
    }
}

- (void)onStartTest
{
    GT_OUT_MONITOR_INTERVAL_SET(1);//可选，设置监控间隔，单位为秒，默认为1s，最小值：0.1(0.1s) 最大值:10(10s)
    GT_OC_OUT_HISTORY_CLEAR(@"App CPU");//清除之前统计CPU相关的数据
    GT_OUT_HISTORY_CHECKED_SET("App CPU", true);//选中记录CPU项
    
    GT_OC_OUT_HISTORY_CLEAR(@"App Memory");//清除之前统计MEM相关的数据
    GT_OUT_HISTORY_CHECKED_SET("App Memory", true);//选中记录MEM项
    
    GT_OC_OUT_HISTORY_CLEAR(@"App Smoothness");//清除之前统计SM相关的数据
    GT_OUT_HISTORY_CHECKED_SET("App Smoothness", true);//选中记录SM项
    
    GT_UTIL_RESET_NET_DATA; //reset网络数据
    GT_OC_OUT_HISTORY_CLEAR(@"Device Network");//清除之前统计NET相关的数据
    GT_OUT_HISTORY_CHECKED_SET("Device Network", true);//选中记录NET项
    
    GT_OUT_HISTORY_CHECKED_SET("Battery", false);//不选中记录BT项
    
    GT_OUT_GATHER_SWITCH_SET(true); //开始统计
    return;
}


- (void)onStopTest
{
    GT_OUT_GATHER_SWITCH_SET(false); //结束统计
    // 保存数据，路径在Documents/GT/Para/下
    GT_OC_OUT_HISTORY_SAVE(@"App CPU", @"CPU");//保存CPU历史数据，文件为【保存时刻_CPU.csv】
    GT_OC_OUT_HISTORY_SAVE(@"App Memory", @"MEM");//保存CPU历史数据，文件为【保存时刻_MEM.csv】
    GT_OC_OUT_HISTORY_SAVE(@"App Smoothness", @"SM");//保存SM历史数据，文件为【保存时刻_SM.csv】
    GT_OC_OUT_HISTORY_SAVE(@"Device Network", @"NET");//保存SM历史数据，文件为【保存时刻_NET.csv】
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    NSLog(@"%s buttonIndex:%u", __FUNCTION__, buttonIndex);
    if (buttonIndex == 1) {
        [self highBatteryProc];
    }
}

- (void)bThreadProc:(id)obj
{
    while (TRUE) {
        @autoreleasepool {
            if ([[NSThread currentThread] isCancelled]) {
                [NSThread exit];
            }
            
            [self request];
        }
        
    }
}

- (void)request
{
    //第一步，创建URL
    //    NSURL *url = [NSURL URLWithString:@"http://api.hudong.com/iphonexml.do"];
    //    NSURL *url = [NSURL URLWithString:@"http://111.161.48.64/sosopic/0/14359830428608672234/320"];
    NSURL *url = [NSURL URLWithString:@"http://images-fast.digu365.com/8f75be4e408c7ce1875bbd5705297d0e_0009.jpg"];
    
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    //    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    NSString *str = @"type=focus-c";//设置参数
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    //    NSLog(@"str:%@", str1);
    
    [request release];
}

@end
