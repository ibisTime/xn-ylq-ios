//
//  ZHTextDetailCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHTextDetailCell.h"

@implementation ZHTextDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
//        CGRectMake(15, 15, kScreenWidth - 30, 100)
        self.detailLbl = [UILabel
                          labelWithFrame:CGRectZero
                          textAligment:NSTextAlignmentLeft
                          
                          backgroundColor:[UIColor whiteColor]
                          font:FONT(13)
                          textColor:[UIColor zh_textColor]];
        [self addSubview:self.detailLbl];
        self.detailLbl.numberOfLines = 0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);

        }];
    }
    
    return self;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
