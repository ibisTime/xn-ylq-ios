//
//  ShopDisplayCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "ShopDisplayCell.h"

@implementation ShopDisplayCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        self.backgroundColor = [UIColor whiteColor];
        
        //
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:[UIFont thirdFont]
                                     textColor:[UIColor textColor]];
        [self.contentView addSubview:self.nameLbl];
        
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(45);
            make.top.equalTo(self.contentView.mas_top).offset(14);
            make.centerX.equalTo(self.contentView.mas_centerX);
            
        }];
        
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.iconImageView.mas_bottom).offset(7);
            make.left.right.equalTo(self.contentView);
            
        }];
        
        
    }
    return self;
}

@end
