//
//  UIColor+Util.h
//  YYMoney
//
//  Created by jeremy on 9/30/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;

+ (UIColor *)themeColor;
+ (UIColor *)nameColor;
+ (UIColor *)titleColor;
+ (UIColor *)seperatorColor;
+ (UIColor *)cellsColor;
+ (UIColor *)titleBarColor;
+ (UIColor *)selectTitleBarColor;
+ (UIColor *)navigationbarColor;
+ (UIColor *)selectCellColor;
+ (UIColor *)labelTextColor;
+ (UIColor *)teamButtonColor;

+ (UIColor *)infosBackViewColor;
+ (UIColor *)lineColor;

+ (UIColor *)contentTextColor;
+ (UIColor *)borderColor;
+ (UIColor *)refreshControlColor;

@end
