//
//  NSTextAttachment+Util.m
//  YYMoney
//
//  Created by jeremy on 10/3/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "NSTextAttachment+Util.h"

@implementation NSTextAttachment (Util)

- (void)adjustY:(CGFloat)y
{
    self.bounds = CGRectMake(0, y, self.image.size.width, self.image.size.height);
}

@end
