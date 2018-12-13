//
//  RenwalListView.m
//  Base_iOS
//
//  Created by shaojianfei on 2018/11/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "RenwalListView.h"

@interface RenwalListView()
@property (nonatomic, strong) UILabel *totalLbl;    //额度

@property (nonatomic, strong) UILabel *contentLbl;   //失效时间
@property (nonatomic, strong) UILabel *textLbl;
@end
@implementation RenwalListView
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
        
    }
    
    return self;
}
- (void)initSubviews {
    
    UILabel *textLbl = [UILabel labelWithText:@"" textColor:RGB(153, 153, 153) textFont:14.0];
    
    textLbl.frame = CGRectMake(50, 30, kScreenWidth-100, 22);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    self.textLbl = textLbl;
    [self addSubview:textLbl];
    
    self.totalLbl = [UILabel labelWithText:@"0" textColor:RGB(255, 174, 0) textFont:30];
    
    self.totalLbl.frame = CGRectMake(textLbl.x, textLbl.yy + 19, kScreenWidth-100, 33);
    
    self.totalLbl.textAlignment = NSTextAlignmentCenter;
    
    
    [self addSubview:self.totalLbl];
    
    //半圆
    
    self.contentLbl = [UILabel labelWithText:@"" textColor:RGB(153, 153, 153) textFont:14.0];
    
    self.contentLbl.frame = CGRectMake(self.totalLbl.x, self.totalLbl.yy + 19, kScreenWidth-100, 22);
    
    
    self.contentLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.contentLbl];
    
}
-(void)setQuotaModel:(RenewalModel *)quotaModel
{
    _quotaModel = quotaModel;
    self.textLbl.text = quotaModel.date;
    self.totalLbl.text =  [NSString stringWithFormat:@"%.2f", [[quotaModel.amount convertToSimpleRealMoney] floatValue]];
    self.contentLbl.text =  [NSString stringWithFormat:@"包含利息%.2f", [[quotaModel.lxAmount convertToSimpleRealMoney] floatValue]];

}
@end
