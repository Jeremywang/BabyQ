//
//  VideoListItem.h
//  BabyQ
//
//  Created by jeremy on 12/8/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VideoListItem : NSObject

@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, copy) NSString *titleStr;

+ (NSMutableArray *)DataSource;

@end
