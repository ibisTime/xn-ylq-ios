//
//  UIButton+Custom.h
//  BS
//
//  Created by 蔡卓越 on 16/4/12.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Custom)
/**文字型按钮*/
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor titleFont:(CGFloat)titleFont;

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor titleFont:(CGFloat)titleFont cornerRadius:(CGFloat)cornerRadius;

/**图片型按钮*/

+ (UIButton *)buttonWithImageName:(NSString *)imageName;

+ (UIButton *)buttonWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;

/**总参*/
+ (UIButton *)buttonWithIamgeName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName Title:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor titleFont:(CGFloat)titleFont cornerRadius:(CGFloat)cornerRadius;

- ( instancetype )initWithFrame:(CGRect)frame
                          title:(NSString *)title
                backgroundColor:(UIColor *)color;

+ (UIButton *)zhBtnWithFrame:(CGRect) frame title:(NSString *)title;

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

@end
