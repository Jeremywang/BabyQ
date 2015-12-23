//
//  YYBaseObject.m
//  YYMoney
//
//  Created by jeremy on 10/14/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "YYBaseObject.h"

@implementation YYBaseObject

- (instancetype)initWithTBXMLElement:(TBXMLElement)xml
{
    NSAssert(false, @"Over ride in subclasses");
    return nil;
}

- (instancetype)initWithXML:(ONOXMLDocument *)xml
{
    NSAssert(false, @"Over ride in TBXML subclasses");
    return nil;
}
@end
