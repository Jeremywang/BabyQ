//
//  EZRecordCell.m
//  EZOpenSDKDemo
//
//  Created by DeJohn Dong on 15/11/3.
//  Copyright © 2015年 hikvision. All rights reserved.
//

#import "EZRecordCell.h"
#import "EZDeviceRecordFile.h"
#import "EZCloudRecordFile.h"
#import "UIImageView+AFNetworking.h"
#import "DDKit.h"
#import "EZOpenSDK.h"

#define UIColorFromRGB(rgbValue, alp)	[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 \
alpha:alp]


@implementation EZRecordCell

- (void)setCloudRecord:(EZCloudRecordFile *)cloudFile selected:(BOOL)selected
{
    self.imageView.backgroundColor = [UIColor clearColor];
    //https://cloud.ys7.com:8089/api/cloud?method=download&fid=bf883130-8e13-11e5-8000-a4b5707128a7&session=hik%24shipin7%231%23USK%23at.05idkxni22jmnf4x4f3o380e0oum07ve-7sjmcfm1m8-18q74ue-zhxrqgkur
    NSURL *url = [NSURL URLWithString:cloudFile.coverPic];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *file = [cloudFile.coverPic getSubStringBeginKey:@"fid=" EndKey:@"&session"];
    
    NSString *password = @"";
    //判断是否加密
    if(![cloudFile.encryption isEqualToString:@""]){
        password = [EZOpenSDK getValidteCode:self.deviceSerial];
    }
    NSString *body = [NSString stringWithFormat:@"fid=%@&x=%d&decodekey=%@", file, 200, password];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [self.imageView setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:@"message_callhelp"]
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       self.imageView.image = image;
                                   }
                                   failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                       NSLog(@"error = %@",error);
                                   }];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    self.timeLabel.text = [formatter stringFromDate:cloudFile.startTime];
    
    UIColor *tintColor = [UIColor grayColor];
    if(selected)
        tintColor = UIColorFromRGB(0x1b9ee2, 1.0f);
    self.imageView.layer.borderColor = tintColor.CGColor;
    self.imageView.layer.borderWidth = 1.0f;
    self.timeLabel.textColor = tintColor;
    
}

- (void)setDeviceRecord:(EZCloudRecordFile *)deviceFile selected:(BOOL)selected
{
    self.imageView.image = nil;
    self.imageView.backgroundColor = [UIColor grayColor];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    self.timeLabel.text = [formatter stringFromDate:deviceFile.startTime];
    self.imageView.image = [UIImage imageNamed:@"message_callhelp"];
    
    UIColor *tintColor = [UIColor grayColor];
    if(selected)
        tintColor = UIColorFromRGB(0x1b9ee2, 1.0f);
    self.imageView.layer.borderColor = tintColor.CGColor;
    self.imageView.layer.borderWidth = 1.0f;
    self.timeLabel.textColor = tintColor;
}

@end
