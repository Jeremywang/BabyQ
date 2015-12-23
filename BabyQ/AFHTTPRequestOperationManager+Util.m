//
//  AFHTTPRequestOperationManager+Util.m
//  YYMoney
//
//  Created by jeremy on 10/3/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "AFHTTPRequestOperationManager+Util.h"
#import <AFOnoResponseSerializer.h>
#import <UIKit/UIKit.h>

@implementation AFHTTPRequestOperationManager (Util)

+ (instancetype)YYHttpManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager.requestSerializer setValue:[self generateUserAgent] forKey:@"User-Agent"];
    
    return manager;
}

+ (NSString *)generateUserAgent
{
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return [NSString stringWithFormat:@"YYMoney/%@/%@/%@/%@/%@", appVersion,
            [UIDevice currentDevice].systemName,
            [UIDevice currentDevice].systemVersion,
            [UIDevice currentDevice].model,
            IDFV];
}

@end
