//
//  IntegralMallHeaderView.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/18.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "IntegralMallHeaderView.h"

@interface IntegralMallHeaderView ()

@property (nonatomic, strong) UIImageView *userPhoto;

@property (nonatomic, strong) UILabel *nameLbl;

@property (nonatomic, strong) UIImageView *genderImg;

@property (nonatomic, strong) UIImageView *vipImg;  //vip

@property (nonatomic, strong) UILabel *integralNumLabel;

@end

@implementation IntegralMallHeaderView

- (instancetype)initWithFrame:(CGRect)frame btnEvnets:(IntegralBtnEvents)btnEvnets {

    if (self = [super initWithFrame:frame]) {
        
        _btnEvnets = [btnEvnets copy];
        
        [self initSubviews];
        
    }
    
    return self;
}

- (void)initSubviews {
    
    self.backgroundColor = kWhiteColor;

    self.userPhoto = [[UIImageView alloc] init];
    
    self.userPhoto.frame = CGRectMake(15, 15, 40, 40);
    self.userPhoto.image = USER_PLACEHOLDER_SMALL;
    self.userPhoto.layer.cornerRadius = 20;
    self.userPhoto.layer.masksToBounds = YES;
    self.userPhoto.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.userPhoto];

    self.vipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip"]];
    
    [self addSubview:self.vipImg];
    [self.vipImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.userPhoto.mas_bottom).offset(0);
        make.right.equalTo(self.userPhoto.mas_right).offset(0);
        make.width.height.equalTo(@(12));
        
    }];
    self.vipImg.hidden = YES;
    
    CGFloat btnHeight = 25;
    
    UIButton *integralBtn = [UIButton buttonWithTitle:@"去赚积分" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:13.0 cornerRadius:btnHeight/2.0];
    
    [integralBtn addTarget:self action:@selector(getIntegral) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:integralBtn];
    [integralBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(80);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(25);
        
    }];
    
    self.nameLbl = [UILabel labelWithText:@"这里有10W+的会员等你一起赚积分!" textColor:[UIColor textColor] textFont:15.0];
    
    self.nameLbl.numberOfLines = 0;
    [self addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.userPhoto.mas_right).offset(15);
        make.height.lessThanOrEqualTo(@(40));
        make.right.equalTo(integralBtn.mas_left).offset(-15);
        
    }];
    
    //
    self.genderImg = [[UIImageView alloc] init];
    
    [self addSubview:self.genderImg];
    [self.genderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.userPhoto.mas_top).offset(3);
        make.left.equalTo(self.nameLbl.mas_right).offset(5);
        
    }];
    
    self.integralNumLabel = [UILabel labelWithText:@"" textColor:[UIColor textColor] textFont:12.0];
    
    self.integralNumLabel.backgroundColor = kClearColor;
    
    [self addSubview:self.integralNumLabel];
    [self.integralNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.userPhoto.mas_right).mas_equalTo(15);
        make.height.mas_lessThanOrEqualTo(15);
        make.width.mas_lessThanOrEqualTo(150);
        make.bottom.mas_equalTo(-10);
        
    }];
    
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kPaleGreyColor;
    
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];

}

#pragma mark - Events

- (void)getIntegral {

    if (_btnEvnets) {
        
        _btnEvnets();
    }
}
#pragma mark - Data

- (void)setJfNum:(NSString *)jfNum {

    _jfNum = jfNum;
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:@"我的积分: " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor textColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_jfNum] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:kAppCustomMainColor}];
    
    [nameString appendAttributedString:countString];

    self.integralNumLabel.attributedText = nameString;
}

- (void)changeInfo {

    NSString *userPhotoStr = [[TLUser user].userExt.photo convertImageUrl];
    
    [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:userPhotoStr] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.nameLbl.text = [TLUser user].nickname;
    
    self.vipImg.hidden = [[TLUser user].level isEqualToString:@"1"] ? NO: YES;
    
//    NSString *img = [[TLUser user].userExt.gender isEqualToString:@"1"] ? @"男": @"女生";
    
//    [self.genderImg setImage:[UIImage imageNamed:img]];
    
    
}

- (void)logout {

    [self.userPhoto sd_setImageWithURL:nil placeholderImage:USER_PLACEHOLDER_SMALL];
    
    //
    self.nameLbl.text = @"这里有10W+的会员等你一起赚积分!";
    
    //论坛-绞肉机
    self.genderImg.image = nil;
    
    self.vipImg.hidden = YES;
    
    self.integralNumLabel.text = @"";
}

@end
