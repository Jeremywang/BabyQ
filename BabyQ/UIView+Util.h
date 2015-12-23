//
//  UIView+Util.h
//  YYMoney
//
//  Created by jeremy on 10/3/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)

- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setBorderWidth:(CGFloat)width andColor:(UIColor *)color;

- (UIImage *)convertViewToImage;
- (UIImage *)updateBlur;

@end
