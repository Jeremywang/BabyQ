//
//  AppDelegate.h
//  BabyQ
//
//  Created by jeremy on 12/6/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL inNightMode;
@property (strong, nonatomic) Reachability *reach;
@property (nonatomic, assign) BOOL isWifi;
@property (nonatomic, strong) RootViewController *rootViewController;


@end



