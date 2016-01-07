//
//  ViewController.m
//  YYMoney
//
//  Created by jeremy on 9/29/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "Config.h"

@interface RootViewController ()


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    self.parallaxEnabled = NO;
    self.scaleContentView = YES;
    self.contentViewScaleValue = 0.95;
    self.scaleMenuView = NO;
    self.contentViewShadowEnabled = YES;
    self.contentViewShadowRadius = 4.5;
    
    if ([Config get_login_status]) {
        NSLog(@"RootViewController -----  App has login");
        //self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
        _originalContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];

        self.contentViewController = _originalContentViewController;
      } else {
        NSLog(@"RootViewController -----  App does't login");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController *firstNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        
        self.contentViewController = firstNav;
          _originalContentViewController = nil;
        
       // self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
        
    }
    

   
    

    
        //[self presentViewController:loginVC animated:NO completion:nil];
}

@end
