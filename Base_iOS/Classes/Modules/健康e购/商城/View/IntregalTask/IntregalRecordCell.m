//
//  IntregalRecordCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/28.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "IntregalRecordCell.h"
#define kLeftX 15

@interface IntregalRecordCell ()

@property (nonatomic, strong) UILabel *taskNameLabel;   //任务名

@property (nonatomic, strong) UILabel *intregalNumLabel;//任务积分数

@property (nonatomic, strong) UILabel *timeLabel;    //积分获得时间

@end

@implementation IntregalRecordCell

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
    
    self.intregalNumLabel = [UILabel labelWithText:@"" textColor:[UIColor textColor] textFont:12.0];
    
    self.intregalNumLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.intregalNumLabel];
    [self.intregalNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-kLeftX);
        make.centerY.mas_equalTo(0);
        make.height.mas_lessThanOrEqualTo(14.0);
        make.width.mas_lessThanOrEqualTo(200);
        
    }];
    
    self.taskNameLabel = [UILabel labelWithText:@"" textColor:[UIColor textColor] textFont:15.0];
    
    [self.contentView addSubview:self.taskNameLabel];
    [self.taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.width.mas_lessThanOrEqualTo(200);
        make.height.mas_lessThanOrEqualTo(16);
        
    }];
    
    self.timeLabel = [UILabel labelWithText:@"" textColor:[UIColor textColor2] textFont:14.0];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(kLeftX);
        make.top.mas_equalTo(self.taskNameLabel.mas_bottom).mas_equalTo(5);
        make.width.mas_lessThanOrEqualTo(250);
        make.height.mas_lessThanOrEqualTo(14.0);
        
    }];
    
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kPaleGreyColor;
    
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setTask:(IntregalRecordModel *)task {
    
    _task = task;
    
    self.taskNameLabel.text = _task.bizNote;
    
    self.intregalNumLabel.text = [NSString stringWithFormat:@"%@分", [_task.transAmount convertToRealMoney]];
    
    self.timeLabel.text = [_task.createDatetime convertToDetailDate];
}


@end
