//
//  MyInfo.h
//  YYMoney
//
//  Created by jeremy on 10/14/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "YYBaseObject.h"

@interface MyInfo : YYBaseObject

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, strong) NSURL *portraitURL;
@property (nonatomic, readonly, assign) int favoriteCount;
@property (nonatomic, readonly, assign) int fansCount;
@property (nonatomic, readonly, assign) int followersCount;
@property (nonatomic, readonly, assign) int score;
@property (nonatomic, readonly, assign) int gender;
@property (nonatomic, readonly, copy) NSString *joinTime;
@property (nonatomic, readonly, copy) NSString *developPlatform;
@property (nonatomic, readonly, copy) NSString *expertise;
@property (nonatomic, readonly, copy) NSString *hometown;

- (void)setDetailInformationJointime:(NSString *)jointime andHometown:(NSString *)hometown andDevelopPlatform:(NSString *)developPlatform andExpertise:(NSString *)expertise;

@end
