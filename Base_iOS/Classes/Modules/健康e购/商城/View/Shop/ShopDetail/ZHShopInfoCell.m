//
//  ZHShopInfoCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShopInfoCell.h"

@interface ZHShopInfoCell()

@property (nonatomic,strong) UIImageView *addressIV;

@property (nonatomic,strong) UIImageView *mobileIV;

@end


@implementation ZHShopInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {

    static  NSString * reCellId = @"ZHShopInfoCellID";
    ZHShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reCellId];
    if (!cell) {
        
        cell = [[ZHShopInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reCellId];
        
    }
    return cell;

}

+ (CGFloat)rowHeight {

    return 70;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        lineView.backgroundColor = [UIColor lineColor];
        [self.contentView addSubview:lineView];
        
        self.addressIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 9, 12)];
        [self.contentView addSubview:self.addressIV];
        
        self.addressIV.image = [UIImage imageNamed:@"定位"];

        self.addressLbl = [UILabel labelWithText:@"" textColor:[UIColor textColor] textFont:12.0];
        self.addressLbl.userInteractionEnabled = YES;
        
        [self.contentView addSubview:self.addressLbl];
        [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.addressIV.mas_right).mas_equalTo(6);
            make.width.mas_lessThanOrEqualTo(200);
            make.height.mas_lessThanOrEqualTo(20);
            make.top.mas_equalTo(self.addressIV.mas_top);
            
        }];
        
        self.mobileIV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.mobileIV];
        [self.mobileIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.addressIV.mas_bottom).mas_equalTo(16);
            make.width.mas_equalTo(9);
            make.height.mas_equalTo(12);
            make.left.mas_equalTo(self.addressIV.mas_left);
            
        }];
        
        self.mobileIV.image = [UIImage imageNamed:@"call_green"];
        
        self.mobileBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor textColor] backgroundColor:kWhiteColor titleFont:12.0];
        
        [self.mobileBtn setEnlargeEdgeWithTop:0 right:10 bottom:5 left:10];
        
        [self.contentView addSubview:self.mobileBtn];
        [self.mobileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.mobileIV.mas_right).mas_equalTo(6);
            make.width.mas_lessThanOrEqualTo(200);
            make.height.mas_lessThanOrEqualTo(14);
            make.top.mas_equalTo(self.mobileIV.mas_top).mas_equalTo(-1);
            
        }];
        
        self.buyBtn = [UIButton buttonWithTitle:@"买单" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:14.0 cornerRadius:5];
        
        [self.contentView addSubview:self.buyBtn];
        [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(0);
            
        }];
    }
    return self;

}

- (void)setShop:(ShopModel *)shop {

    _shop = shop;
    
    self.addressLbl.text = _shop.address;
    
    [self.mobileBtn setTitle:_shop.bookMobile forState:UIControlStateNormal];

}

@end
