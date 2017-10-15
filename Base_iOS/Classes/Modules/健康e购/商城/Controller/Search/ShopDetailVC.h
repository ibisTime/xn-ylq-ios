//
//  ShopDetailVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopModel.h"
#import "ZHOrderModel.h"

typedef NS_ENUM(NSInteger, DetailType) {

    DetailTypeDefault = 0,
    DetailTypeHotel,
};

@interface ShopDetailVC : BaseViewController

@property (nonatomic,strong) ZHOrderModel *order;

@property (nonatomic,strong) ShopModel *shop;

@property (nonatomic, assign) DetailType detaileType;

@end
