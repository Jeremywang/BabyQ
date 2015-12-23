//
//  LicensePage.m
//  YYMoney
//
//  Created by jeremy on 10/10/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "LicensePage.h"
#import "Config.h"

@interface LicensePage ()

@end

@implementation LicensePage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"开源主件";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    webView.scrollView.bounces = NO;
    
//#ifdef TARGET_IPHONE_SIMULATOR
//        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"License" ofType:@"html"];
//#endif
    
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"License" ofType:@"html"]]]];
    
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
