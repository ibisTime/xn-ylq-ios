//
//  LoanOrderListCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "LoanOrderListCell.h"

@interface LoanOrderListCell ()

@property (nonatomic,strong) UILabel *amountLbl;     //金额

@property (nonatomic,strong) UILabel *dayLbl;       //期限

@property (nonatomic, strong) UIButton *statusBtn;  //状态

@end

@implementation LoanOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *textLbl1 = [UILabel labelWithFrame:CGRectMake(15, 10, 30, 13) textAligment:NSTextAlignmentLeft backgroundColor:kClearColor font:Font(12) textColor:kTextColor];
    
    textLbl1.text = @"金额";
    
    [self addSubview:textLbl1];
    
    //价格
    self.amountLbl = [UILabel labelWithFrame:CGRectMake(textLbl1.x, textLbl1.yy + 8, 100, [FONT(15) lineHeight])
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor clearColor]
                                       font:FONT(15)
                                  textColor:kTextColor];
    [self addSubview:self.amountLbl];
    
    UILabel *textLbl2 = [UILabel labelWithFrame:CGRectMake(130, 10, 30, 13) textAligment:NSTextAlignmentLeft backgroundColor:kClearColor font:Font(12) textColor:kTextColor];
    
    textLbl2.text = @"期限";
    
    [self addSubview:textLbl2];
    
    //期限
    self.dayLbl = [UILabel labelWithFrame:CGRectMake(textLbl2.x, textLbl2.yy + 8, 100, [FONT(15) lineHeight])
                             textAligment:NSTextAlignmentLeft
                          backgroundColor:[UIColor clearColor]
                                     font:FONT(15)
                                textColor:kTextColor];
    
    [self addSubview:self.dayLbl];
    
    //
    
    self.statusBtn = [UIButton buttonWithTitle:@"" titleColor:kAppCustomMainColor backgroundColor:kWhiteColor titleFont:12.0];
    
    [self.statusBtn setEnlargeEdge:10];
    
    [self addSubview:self.statusBtn];
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(100);
        make.height.mas_equalTo(30);
        
    }];
    
    //
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor zh_lineColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(@0.5);
    }];
}

- (void)setOrderModel:(OrderModel *)orderModel {

    _orderModel = orderModel;
    
    _amountLbl.text = [NSString stringWithFormat:@"%@元", [_orderModel.borrowAmount convertToSimpleRealMoney]];
    
    _dayLbl.text = [NSString stringWithFormat:@"%ld天", _orderModel.duration];
    
    [_statusBtn setTitle:_orderModel.resc forState:UIControlStateNormal];
}

@end
