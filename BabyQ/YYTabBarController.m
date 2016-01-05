//
//  YYTabBarController.m
//  YYMoney
//
//  Created by jeremy on 10/2/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "YYTabBarController.h"
#import "UIColor+Util.h"
//#import "AppTableViewController.h"
//#import "SwipableViewController.h"
//#import "TweetsViewController.h"
//#import "PostsViewController.h"
//#import "NewsViewController.h"
//#import "BlogsViewController.h"
//#import "LoginViewController.h"
//#import "HomepageViewController.h"
//#import "DiscoverViewcontroller.h"
#import "Config.h"
#import "Utils.h"
#import "OptionButton.h"
//#import "TweetEditingVC.h"
#import "UIView+Util.h"
//#import "PersonSearchViewController.h"
//#import "ScanViewController.h"
//#import "ShakingViewController.h"
//#import "SearchViewController.h"
//#import "VoiceTweetEditingVC.h"
#import "UIImage+Util.h"
#import "MineTableViewController.h"
#import "SettingViewController.h"
//#import "TweetsTableViewController.h"
#import "MyVideoTableViewController.h"

#import "UIBarButtonItem+Badge.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import <RESideMenu/RESideMenu.h>

@interface YYTabBarController() <UITabBarControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
//    NewsViewController *newsViewCtl;
//    NewsViewController *hotNewsViewCtl;
//    BlogsViewController *blogViewCtl;
//    BlogsViewController *recommendBlogViewCtl;
//    
//    TweetsViewController *newTweetViewCtl;
//    TweetsViewController *hotTweetViewCtl;
//    TweetsViewController *myTweetViewCtl;
}

@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, assign) BOOL isPressed;
@property (nonatomic, strong) NSMutableArray *optionButtons;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGGlyph length;

@end

@implementation YYTabBarController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//Video list tabItem
    UIStoryboard *VideoSB = [UIStoryboard storyboardWithName:@"MyVideoTableViewController" bundle:nil];
    UINavigationController *VideoNav = [VideoSB instantiateViewControllerWithIdentifier:@"Nav"];
    
////discover tabitem
//    UIStoryboard *discoverSB = [UIStoryboard storyboardWithName:@"Discover" bundle:nil];
//    UINavigationController *discoverNav = [discoverSB instantiateViewControllerWithIdentifier:@"Nav"];
//Mall tableItem
//    UIStoryboard *mallSB = [UIStoryboard storyboardWithName:@"mall" bundle:nil];
//    UINavigationController *mallNav = [mallSB instantiateViewControllerWithIdentifier:@"Nav"];

//Tweets tabItem
//    UIStoryboard *tweetSB= [UIStoryboard storyboardWithName:@"TweetsTableViewController" bundle:nil];
//    UINavigationController *tweetNav = [tweetSB instantiateViewControllerWithIdentifier:@"Nav"];
 
//SettingView Item
    UIStoryboard *settingSB = [UIStoryboard storyboardWithName:@"SettingViewController" bundle:nil];
    UINavigationController *settingNav = [settingSB instantiateViewControllerWithIdentifier:@"Nav"];
    
//Mine tabItem
//    UIStoryboard *mineSB = [UIStoryboard storyboardWithName:@"MineTableViewController" bundle:nil];
//    UINavigationController *mineNav = [mineSB instantiateViewControllerWithIdentifier:@"Nav"];
    
    self.tabBar.translucent = NO;
    self.viewControllers = @[
                             VideoNav,
                             settingNav,
                             ];
    
    NSArray *titles = @[@"视频", @"设置"];
    NSArray *images = @[@"tabbar-video", @"tabbar-mine"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        [item setImage:[UIImage imageNamed:images[idx]]];
        [item setSelectedImage:[UIImage imageNamed:[images[idx] stringByAppendingString:@"-selected"]]];
    }];
    
    
//    [self.tabBar addObserver:self
//                  forKeyPath:@"selectedItem"
//                     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
//                     context:nil];
    
}




//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context
//{
//    if ([keyPath isEqualToString:@"selectedItem"]) {
//        if(self.isPressed) {[self buttonPressed];}
//    }
//}









#pragma mark -

- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    viewController.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"]
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:self action:@selector(onClickMenuButton)];
    
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                                     target:self
                                                                                                     action:@selector(pushSearchViewController)];
    
    
    
    return navigationController;
}

- (void)onClickMenuButton
{
    [self.sideMenuViewController presentLeftMenuViewController];
}


#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
//    if (self.selectedIndex <= 1 && self.selectedIndex == [tabBar.items indexOfObject:item]) {
//        SwipableViewController *swipeableVC = (SwipableViewController *)((UINavigationController *)self.selectedViewController).viewControllers[0];
//        OSCObjsViewController *objsViewController = (OSCObjsViewController *)swipeableVC.viewPager.childViewControllers[swipeableVC.titleBar.currentIndex];
//        
//        [UIView animateWithDuration:0.1 animations:^{
//            [objsViewController.tableView setContentOffset:CGPointMake(0, -objsViewController.refreshControl.frame.size.height)];
//        } completion:^(BOOL finished) {
//            [objsViewController.tableView.header beginRefreshing];
//        }];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [objsViewController refresh];
//        });
//    }
}

#pragma mark - 处理左右navigationItem点击事件

- (void)pushSearchViewController
{
//    [(UINavigationController *)self.selectedViewController pushViewController:[SearchViewController new] animated:YES];
}

@end
