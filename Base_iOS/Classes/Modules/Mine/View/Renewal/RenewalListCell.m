//
//  RenewalListCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "RenewalListCell.h"

@interface RenewalListCell ()

@property (nonatomic,strong) UILabel *amountLbl;    //分期时间

@property (nonatomic,strong) UILabel *amountDate;    //当前期限

@property (nonatomic,strong) UILabel *dayLbl;       //金额

@property (nonatomic, strong) UILabel *timeLbl;     //续期时间
@property (nonatomic, strong) UILabel *textLbl2; //  利息
@end

@implementation RenewalListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //续期金额
    self.amountLbl = [UILabel labelWithFrame:CGRectMake(15, 10, 150, [FONT(16) lineHeight])
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor whiteColor]
                                        font:FONT(14)
                                   textColor:RGB(71, 71, 71)];
    [self addSubview:self.amountLbl];
    
    self.amountDate = [UILabel labelWithFrame:CGRectMake(15, self.amountLbl.yy+10, 150, [FONT(16) lineHeight])
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor whiteColor]
                                        font:FONT(14)
                                   textColor:RGB(71, 71, 71)];
    [self addSubview:self.amountDate];
    
    //右箭头
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_more"]];
    
    rightArrow.frame = CGRectMake(kScreenWidth - 6 - 15, 0, 6, 11);
    
    rightArrow.centerY = self.amountLbl.centerY;
    
    [self addSubview:rightArrow];
    
    UILabel *textLbl2 = [UILabel labelWithFrame:CGRectMake(kScreenWidth-150, 15, 100, 22) textAligment:NSTextAlignmentRight backgroundColor:kWhiteColor font:Font(16) textColor:kTextColor];
    self.textLbl2 = textLbl2;
//    textLbl2.text = @"续期期限";
    
    [self addSubview:textLbl2];
    
    //续期期限
    self.dayLbl = [UILabel labelWithFrame:CGRectMake(textLbl2.x, textLbl2.yy + 12, 100, [FONT(12) lineHeight])
                             textAligment:NSTextAlignmentRight
                          backgroundColor:[UIColor whiteColor]
                                     font:FONT(12)
                                textColor:RGB(153, 153, 153)];
    

    [self addSubview:self.dayLbl];
    

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor zh_lineColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(@0.5);
    }];
}

- (void)setRenewal:(RenewalModel *)renewal {

    _renewal = renewal;
    self.amountLbl.text = _renewal.date;
    self.amountDate.text = _renewal.remark;
    self.textLbl2.text = [NSString stringWithFormat:@"%@元", [_renewal.amount convertToSimpleRealMoney]];

    self.dayLbl.text = [NSString stringWithFormat:@"包含利息%@", [_renewal.lxAmount convertToSimpleRealMoney]];

    
    
}

@end
