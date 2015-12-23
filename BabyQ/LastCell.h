//
//  LastCell.h
//  YYMoney
//
//  Created by jeremy on 10/3/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LastCellStatus)
{
    LastCellStatusNotVisible,
    LastCellStatusMore,
    LastCellStatusLoading,
    LastCellStatusError,
    LastCellStatusFinished,
    LastCellStatusEmpty,
};

@interface LastCell : UIView

@property (nonatomic, assign) LastCellStatus status;
@property (readonly, nonatomic, assign) BOOL shouldResponseToTouch;
@property (nonatomic, copy) NSString *emptyMessage;
@property (nonatomic, strong) UILabel *textLabel;

@end
