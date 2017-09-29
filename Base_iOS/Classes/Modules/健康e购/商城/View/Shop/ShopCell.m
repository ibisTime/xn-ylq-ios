//
//  ShopCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "ShopCell.h"

@interface ShopCell ()

@property (nonatomic,strong) UIImageView *coverImageView;
//
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *advLbl; //广告语

//优惠
//@property (nonatomic,strong) UIImageView *discountImageView;
@property (nonatomic,strong) UILabel *discountLbl;

//优惠
@property (nonatomic,strong) UIImageView *locationImageView;

@property (nonatomic,copy) NSAttributedString *locationAttrStr;

@end

@implementation ShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)rowHeight {
    
    return 96;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpUI];
        
    }
    return self;
}

- (NSAttributedString *)locationAttrStr {
    
    if (!_locationAttrStr) {
        
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"点赞"];
        textAttachment.bounds = CGRectMake(0, -2, 9, 12);
        _locationAttrStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
    }
    return _locationAttrStr;
    
}

- (void)setShop:(ShopModel *)shop {
    
    _shop = shop;
    
    self.zanBtn.selected = _shop.isDZ == YES? YES: NO;

    NSArray *picArr = [_shop.advPic componentsSeparatedByString:@"||"];
    
    if (picArr.count > 0) {
        
        [self.coverImageView sd_setImageWithURL:[[NSURL alloc] initWithString:[picArr[0] convertImageUrl]] placeholderImage:[UIImage imageNamed:PLACEHOLDER_SMALL]];

    }
    
    self.nameLbl.text = _shop.name;
    
    self.advLbl.text = _shop.slogan;
    
    self.discountLbl.text = _shop.address;
    
    //
//    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.locationAttrStr];
//    [mutableAttr appendAttributedString: [[NSAttributedString alloc] initWithString:]];
//    self.distanceLbl.attributedText = mutableAttr;
    
    [self.zanBtn setTitle:[NSString stringWithFormat:@" %ld", _shop.totalDzNum] forState:UIControlStateNormal];
    
}

- (void)setUpUI {
    
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 65)];
    self.coverImageView.layer.borderWidth = 0.5;
    self.coverImageView.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.layer.cornerRadius = 2;
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.coverImageView];
    
    //
    self.nameLbl = [UILabel labelWithFrame:CGRectMake(self.coverImageView.xx + 14, self.coverImageView.y - 1, kScreenWidth - self.coverImageView.xx - 28, 20)
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:[UIFont secondFont]
                                 textColor:[UIColor textColor]];
    self.nameLbl.height = [[UIFont secondFont] lineHeight];
    [self addSubview:self.nameLbl];
    
    //
    self.advLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.nameLbl.yy + 3, self.nameLbl.width, ceilf([FONT(11) lineHeight]*2))
                             textAligment:NSTextAlignmentLeft
                          backgroundColor:[UIColor whiteColor]
                                     font:FONT(11)
                                textColor:[UIColor textColor2]];
    //    self.advLbl.height = [FONT(11) lineHeight];
    self.advLbl.numberOfLines = 2;
    [self addSubview:self.advLbl];
    
    //
    //    self.discountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.nameLbl.x, self.advLbl.yy + 3, 15, 15)];
    //    //抵
    //    self.discountImageView.image = [UIImage imageNamed:@"减"];
    //    [self addSubview:self.discountImageView];
    //
    
    
    //
    //    CGFloat disCountLblW = kScreenWidth - self.discountImageView.xx - 5 - 120;
    
    //点赞
    self.zanBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor textColor] backgroundColor:kClearColor titleFont:11.0];
    
    [self.zanBtn setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    
    [self.zanBtn setImage:[UIImage imageNamed:@"点赞红"] forState:UIControlStateSelected];
    
    [self addSubview:self.zanBtn];
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.advLbl.mas_bottom).offset(3);
        make.height.mas_equalTo(15);
        make.width.mas_lessThanOrEqualTo(100);
    }];

    
    self.discountLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(11)
                                     textColor:[UIColor textColor2]];
    [self addSubview:self.discountLbl];
    
    [self.discountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.advLbl.mas_bottom).offset(3);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-60);
        
    }];
    
    
    
    //    [self.discountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(_discountImageView.mas_right).offset(5);
    //        make.top.equalTo(self.discountImageView.mas_top).offset(5);
    //        make.right.lessThanOrEqualTo(self.distanceLbl.mas_left);
    //    }];
    //
    //    [self.distanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.greaterThanOrEqualTo(self.discountImageView.mas_right);
    //        make.top.equalTo(self.discountLbl.mas_top);
    //        make.right.equalTo(self.mas_right).offset(-15);
    //    }];
    
    //
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, [[self class] rowHeight] - 0.5, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self addSubview:line];
    
}

@end
