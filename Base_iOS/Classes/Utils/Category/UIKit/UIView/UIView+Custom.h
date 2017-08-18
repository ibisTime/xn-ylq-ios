//
//  UIView+Custom.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Custom)
//制作半圆
- (CALayer *)getLayerWithDirection:(NSString *)direction size:(CGSize)size;

- (void)drawDashLine:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end
