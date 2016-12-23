//
//  ViewController.h
//  Demo4GT
//
//  Created   on 13-6-3.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate, UIAlertViewDelegate>
{
    BOOL _showGT;
    UILabel  *_label1;
    UILabel  *_label2;
    
    UIButton *_btn1;
    UIButton *_btn2;
    UIButton *_btn3;
    UIButton *_btn4;
    UIButton *_btn5;
    UIButton *_btn6;
    UIButton *_btn7;
    UIButton *_btn8;
    BOOL      _highBattery;
    NSThread  *_bThread;
    
    BOOL      _highCPU;
    NSThread  *_thread;
    
    CLLocationManager*  _locationManager;
    BOOL _highMem;
    NSThread  *_memThread;
    Byte  *_addedMem;
}
@end
