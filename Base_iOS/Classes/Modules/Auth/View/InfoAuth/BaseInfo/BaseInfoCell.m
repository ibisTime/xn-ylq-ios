//
//  BaseInfoCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/9.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseInfoCell.h"
#import "NSAttributedString+add.h"

@interface BaseInfoCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIImageView *accessoryImageView;

@end

@implementation BaseInfoCell

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
        
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@16);
            make.height.equalTo(@16);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            
        }];
        
        //右边箭头
        self.accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_more"]];
        [self.contentView addSubview:self.accessoryImageView];
        [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@6);
            make.height.equalTo(@11);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            
        }];
        
        self.rightLabel = [UILabel labelWithText:@"" textColor:[UIColor textColor] textFont:14.0];
        
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_lessThanOrEqualTo(150);
            make.height.mas_equalTo(15.0);
            make.right.mas_equalTo(self.accessoryImageView.mas_left).mas_equalTo(-10);
            make.centerY.mas_equalTo(0);
            
        }];
        
        //
        self.titleLbl = [UILabel labelWithText:@"" textColor:[UIColor textColor] textFont:14.0];
        [self.contentView addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(20);
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.lessThanOrEqualTo(self.accessoryImageView.mas_left);
        }];
        
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
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

- (void)setBaseInfoModel:(BaseInfoModel *)baseInfoModel {
    
    self.iconImageView.image = [UIImage imageNamed:baseInfoModel.imgName];
    
    self.titleLbl.text = baseInfoModel.text;
    
    if (baseInfoModel.isAuth) {
        
        NSAttributedString *authAttrStr = [NSAttributedString getAttributedStringWithImgStr:@"已填写" bounds:CGRectMake(0, 0, 12, 12) string:@""];
        
        self.rightLabel.attributedText = authAttrStr;
        
    } else {
    
        self.rightLabel.text = @"未填写";

    }
}

@end
