//
//  UIScrollView+ScalableCover.h
//  YYMoney
//
//  Created by jeremy on 10/2/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat MaxHeight = 200;

@interface ScalableCover : UIImageView

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@interface UIScrollView (ScalableCover)

@property (nonatomic, weak) ScalableCover *scalableCover;

- (void)addScalableCoverWithImage:(UIImage *)image;
- (void)removeScalableCover;

@end
