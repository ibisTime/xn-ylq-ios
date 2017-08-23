//
//  CouponModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface CouponModel : BaseModel

@property (nonatomic, strong) NSNumber *amount;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) NSInteger condition;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *couponId;

@property (nonatomic, assign) NSInteger validDays;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSNumber *startAmount;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *invalidDatetime;  //截止日期

@property (nonatomic, copy) NSString *updater;

@end
