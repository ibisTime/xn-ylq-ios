//
//  IntregalTaskHeaderView.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/28.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "IntregalTaskHeaderView.h"

@interface IntregalTaskHeaderView ()

@property (nonatomic, strong) UILabel *jfLabel;

@property (nonatomic, strong) UIButton *arrowBtn;

@end

@implementation IntregalTaskHeaderView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init

- (void)initSubviews {

    self.backgroundColor = kAppCustomMainColor;
    
    self.jfLabel = [UILabel labelWithText:@"" textColor:kWhiteColor textFont:36];
    
    self.jfLabel.backgroundColor = kClearColor;
    self.jfLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.jfLabel];
    [self.jfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(15);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(38);
        
    }];
    
    UILabel *textLabel = [UILabel labelWithText:@"积分" textColor:kWhiteColor textFont:14];
    
    textLabel.backgroundColor = kClearColor;
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.jfLabel.mas_bottom).mas_equalTo(10);
        make.centerX.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(40);
        make.height.mas_lessThanOrEqualTo(16);
        
    }];
    
    self.arrowBtn = [UIButton buttonWithImageName:@"更多-白色"];
    
    self.arrowBtn.contentMode = UIViewContentModeScaleToFill;
    
    [self.arrowBtn setEnlargeEdge:20];
    [self.arrowBtn addTarget:self action:@selector(goFlowDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.arrowBtn];
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);

    }];

}

#pragma mark - Events

- (void)goFlowDetail:(UIButton *)btn {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:IntregalTaskTypeFlow idx:0];
        
    }
    
}

- (void)setJfNumText:(NSString *)jfNumText {
    
    _jfNumText = jfNumText;
    
    self.jfLabel.text = _jfNumText;
    
}

- (void)setTaskType:(IntregalTaskType)taskType {

    _taskType = taskType;
    
    self.arrowBtn.hidden = _taskType == IntregalTaskTypeFlow ? YES: NO;
    
}

@end
