//
//  AppDelegate.h
//  Demo4GT
//
//  Created   on 13-6-3.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import <UIKit/UIKit.h>
#import <GT/GT.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GTParaDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) NSTimer *batteryTimer;

@end
