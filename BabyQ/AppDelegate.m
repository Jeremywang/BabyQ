//
//  AppDelegate.m
//  BabyQ
//
//  Created by jeremy on 12/6/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "AppDelegate.h"
#import "Config.h"
#import "UIColor+Util.h"
#import "UIView+Util.h"
#import "EZOpenSDK.h"
#import "Reachability.h"



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _inNightMode = [Config getMode];
    
    //    [self loadCookies];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    /************ 控件外观设置 **************/
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[ UIFont fontWithName : @"Helvetica-Bold" size : 25.0 ]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithHex:0xe9821b]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xe9821b]} forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor navigationbarColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor titleBarColor]];
    
    [UISearchBar appearance].tintColor = [UIColor colorWithHex:0x15A230];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setCornerRadius:14.0];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAlpha:0.6];
    
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor colorWithHex:0xDCDCDC];
    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    
    [[UITextField appearance] setTintColor:[UIColor nameColor]];
    [[UITextView appearance]  setTintColor:[UIColor nameColor]];
    
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    [menuController setMenuVisible:YES animated:YES];
    [menuController setMenuItems:@[
                                   [[UIMenuItem alloc] initWithTitle:@"复制" action:NSSelectorFromString(@"copyText:")],
                                   [[UIMenuItem alloc] initWithTitle:@"删除" action:NSSelectorFromString(@"deleteObject:")]
                                   ]];
    
    /************ 检测通知 **************/
    [self registerAPNS];
    
    
    //萤石
    // 初始化SDK库, 设置SDK平台服务器地址
//    NSMutableDictionary *dictServers = [NSMutableDictionary dictionary];UI
//    [dictServers setObject:@"https://auth.ys7.com" forKey:AppKey];
//    [dictServers setObject:@"https://open.ys7.com" forKey:AppKey];
//    [YSPlayerController loadSDKWithPlatfromServers:dictServers];
    
 //   [EZOpenSDK initLibWithAppKey:AppKey];
    
    
    ///开启网络状况的监听
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name:kReachabilityChangedNotification
//                                               object:nil];
//    
//    self.reach = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
//    
//    [self.reach startNotifier]; //开始监听，会启动一个run loop
    
    
    
//    if (user1) {
//        NSLog(@"%@", user1);
//    }
//    else
//    {
//        NSLog(@"there isn't user1");
//    }
//    
//    NSDictionary *user2 = [data objectForKey:@"username2"];
//    if (user2) {
//        NSLog(@"%@", user2);
//    }
//    else
//    {
//        NSLog(@"there isn't user2");
//    }
    
    
//    //获取应用程序沙盒的Documents目录
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *plistPath1 = [paths objectAtIndex:0];
    
    
//    //得到完整的文件名
//    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"userinfo.plist"];
//    
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    
//    if (![fileMgr fileExistsAtPath:filename]) {
//        //测试数据
//        
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
//        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//        //   NSDictionary *user1 = [data objectForKey:@"username1"];
//        NSLog(@"data＝＝＝%@", data);//直接打印数据。
//        //输入写入
//        [data writeToFile:filename atomically:YES];
//    } else {
//        NSLog(@"用户文件已经存在！");
//    }
    
    
    
    //那怎么证明我的数据写入了呢？读出来看看
//    NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
//    NSLog(@"data1====%@", data1);
    
    
    
   // [NSThread sleepForTimeInterval:3.0];//设置启动页面时间
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    _rootViewController = [board instantiateViewControllerWithIdentifier:@"rootViewController"];
    
    self.window.rootViewController = _rootViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Do the work associated with the task, preferably in chunks.
        [NSThread sleepForTimeInterval:60];
        
        //告诉系统我们完成了
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)loadCookies
{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"]];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies ) {
        [cookieStorage setCookie:cookie];
    }
}

//通知
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    NSParameterAssert([reach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [reach currentReachabilityStatus];
    
    //    //用于检测是否是WIFI
    //    NSLog(@"%d",([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable));
    //    //用于检查是否是3G
    //    NSLog(@"%d",([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable));
    
    if (status == NotReachable) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"网络已断开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
        _isWifi = FALSE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wifiStatesChanged" object:@(FALSE)];
        NSLog(@"Notification Says Unreachable");
    }else if(status == ReachableViaWWAN){
        
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"移动网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
        _isWifi = FALSE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wifiStatesChanged" object:@(FALSE)];
        NSLog(@"Notification Says mobilenet");
    }else if(status == ReachableViaWiFi){
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"WIfi网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
        _isWifi = TRUE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wifiStatesChanged" object:@(TRUE)];
        NSLog(@"Notification Says wifinet");
    }
    
}


- (void)registerAPNS
{
    NSLog(@"Registering for push notifications...");
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"注册APNS TOKEN成功：%@,%lu",deviceToken,(unsigned long)deviceToken.length);
    
    //    NSString *newToken = [NSString stringWithFormat:@"%@",deviceToken];
    //    [[EZPushService sharedService] setAPNSToken:newToken pushSecret:EZPushAppSecret];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"注册失败，无法获取设备ID: %@",err);
}


@end

