//
//  NSString+pingyin.m
//  YYMoney
//
//  Created by jeremy on 10/3/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "NSString+pingyin.h"

@implementation NSString (pingyin)

- (NSString *)pinyin
{
    if (self == nil || self.length == 0) {
        return @"";
    }
    NSMutableString *result = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)result, NULL, kCFStringTransformMandarinLatin, NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)result, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [result uppercaseString];
}

@end
