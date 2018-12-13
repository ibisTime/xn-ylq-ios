//
//  SettingCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIImageView *accessoryImageView;

@end

@implementation SettingCell

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
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            
        }];
        
        //右边箭头
        self.accessoryImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.accessoryImageView];
        [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@7);
            make.height.equalTo(@12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            
        }];
        self.accessoryImageView.image = [UIImage imageNamed:@"mine_more"];
        
        self.rightLabel = [UILabel labelWithText:@"" textColor:[UIColor textColor] textFont:14.0];
        
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_lessThanOrEqualTo(150);
            make.height.mas_equalTo(15.0);
            make.right.equalTo(self.accessoryImageView.mas_left).offset(-10);
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

- (void)setSettingModel:(SettingModel *)settingModel {
    if (settingModel.imgName.length > 0) {
        self.iconImageView.image = [UIImage imageNamed:settingModel.imgName];

    }else{
        
        [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.lessThanOrEqualTo(self.accessoryImageView.mas_left);
        }];
        [self layoutIfNeeded];
    }
    self.titleLbl.text = settingModel.text;
    if (settingModel.subText.length > 0) {
        self.rightLabel.text = settingModel.subText;
    }
    if ([settingModel.subText isEqualToString:@"已认证"]) {
        self.rightLabel.textColor = [UIColor colorWithHexString:@"#0cb8ae"];
    }else if([settingModel.subText isEqualToString:@"认证中"]){
        self.rightLabel.textColor = RGB(254, 159, 9);

    }else{
        self.rightLabel.textColor = RGB(153, 153, 163);

    }

}

@end
