//
//  GoodView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/7.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "GoodView.h"

@interface GoodView ()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic, strong) UILabel *textLbl1;

@property (nonatomic, strong) UILabel *textLbl2;

@property (nonatomic, strong) UILabel *moneyLbl;        //借款金额

@property (nonatomic, strong) UILabel *timeLbl;

@property (nonatomic, strong) UIButton *statusBtn;      //申请状态

@property (nonatomic, strong) UIImageView *lockIV;      //锁

@property (nonatomic, strong) UIButton *cancelBtn;      //取消申请

@property (nonatomic, strong) UILabel *levelLbl;        //等级

@property (nonatomic, strong) UILabel *conditionLbl;    //条件

@end

@implementation GoodView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.layer.cornerRadius = 15;
    
    self.clipsToBounds = YES;
    
    //借款金额
    self.textLbl1 = [UILabel labelWithText:@"借款金额" textColor:kWhiteColor textFont:kWidth(15.0)];
    
    self.textLbl1.frame = CGRectMake(kWidth(20), kWidth(31), 90, kWidth(16));
    
    self.textLbl1.backgroundColor = kClearColor;
    
    [self addSubview:self.textLbl1];
    
    //金额
    self.moneyLbl = [UILabel labelWithText:@"" textColor:kWhiteColor textFont:kWidth(32.0)];
    
    self.moneyLbl.frame = CGRectMake(self.textLbl1.x, self.textLbl1.yy + kWidth(24), 200, kWidth(35));
    
    self.moneyLbl.backgroundColor = kClearColor;
    
    [self addSubview:self.moneyLbl];
    
    //右箭头
    self.iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - kWidth(27), 0, 7, 11)];
    
    self.iconIV.image = [UIImage imageNamed:@"more"];
    
    self.iconIV.centerY = self.height/2.0;
    
    [self addSubview:self.iconIV];
    
    //借款期限
    self.textLbl2 = [UILabel labelWithText:@"借款期限" textColor:kWhiteColor textFont:kWidth(15.0)];
    
    self.textLbl2.frame = CGRectMake(self.iconIV.x - kWidth(65) - kWidth(22), kWidth(31), kWidth(65), kWidth(16));
    
    self.textLbl2.textAlignment = NSTextAlignmentCenter;

    self.textLbl2.backgroundColor = kClearColor;
    
    [self addSubview:self.textLbl2];
    
    //期限
    self.timeLbl = [UILabel labelWithText:@"" textColor:kWhiteColor textFont:kWidth(17.0)];
    
    self.timeLbl.frame = CGRectMake(0, self.textLbl2.yy + kWidth(29), 80, kWidth(18));
    
    self.timeLbl.textAlignment = NSTextAlignmentCenter;
    
    self.timeLbl.backgroundColor = kClearColor;
    
    self.timeLbl.centerX = self.textLbl2.centerX;
    
    [self addSubview:self.timeLbl];
    
    //申请状态
    self.statusBtn = [UIButton buttonWithTitle:@"" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:kWidth(16) cornerRadius:45/2.0];
    
    self.statusBtn.frame = CGRectMake(0, kWidth(31), 100, 45);
    
    self.statusBtn.centerX = self.width/2.0;
    
//    self.statusBtn.centerY = self.height/2.0;
    
    self.statusBtn.enabled = NO;
    
    [self.statusBtn addTarget:self action:@selector(clickContinue:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.statusBtn];
    
    //等级
    self.levelLbl = [UILabel labelWithText:@"" textColor:kWhiteColor textFont:kWidth(16)];
    
    self.levelLbl.frame = CGRectMake(0, self.textLbl2.yy + kWidth(29), 100, kWidth(16));
    
    self.levelLbl.textAlignment = NSTextAlignmentCenter;
    
    self.levelLbl.centerX = self.width/2.0;

    [self addSubview:self.levelLbl];
    //锁
    self.lockIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, kWidth(31), 33, 33)];
    
    self.lockIV.image = [UIImage imageNamed:@"lock"];
    
    self.lockIV.centerX = self.width/2.0;

//    self.lockIV.centerY = self.height/2.0;
    
    [self addSubview:self.lockIV];
    
    //取消
    self.cancelBtn = [UIButton buttonWithTitle:@"取消" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:kWidth(13.0)];

    [self.cancelBtn setEnlargeEdge:20];
    
    [self.cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
        make.width.mas_lessThanOrEqualTo(40);
        make.height.mas_lessThanOrEqualTo(30);
        
    }];
    
    //条件
    self.conditionLbl = [UILabel labelWithText:@"" textColor:kWhiteColor textFont:kWidth(13.0)];
    
    self.conditionLbl.textAlignment = NSTextAlignmentRight;

    [self addSubview:self.conditionLbl];
    [self.conditionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
        make.width.mas_lessThanOrEqualTo(300);
        make.height.mas_lessThanOrEqualTo(18);
        
    }];
}

#pragma mark - Setting
- (void)setGoodModel:(GoodModel *)goodModel {

    _goodModel = goodModel;
    
    self.backgroundColor = [UIColor colorWithHexString:_goodModel.uiColor];
    
    [self.moneyLbl labelWithString:[NSString stringWithFormat:@"￥%@", [_goodModel.amount convertToSimpleRealMoney]] title:@"￥" font:Font(kWidth(17.0)) color:kWhiteColor];

    self.timeLbl.text = [NSString stringWithFormat:@"%ld天", _goodModel.duration];
    
    self.levelLbl.text = [NSString stringWithFormat:@"LV%@", _goodModel.level];
    
    self.conditionLbl.text = [_goodModel.isLocked isEqualToString:@"0"] ? @"极速放款": _goodModel.slogan;

    if ([_goodModel.isLocked isEqualToString:@"0"]) {
        
        self.statusBtn.hidden = NO;
        
        [self.statusBtn setTitle:_goodModel.statusStr forState:UIControlStateNormal];
        
        self.lockIV.hidden = YES;
        
        self.alpha = 1;

        if ([_goodModel.userProductStatus isEqualToString:@"1"] || [_goodModel.userProductStatus isEqualToString:@"2"] || [_goodModel.userProductStatus isEqualToString:@"3"]) {
            
            self.conditionLbl.hidden = YES;
            
            self.cancelBtn.hidden = NO;
            
        } else {
        
            self.cancelBtn.hidden = YES;

        }
        
    } else {
    
        self.statusBtn.hidden = YES;

        self.lockIV.hidden = NO;
        
        self.cancelBtn.hidden = YES;

        self.alpha = 0.5;
    }
    
}

#pragma mark - Events
- (void)clickContinue:(UIButton *)sender {
    
    if (self.loanBlock) {
        
        self.loanBlock(LoanTypeSecondStep, self.goodModel);
    }
}

- (void)clickCancel {
    
    if (self.loanBlock) {
        
        self.loanBlock(LoanTypeCancel, self.goodModel);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.loanBlock) {
        
        self.loanBlock(LoanTypeFirstStep, self.goodModel);
    }
}

@end
