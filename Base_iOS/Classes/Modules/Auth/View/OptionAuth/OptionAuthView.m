//
//  OptionAuthView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OptionAuthView.h"
#import "NSAttributedString+add.h"

@interface OptionAuthView ()

@property (nonatomic, strong) UIImageView *iv;

@property (nonatomic, strong) UILabel *label;

@end

@implementation OptionAuthView

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
    
    iv.frame = CGRectMake(0, kWidth(17), 30, 30);
    
    iv.centerX = centerX;
    
    [self addSubview:iv];
    
    self.iv = iv;
    
    UILabel *label = [UILabel labelWithText:@"" textColor:kTextColor textFont:kWidth(13.0)];
    
    label.frame = CGRectMake(0, iv.yy + kWidth(10), 110, 15);
    
    label.centerX = centerX;
    
    label.textAlignment = NSTextAlignmentCenter;

    [self addSubview:label];
    
    self.label = label;
    
    UILabel *textLabel = [UILabel labelWithText:@"" textColor:kAppCustomMainColor textFont:kWidth(10.0)];
    
    textLabel.frame = CGRectMake(0, label.yy + 6, 90, 15);
    
    textLabel.centerX = centerX;
    
    textLabel.textAlignment = NSTextAlignmentCenter;

    [self addSubview:textLabel];
    
    self.textLabel = textLabel;
}

- (void)setSection:(SectionModel *)section {
    
    _section = section;
    
    self.iv.width = self.imgW;
    
    self.iv.height = self.imgH;
    
    self.iv.image = [UIImage imageNamed:section.img];
    
    self.label.text = section.title;
    
    UIImage *image = [UIImage imageNamed:section.authStatusImg];
    
    CGFloat scale = kScreenWidth > 375 ? 3: 2;
    
    CGFloat fixelW = CGImageGetWidth(image.CGImage)/(scale*1.0);
    CGFloat fixelH = CGImageGetHeight(image.CGImage)/(scale*1.0);
    
    CGFloat topMargin = (kWidth(15) - fixelH)/2.0;
    
    NSAttributedString *authAttrStr = [NSAttributedString getAttributedStringWithImgStr:section.authStatusStr bounds:CGRectMake(0, topMargin, fixelW, fixelH) string:[NSString stringWithFormat:@"%@  ", section.authStatusStr]];
    
    self.textLabel.attributedText = authAttrStr;
    
}

@end
