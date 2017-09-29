//
//  SignContractVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductModel.h"
#import "CouponModel.h"

@interface SignContractVC : BaseViewController

@property (nonatomic, strong) ProductModel *good;

@property (nonatomic, strong) CouponModel *coupon;

@end
