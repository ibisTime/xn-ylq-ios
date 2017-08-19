//
//  QuotaModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface QuotaModel : BaseModel

@property (nonatomic, strong) NSNumber *sxAmount;

@property (nonatomic, copy) NSString *vaildDatetime;

@property (nonatomic, assign) NSInteger validDays;

@end
