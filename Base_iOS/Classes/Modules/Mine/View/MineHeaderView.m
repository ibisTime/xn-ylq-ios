//
//  MineHeaderView.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "MineHeaderView.h"

@interface MineHeaderView ()

@property (nonatomic, strong) NSMutableArray <UILabel *>*lbls;

@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kAppCustomMainColor;
        
        CGFloat photoW = 60;
        
        self.userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(15, (self.height - photoW)/2.0 - 10, photoW, photoW)];
        
        self.userPhoto.image = [UIImage imageNamed:@"头像"];
        self.userPhoto.layer.cornerRadius = photoW/2.0;
        self.userPhoto.layer.masksToBounds = YES;
        self.userPhoto.contentMode = UIViewContentModeScaleAspectFill;
        
        self.userPhoto.userInteractionEnabled = YES;
        
        [self addSubview:self.userPhoto];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)];
        
        [self.userPhoto addGestureRecognizer:tapGR];
        
        self.vipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip"]];
        
        [self addSubview:self.vipImg];
        [self.vipImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.userPhoto.mas_bottom).offset(0);
            make.right.equalTo(self.userPhoto.mas_right).offset(0);
            make.width.height.equalTo(@(12));
            
        }];
        
        self.vipImg.hidden = YES;
        
        //
        self.nameLbl = [UILabel labelWithText:@"" textColor:kWhiteColor textFont:18.0];
        
        self.nameLbl.backgroundColor = kClearColor;
        
        [self addSubview:self.nameLbl];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userPhoto.mas_centerY);
            make.left.equalTo(self.userPhoto.mas_right).offset(15);
            
        }];
        
        //
        self.genderImg = [[UIImageView alloc] init];
        
        [self addSubview:self.genderImg];
        [self.genderImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.userPhoto.mas_centerY);
            make.left.equalTo(self.nameLbl.mas_right).offset(12);
            
        }];
        
        //箭头
        UIImageView *arrowImageView= [[UIImageView alloc] init];
        [self addSubview:arrowImageView];
        arrowImageView.image = [UIImage imageNamed:@"更多"];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-15);
            make.width.mas_equalTo(7);
            make.height.mas_equalTo(12);
            make.centerY.equalTo(self.userPhoto.mas_centerY).offset(0);
            
        }];
        
        //线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.userPhoto.yy + 17, kScreenWidth, 0.5)];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        
        
        //健康币和积分
        CGFloat y = line.yy;
        CGFloat w = kScreenWidth/2.0;
        CGFloat h = 45;
        NSArray *typeNames = @[@"优惠券:",@"我的额度:"];
        
        self.lbls = [[NSMutableArray alloc] init];
        __block UIButton *lastBtn;
        [typeNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat x = idx*w;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
            
            btn.backgroundColor = kWhiteColor;
            [self addSubview:btn];
//            [btn setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
            //            btn.backgroundColor = RANDOM_COLOR;
            [btn addTarget:self action:@selector(goFlowDetal:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = idx + 100;
            
            lastBtn = btn;
            
            //
            UILabel *typeNameLbl = [UILabel labelWithText:@"" textColor:[UIColor colorWithHexString:@"#666666"] textFont:13.0];
            
            typeNameLbl.textAlignment = NSTextAlignmentCenter;
            typeNameLbl.backgroundColor = kClearColor;
            [btn addSubview:typeNameLbl];
            typeNameLbl.text = typeNames[idx];
            [typeNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {

                make.width.mas_lessThanOrEqualTo(100);
                make.centerY.mas_equalTo(0);
                make.centerX.mas_equalTo(-30);
                make.height.mas_lessThanOrEqualTo(20);
                
            }];
            
            //
            UILabel *numLbl = [UILabel labelWithText:@"0" textColor:[UIColor textColor] textFont:15.0];
            
            numLbl.textAlignment = NSTextAlignmentCenter;
            numLbl.backgroundColor = kClearColor;
            [btn addSubview:numLbl];
            [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(typeNameLbl.mas_right).mas_equalTo(10);
                make.width.mas_lessThanOrEqualTo(100);
                make.centerY.mas_equalTo(btn.mas_centerY);
                make.height.mas_equalTo(20);
                
            }];
            [self.lbls addObject:numLbl];
            
            
            
        }];
        
        self.height = lastBtn.yy;
        
        UIView *lineView = [[UIView alloc] init];
        
        lineView.backgroundColor = kPaleGreyColor;
        
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(0.5);
            make.bottom.mas_equalTo(-5);
        }];
    }
    return self;
}

- (void)selectPhoto:(UITapGestureRecognizer *)tapGR {

    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderSeletedTypeSelectPhoto idx:0];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderSeletedTypeDefault idx:0];
    }
    
}

- (void)goFlowDetal:(UIButton *)btn {
    
    NSInteger index = btn.tag - 100;
    
    if (index == 0) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
            
            [self.delegate didSelectedWithType:MineHeaderSeletedTypeCoupon idx:btn.tag - 100];
            
        }
        
    } else if (index == 1) {
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
            
            [self.delegate didSelectedWithType:MineHeaderSeletedTypeQuota idx:btn.tag - 100];
            
        }
    }
    
    
    
}

- (void)setCouponNum:(NSString *)couponNum {

    _couponNum = couponNum;
    
    self.lbls[0].text = _couponNum;
}

- (void)setQuotaNum:(NSString *)quotaNum {

    _quotaNum = quotaNum;
 
    self.lbls[1].text = _quotaNum;

}

- (void)reset {
    
    [self.lbls enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.text = @"--";
    }];
    
}

//
- (void)setNumberArray:(NSArray *)numberArray {
    
    _numberArray = numberArray;
    [_numberArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        self.lbls[idx].text = [NSString stringWithFormat:@"%@",obj];
        
    }];
    
}

@end
