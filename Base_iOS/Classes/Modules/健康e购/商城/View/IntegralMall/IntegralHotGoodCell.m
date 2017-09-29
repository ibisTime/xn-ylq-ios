//
//  IntegralHotGoodCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/18.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "IntegralHotGoodCell.h"

@interface IntegralHotGoodCell ()

//商品图
@property (nonatomic, strong) UIImageView *goodIV;
//商品名称
@property (nonatomic, strong)  UILabel *nameLabel;
//广告语
@property (nonatomic, strong)  UILabel *descLabel;
//商品价格
@property (nonatomic, strong)  UILabel *priceLabel;
//市场参考价
@property (nonatomic, strong)  UILabel *marketPriceLabel;

@end

@implementation IntegralHotGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.goodIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
        
        self.goodIV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.goodIV];
        
        CGFloat leftMargin = 15;
        
        //名称
        self.nameLabel = [UILabel labelWithFrame:CGRectMake(leftMargin, self.goodIV.yy + 10, kScreenWidth - 2*leftMargin, [[UIFont secondFont] lineHeight]) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:[UIFont secondFont] textColor:kTextColor];
        [self addSubview:self.nameLabel];
        
        //广告语
        self.descLabel = [UILabel labelWithFrame:CGRectMake(self.nameLabel.x, self.nameLabel.yy + 8, self.nameLabel.width, [FONT(13) lineHeight])
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:FONT(13)
                                       textColor:kTextColor];
        [self addSubview:self.descLabel];
        
        //价格
        self.priceLabel = [UILabel labelWithFrame:CGRectMake(self.nameLabel.x, self.descLabel.yy + 8, self.nameLabel.width, [FONT(14) lineHeight])
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:FONT(14)
                                        textColor:kThemeColor];
        [self addSubview:self.priceLabel];
        
        //市场参考价
        self.marketPriceLabel = [UILabel labelWithFrame:CGRectMake(self.nameLabel.x, self.priceLabel.yy + 8, self.nameLabel.width, [FONT(12) lineHeight])
                                           textAligment:NSTextAlignmentLeft
                                        backgroundColor:[UIColor clearColor]
                                                   font:FONT(12)
                                              textColor:kTextColor];
        [self addSubview:self.marketPriceLabel];
        
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(@0.5);
        }];
        
        
    }
    return self;
}

- (void)setIntegralModel:(GoodModel *)integralModel {
    
    _integralModel = integralModel;
    
    CDGoodsParameterModel *productInfo = _integralModel.productSpecsList[0];
    
    NSString *advPic = [_integralModel.advPic componentsSeparatedByString:@"||"][0];
    
    [_goodIV sd_setImageWithURL:[NSURL URLWithString:[advPic convertImageUrl]] placeholderImage:[UIImage imageNamed:PLACEHOLDER_SMALL]];
    
    _nameLabel.text = _integralModel.name;
    
    _descLabel.text = _integralModel.slogan;
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [[productInfo.price1 stringValue] convertToRealMoney]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:kAppCustomMainColor}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:@" 积分" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor textColor]}];
    [nameString appendAttributedString:countString];
    
    _priceLabel.attributedText = nameString;
    
    _marketPriceLabel.text = [NSString stringWithFormat:@"市场参考价: ￥%@", [[productInfo.originalPrice stringValue] convertToRealMoney]];
}

@end
