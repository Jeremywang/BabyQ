//
//  OptionButton.h
//  YYMoney
//
//  Created by jeremy on 10/2/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionButton : UIView

@property (nonatomic, strong) UIView *button;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image andColor:(UIColor *)color;

@end
