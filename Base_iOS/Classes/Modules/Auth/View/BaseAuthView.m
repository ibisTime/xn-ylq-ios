//
//  BaseAuthView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseAuthView.h"
#import "NSAttributedString+add.h"

#define kIVWidth 62

@interface BaseAuthView ()

@property (nonatomic, strong) UIImageView *iv;

@property (nonatomic, strong) UILabel *label;

@end

@implementation BaseAuthView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    CGFloat centerX = self.width/2.0;
    
    UIImageView *iv = [[UIImageView alloc] init];
    
    iv.frame = CGRectMake(0, kWidth(17), kWidth(kIVWidth), kWidth(kIVWidth));
    
    iv.centerX = centerX;
    
    [self addSubview:iv];
    
    self.iv = iv;
    
    UILabel *label = [UILabel labelWithText:@"" textColor:kTextColor textFont:kWidth(14.0)];
    
    label.frame = CGRectMake(0, iv.yy + kWidth(10), 110, 15);
    
    label.centerX = centerX;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:label];
    
    self.label = label;
    
    UILabel *textLabel = [UILabel labelWithText:@"" textColor:kAppCustomMainColor textFont:kWidth(11.0)];
    
    textLabel.frame = CGRectMake(0, label.yy + 6, 100, kWidth(15));
    
    textLabel.centerX = centerX;
    
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:textLabel];
    
    self.textLabel = textLabel;
}

- (void)setSection:(SectionModel *)section {

    _section = section;
    
    self.iv.image = [UIImage imageNamed:section.img];
    
    self.label.text = section.title;
    
    NSAttributedString *authAttrStr = [NSAttributedString getAttributedStringWithImgStr:section.authStatusImg index:section.authStatusStr.length + 1 string:[NSString stringWithFormat:@"%@  ", section.authStatusStr]];

    self.textLabel.attributedText = authAttrStr;
    
}

@end
