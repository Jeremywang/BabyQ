//
//  Utils.m
//  YYMoney
//
//  Created by jeremy on 10/3/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "Utils.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>


@implementation Utils

+ (MBProgressHUD *)createHUD
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    
    [window addSubview:HUD];
    [HUD show:YES];
    
    return HUD;
    
}

@end
