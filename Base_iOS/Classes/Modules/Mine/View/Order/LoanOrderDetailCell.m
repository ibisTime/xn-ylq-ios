//
//  LoanOrderDetailCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "LoanOrderDetailCell.h"

@interface LoanOrderDetailCell ()

@property (nonatomic, strong) UIImageView *rightArrow;

@end

@implementation LoanOrderDetailCell

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
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //右箭头
        UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_more"]];
        
        rightArrow.frame = CGRectMake(kScreenWidth - 6 - 15, 0, 6, 11);
        
        rightArrow.centerY = self.centerY;
        
        rightArrow.hidden = YES;
        
        [self addSubview:rightArrow];
        
        self.rightArrow = rightArrow;
        
        self.rightLabel = [UILabel labelWithText:@"" textColor:kTextColor textFont:14.0];
        
        self.rightLabel.numberOfLines = 0;
        
        self.rightLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_lessThanOrEqualTo(250);
            make.height.mas_lessThanOrEqualTo(45.0);
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            
        }];
        
        //
        self.titleLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:14.0];
        [self.contentView addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(kLineHeight));
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
    
}

- (void)setArrowHidden:(BOOL)arrowHidden {

    _arrowHidden = arrowHidden;
    
    _rightArrow.hidden = _arrowHidden;
    
    if (!_arrowHidden) {
        
        [_rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(self.rightArrow.mas_left).mas_equalTo(-15);
            
        }];
    }
    
}

@end
