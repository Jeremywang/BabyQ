//
//  AboutPage.m
//  YYMoney
//
//  Created by jeremy on 10/10/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "AboutPage.h"
#import "Utils.h"
#import "UIColor+Util.h"
#import <Masonry.h>

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface AboutPage ()

@end

@implementation AboutPage
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WS(ws);
    
    self.navigationItem.title = @"关于";
    self.view.backgroundColor = [UIColor themeColor];
    
    UIImageView *logo = [UIImageView new];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image = [UIImage imageNamed:@"about"];
    
    
    [self.view addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view.mas_top);
        make.left.equalTo(ws.view.mas_left);
        make.width.equalTo(ws.view.mas_width);
        make.height.equalTo(ws.view.mas_height);
        make.centerX.mas_equalTo(ws.view.mas_centerX);
        make.centerY.mas_equalTo(ws.view.mas_centerY);
    }];
    
//    UILabel *declarationLabel = [UILabel new];
//    declarationLabel.numberOfLines = 0;
//    declarationLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    declarationLabel.textAlignment = NSTextAlignmentCenter;
//    declarationLabel.textColor = [UIColor lightGrayColor];
//    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
//    declarationLabel.text = [NSString stringWithFormat:@"%@\n©2008-2015 Mayfly.net.\nAll rights reserved.\n 幼儿园校讯通之类的软件。其中就需要利用萤石云的监控头达到家长观看幼儿园监控的目的", version];
//    [self.view addSubview:declarationLabel];
//    
//    
//    for (UIView *view in self.view.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
//    NSDictionary *views = NSDictionaryOfVariableBindings(logo, declarationLabel);
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:logo      attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.f]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:logo      attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:-90.f]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[logo(80)]-20-[declarationLabel]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[logo(80)]" options:0 metrics:nil views:views]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[declarationLabel(200)]" options:0 metrics:nil views:views]];
//    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
