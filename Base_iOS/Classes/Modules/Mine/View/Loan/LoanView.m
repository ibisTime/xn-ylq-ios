//
//  LoanView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "LoanView.h"
#import "UIView+Custom.h"

@interface LoanView ()

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *quotaLbl;    //额度

@property (nonatomic, strong) UIView *processView;  //流程

@end

@implementation LoanView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
        
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    [self initTopView];

    [self initProcessView];
}

- (void)initTopView {

    CGFloat centerX = kScreenWidth /2.0;
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeight(190))];
    
    self.topView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.topView];
    
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"放款中"]];
    
    iconIV.frame = CGRectMake(0, kWidth(30), kWidth(53), kWidth(53));
    
    iconIV.centerX = centerX;
    
    [self.topView addSubview:iconIV];

    UILabel *textLbl = [UILabel labelWithText:@"款项正在路上" textColor:kTextColor3 textFont:kWidth(16)];
    
    textLbl.frame = CGRectMake(0, iconIV.yy + kWidth(14.0), kWidth(150), kWidth(16));
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    textLbl.centerX = centerX;
    
    [self.topView addSubview:textLbl];
    
    self.quotaLbl = [UILabel labelWithText:@"" textColor:kTextColor textFont:kWidth(32)];
    
    self.quotaLbl.frame = CGRectMake(0, textLbl.yy + kWidth(20), kScreenWidth, kWidth(32));
    
    self.quotaLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.topView addSubview:self.quotaLbl];
}

- (void)initProcessView {

    NSArray *titleArr = @[@"绑定银行卡", @"签约成功", @"已放款"];

    NSArray *imgArr = @[@"签约成功", @"签约成功", @"unselect"];
    
    self.processView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.yy, kScreenWidth, kWidth(270))];
    
    [self addSubview:self.processView];
    
    for (int i = 0; i < 3; i++) {
        
        CGFloat imgViewW = kWidth(21);
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgArr[i]]];
        
        iv.frame = CGRectMake(kWidth(100), kHeight(40) + i*(21 + kHeight(65)), imgViewW, imgViewW);
        
        iv.layer.cornerRadius = imgViewW/2.0;
        
        iv.clipsToBounds = YES;
        
        [self.processView addSubview:iv];
        
        UILabel *textLbl = [UILabel labelWithText:titleArr[i] textColor:kTextColor textFont:kWidth(15.0)];
        
        textLbl.frame = CGRectMake(iv.xx + kWidth(20), kHeight(42) + i*(21 + kHeight(65)), 100, kWidth(16));
        
        [self.processView addSubview:textLbl];
        
        if (i != 2) {
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(iv.centerX, iv.yy, 1, kHeight(65))];
            
            UIColor *color = i == 0 ? kAppCustomMainColor : [UIColor colorWithHexString:@"#cccccc"];
            
            [self.processView addSubview:lineView];
            
            [lineView drawDashLine:3 lineSpacing:2 lineColor:color];
            
        }
    }
    
    CGFloat btnH = 45;
    
    CGFloat leftMargin = 15;
    
    UIButton *commitBtn = [UIButton buttonWithTitle:@"款项已在路上" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:btnH/2.0];
    
    commitBtn.frame = CGRectMake(leftMargin, self.processView.yy + 40, kScreenWidth - 2*leftMargin, btnH);
    
    [commitBtn addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:commitBtn];
}

#pragma mark - Events

- (void)clickCommit {

    if (_loanBlock) {
        
        _loanBlock();
    }
}

- (void)setOrderModel:(OrderModel *)orderModel {

    _orderModel = orderModel;
    
    NSString *amount = [NSString stringWithFormat:@"%@元", [_orderModel.amount convertToSimpleRealMoney]];
    
    [self.quotaLbl labelWithString:amount title:@"元" font:Font(kWidth(16)) color:kTextColor];
}

@end
