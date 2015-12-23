//
//  UIImageView+Util.m
//  YYMoney
//
//  Created by jeremy on 10/3/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "UIImageView+Util.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (Util)

- (void)loadPortrait:(NSURL *)portraitURL
{
    [self sd_setImageWithURL:portraitURL placeholderImage:[UIImage imageNamed:@"default-portrait"] options:0];
}

@end
