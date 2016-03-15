//
//  Config.h
//  YYMoney
//
//  Created by jeremy on 9/30/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define AppKey        @"2fb8b1891e154de6996f637266bbc16d"
#define SecretKey     @"7e59ad372a5a449234dd904833f31791"
//线上
#define EzvizAppKey @"4bdf5701dfaa4e18bd2abe901274ae17"

@interface Config : NSObject

+ (void)saveWhetherNightMode:(BOOL)isNight;
+ (BOOL)getMode;
+ (UIImage *)getPortrait;
+ (NSArray *)getUsersInformation;
+ (void)savePortrait:(UIImage *)portrait;

//3G WIFI控制流量
+ (void)save_ON_OFF_WIFI:(BOOL)isWifi;
+ (BOOL)getWifiMode;

+ (void)clearCookie;

+ (void)setIsWifi:(BOOL)wifi;
+ (void)getIsWifi;

+ (void)save_login_status:(BOOL)isLogin;
+ (BOOL)get_login_status;

+ (void)save_user_info_dictionary:(NSDictionary *)dic;

+ (NSDictionary *)get_user_info_dictionary;

+ (void)save_user_name:(NSString *)nameStr;

+ (NSString *)get_user_name;



+ (void)save_school_name:(NSString *)schoolNameStr;

+ (NSString *)get_school_name;

+ (void)save_needrefreshAction:(BOOL)needRefrsh;

+ (BOOL)get_needrefreshAction;

@end
