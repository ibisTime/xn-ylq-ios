//
//  ShopCell.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

@interface ShopCell : UITableViewCell

@property (nonatomic,strong) ShopModel *shop;

@property (nonatomic, strong) UIButton *zanBtn;

+ (CGFloat)rowHeight;

@end
