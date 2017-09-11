//
//  RenewalListCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "RenewalListCell.h"

@interface RenewalListCell ()

@property (nonatomic,strong) UILabel *amountLbl;    //续期金额

@property (nonatomic,strong) UILabel *dayLbl;       //续期期限

@property (nonatomic, strong) UILabel *timeLbl;     //续期时间

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
    
    UILabel *textLbl1 = [UILabel labelWithFrame:CGRectMake(15, 10, 65, 13) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(13) textColor:kTextColor];
    
    textLbl1.text = @"续期金额";
    
    [self addSubview:textLbl1];
    
    //续期金额
    self.amountLbl = [UILabel labelWithFrame:CGRectMake(textLbl1.x, textLbl1.yy + 8, 100, [FONT(15) lineHeight])
                                textAligment:NSTextAlignmentCenter
                             backgroundColor:[UIColor clearColor]
                                        font:FONT(15)
                                   textColor:kTextColor];
    [self addSubview:self.amountLbl];
    
    self.amountLbl.centerX = textLbl1.centerX;
    
    UILabel *textLbl2 = [UILabel labelWithFrame:CGRectMake(130, 10, 65, 13) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(13) textColor:kTextColor];
    
    textLbl2.text = @"续期期限";
    
    [self addSubview:textLbl2];
    
    //续期期限
    self.dayLbl = [UILabel labelWithFrame:CGRectMake(textLbl2.x, textLbl2.yy + 8, 100, [FONT(15) lineHeight])
                             textAligment:NSTextAlignmentCenter
                          backgroundColor:[UIColor clearColor]
                                     font:FONT(15)
                                textColor:kTextColor];
    
    self.dayLbl.centerX = textLbl2.centerX;

    [self addSubview:self.dayLbl];
    
    //右箭头
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_more"]];
    
    rightArrow.frame = CGRectMake(kScreenWidth - 6 - 15, 0, 6, 11);
    
    rightArrow.centerY = 30;
    
    [self addSubview:rightArrow];
    
    //续期时间
    self.timeLbl = [UILabel labelWithFrame:CGRectMake(rightArrow.x - 15 - 100, self.amountLbl.y, 100, 13) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(15) textColor:kTextColor];
    
    [self addSubview:self.timeLbl];
    
    UILabel *textLbl3 = [UILabel labelWithFrame:CGRectMake(130, 10, 65, 13) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(13) textColor:kTextColor];
    
    textLbl3.text = @"续期日";
    
    textLbl3.centerX = self.timeLbl.centerX;
    
    [self addSubview:textLbl3];
    //
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
    
    self.amountLbl.text = [NSString stringWithFormat:@"%@元", [_renewal.totalAmount convertToSimpleRealMoney]];
    
    self.dayLbl.text = [NSString stringWithFormat:@"%ld天", _renewal.step];
    
    self.timeLbl.text = [_renewal.createDatetime convertDate];
}

@end
