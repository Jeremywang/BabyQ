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
//        make.top.equalTo(ws.view.mas_top);
//        make.left.equalTo(ws.view.mas_left);
//        make.width.equalTo(ws.view.mas_width);
//        make.height.equalTo(ws.view.mas_height);
//        make.centerX.mas_equalTo(ws.view.mas_centerX);
//        make.centerY.mas_equalTo(ws.view.mas_centerY);
        make.edges.equalTo(ws.view);
    }];
    
    
    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];      //获取项目版本号
    
    NSString *version = [NSString stringWithFormat:@"version: %@",  versionStr];
    
    UILabel *versionLabel = [UILabel new];
    [versionLabel setText:version];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor grayColor];
    
    [self.view addSubview:versionLabel];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@200);
        make.centerX.equalTo(ws.view.mas_centerX);
        make.centerY.equalTo(ws.view.mas_centerY).with.offset(30);
    }];
    
    
    NSString *serviceNumStr = @"服务电话: 0817-2688188";
    
    UILabel *phoneLabel = [UILabel new];
    [phoneLabel setText:serviceNumStr];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.textColor = [UIColor grayColor];
    
    [self.view addSubview:phoneLabel];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ws.view.mas_width);
        make.centerX.equalTo(ws.view.mas_centerX);
        make.centerY.equalTo(ws.view.mas_centerY).with.offset(60);
    }];
    
    
    
    NSString *versionOWN = @"@成都鑫方泰格栅科技有限公司  版权所有";
    
    UILabel *versionOWN_Lable = [UILabel new];
    [versionOWN_Lable setText:versionOWN];
    versionOWN_Lable.textAlignment = NSTextAlignmentCenter;
    versionOWN_Lable.textColor = [UIColor grayColor];
    
    [self.view addSubview:versionOWN_Lable];
    
    [versionOWN_Lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ws.view.mas_width);
        make.centerX.equalTo(ws.view.mas_centerX);
        make.bottom.equalTo(ws.view.mas_bottom).with.offset(-100);
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
