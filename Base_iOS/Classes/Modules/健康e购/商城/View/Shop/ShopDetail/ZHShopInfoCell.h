//
//  ZHShopInfoCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

@interface ZHShopInfoCell : UITableViewCell

@property (nonatomic,strong) ShopModel *shop;

@property (nonatomic, strong) UIButton *buyBtn;

@property (nonatomic, strong) UIButton *mobileBtn;

@property (nonatomic,strong) UILabel *addressLbl;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)rowHeight;

@end
