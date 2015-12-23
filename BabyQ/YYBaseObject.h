//
//  YYBaseObject.h
//  YYMoney
//
//  Created by jeremy on 10/14/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Ono.h>
#import <TBXML.h>

@interface YYBaseObject : NSObject

- (instancetype)initWithXML:(ONOXMLDocument *)xml;
- (instancetype)initWithTBXMLElement:(TBXMLElement)xml;

@end
