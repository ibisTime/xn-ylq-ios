//
//  BaseInfoDetailCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseInfoDetailCell.h"

@interface BaseInfoDetailCell ()

@property (nonatomic, strong) TLTextField *textField;

@property (nonatomic, strong) UIImageView *rightIV;

@end

@implementation BaseInfoDetailCell

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
        
    }
    return self;
    
}

- (void)setModel:(BaseInfoModel *)model {

    _model = model;
    
    [self initSubviews];
}

- (void)initSubviews {
    
    self.textField = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) leftTitle:_model.text titleWidth:90 placeholder:_model.placeholder];
    
    [self addSubview:self.textField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, self.textField.yy, kScreenWidth - 15, 1)];
    
    lineView.backgroundColor = kPaleGreyColor;
    
    [self addSubview:lineView];
    
    //右边箭头
    self.rightIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_more"]];
    [self addSubview:self.rightIV];
    
    [self.rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@6);
        make.height.equalTo(@11);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
        
    }];
}

@end
