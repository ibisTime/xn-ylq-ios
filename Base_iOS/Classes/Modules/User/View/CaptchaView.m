//
//  CaptchaView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CaptchaView.h"

@implementation CaptchaView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUIWith:frame];
        
    }
    return self;
}

- (void)setUpUIWith:(CGRect)frame
{
    
    CGFloat btnW = 100;
    
    CGFloat rightMargin = btnW + 15;
    
    //获得验证码按钮
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(self.width - rightMargin, 0, rightMargin, frame.size.height)];
    
    rightView.backgroundColor = kWhiteColor;
    
    TLTimeButton *captchaBtn = [[TLTimeButton alloc] initWithFrame:CGRectMake(0, 0, btnW, frame.size.height - 15) totalTime:60.0];
    
    captchaBtn.titleLabel.font = [UIFont thirdFont];
    captchaBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    captchaBtn.layer.borderWidth = 1.0;
    captchaBtn.layer.cornerRadius = captchaBtn.height/2.0;
    captchaBtn.clipsToBounds = YES;
    captchaBtn.backgroundColor = kAppCustomMainColor;
    [captchaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [captchaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    captchaBtn.centerY = rightView.height/2.0;
    [rightView addSubview:captchaBtn];
    
    [self addSubview:rightView];

    self.captchaBtn = captchaBtn;
    
    self.captchaTf = [[AccountTf alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - rightMargin, frame.size.height)];
    self.captchaTf.keyboardType = UIKeyboardTypeNumberPad;
//    self.captchaTf.rightViewMode = UITextFieldViewModeAlways;

    [self addSubview:self.captchaTf];
    
    
    //    //2.1 添加分割线
    //    UIView *sLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 20)];
    //    sLine.centerY = captchaBtn.centerY;
    //    sLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    //    [captchaBtn addSubview:sLine];
    
}

@end
