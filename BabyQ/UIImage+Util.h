//
//  UIImage+Util.h
//  YYMoney
//
//  Created by jeremy on 10/3/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor;
- (UIImage *)cropToRect:(CGRect)rect;

@end
