//
//  Config.m
//  YYMoney
//
//  Created by jeremy on 9/30/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "Config.h"
#import <SSKeychain.h>


NSString * const kService = @"OSChina";
NSString * const kAccount = @"account";
NSString * const kUserID = @"userID";

NSString * const kUserName = @"name";
NSString * const kPortrait = @"portrait";
NSString * const kUserScore = @"score";
NSString * const kFavoriteCount = @"favoritecount";
NSString * const kFanCount = @"fans";
NSString * const kFollowerCount = @"followers";

NSString * const kJointime = @"jointime";
NSString * const kDevelopPlatform = @"devplatform";
NSString * const kExpertise = @"expertise";
NSString * const kHometown = @"from";

NSString * const kTrueName = @"trueName";
NSString * const kSex = @"sex";
NSString * const kPhoneNumber = @"phoneNumber";
NSString * const kCorporation = @"corporation";
NSString * const kPosition = @"position";

NSString * const kTeamID = @"teamID";
NSString * const kTeamsArray = @"teams";

NSString * const kLoginStatus = @"loginStatus";

NSString * const kUserInfoDictionary = @"userInfoDictionary";

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#define Debug 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#define Debug 0
#endif


@implementation Config

+ (void)clearCookie
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"sessionCookies"];
}

//夜间状态
+ (void)saveWhetherNightMode:(BOOL)isNight
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(isNight) forKey:@"mode"];
    [userDefaults synchronize];
}

+ (BOOL)getMode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:@"mode"] boolValue];
}

//WIFI

+ (void)save_ON_OFF_WIFI:(BOOL)isWifi
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(isWifi) forKey:@"WIFI"];
    [userDefaults synchronize];
}

+ (BOOL)getWifiMode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [[userDefaults objectForKey:@"WIFI"] boolValue];
}

+ (void)setIsWifi:(BOOL)wifi
{
}

+ (void)getIsWifi
{
}

+ (UIImage *)getPortrait
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    UIImage *portrait = [UIImage imageWithData:[userDefaults objectForKey:kPortrait]];
    
    return portrait;
}

+ (void)savePortrait:(UIImage *)portrait
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:UIImagePNGRepresentation(portrait) forKey:kPortrait];
    
    [userDefaults synchronize];
}

+ (NSArray *)getUsersInformation
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userName = [userDefaults objectForKey:kUserName];
    NSNumber *score = [userDefaults objectForKey:kUserScore];
    NSNumber *favoriteCount = [userDefaults objectForKey:kFavoriteCount];
    NSNumber *fans = [userDefaults objectForKey:kFanCount];
    NSNumber *follower = [userDefaults objectForKey:kFollowerCount];
    NSNumber *userID = [userDefaults objectForKey:kUserID];
    if (userName) {
        return @[userName, score, favoriteCount, follower, fans, userID];
    }
    return @[@"设置头像", @(10000), @(1000), @(100), @(10), @(0)];
}

//存储是否登录
+ (void)save_login_status:(BOOL)isLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(isLogin) forKey:kLoginStatus];
    
    [userDefaults synchronize];
}

//获取是否登录状态
+ (BOOL)get_login_status
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL loginStatus = [[userDefaults objectForKey:kLoginStatus] boolValue];
    
    return loginStatus;
}

//存储从服务器获取的用户信息

+ (void)save_user_info_dictionary:(NSDictionary *)dic
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dic forKey:kUserInfoDictionary];
    
    [userDefaults synchronize];
}

//获取存储的用户信息

+ (NSDictionary *)get_user_info_dictionary
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfoDic = [userDefaults objectForKey:kUserInfoDictionary];
    
    return userInfoDic;
}

@end
