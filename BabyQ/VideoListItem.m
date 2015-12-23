//
//  VideoListItem.m
//  BabyQ
//
//  Created by jeremy on 12/8/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "VideoListItem.h"

@implementation VideoListItem

+ (NSMutableArray *) DataSource
{
    NSMutableArray *dataSource = [NSMutableArray new];
    
    VideoListItem *item = [VideoListItem new];
    item.titleStr = @"和生活";
    item.photo =  [UIImage imageNamed:@"Cell-photo"];
    
    [dataSource addObject:item];
    
    item = [VideoListItem new];
    item.titleStr = @"知趣天气";
    item.photo =  [UIImage imageNamed:@"Cell-photo"];
    
    [dataSource addObject:item];
    
    item = [VideoListItem new];
    item.titleStr = @"快拍";
    item.photo =  [UIImage imageNamed:@"Cell-photo"];
    
    [dataSource addObject:item];
    
    item = [VideoListItem new];
    item.titleStr = @"火车票";
    item.photo =  [UIImage imageNamed:@"Cell-photo"];
    
    [dataSource addObject:item];
    
    item = [VideoListItem new];
    item.titleStr = @"新仙剑奇侠转";
    item.photo =  [UIImage imageNamed:@"Cell-photo"];
    
    [dataSource addObject:item];
    
    
    return dataSource;
}

@end
