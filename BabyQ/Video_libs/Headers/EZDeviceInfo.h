//
//  EZDeviceInfo.h
//  EzvizOpenSDK
//
//  Created by DeJohn Dong on 15/9/16.
//  Copyright (c) 2015年 Hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZDeviceInfo : NSObject

/**
 *  设备ID（索引）
 */
@property (nonatomic, copy) NSString *deviceId;
/**
 *  设备序列号
 */
@property (nonatomic, copy) NSString *deviceSerial;
/**
 *  设备全序列号
 */
@property (nonatomic, copy) NSString *fullSerial;
/**
 *  设备名称
 */
@property (nonatomic, copy) NSString *deviceName;
/**
 *  是否开启活动检测
 */
@property (nonatomic) BOOL isDefence;
/**
 *  是否开启加密
 */
@property (nonatomic) BOOL isEncrypt;
/**
 *  设备状态
 */
@property (nonatomic) NSInteger status;
/**
 *  设备图片
 */
@property (nonatomic, copy) NSString *picUrl;
/**
 *  设备类型
 */
@property (nonatomic, copy) NSString *model;
/**
 *  是否支持布撤防
 */
@property (nonatomic, readonly) BOOL isSupportDefence;
/**
 *  是否支持布撤防计划
 */
@property (nonatomic, readonly) BOOL isSupportDefencePlan;
/**
 *  是否支持对讲
 */
@property (nonatomic, readonly) BOOL isSupportTalk;
/**
 *  是否支持云台控制
 */
@property (nonatomic, readonly) BOOL isSupportPTZ;
/**
 *  是否支持放大
 */
@property (nonatomic, readonly) BOOL isSupportZoom;
/**
 *  是否支持升级
 */
@property (nonatomic, readonly) BOOL isSupportUpgrade;
/**
 *  设备能力集协议
 */
@property (nonatomic, copy) NSString *supportExtShort;


@end
