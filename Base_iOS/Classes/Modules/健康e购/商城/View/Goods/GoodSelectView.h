//
//  GoodSelectView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/7/11.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodSelectView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles btnWidth:(CGFloat)btnWidth;

- (void)setTitlePropertyWithTitleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont selectColor:(UIColor *)selectColor;

- (void)setLinePropertyWithLineColor:(UIColor *)lineColor lineSize:(CGSize)lineSize;

@end
