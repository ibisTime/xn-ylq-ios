//
//  RenewalModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface RenewalModel : BaseModel


@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) NSInteger step;               //续期时长
@property (nonatomic, strong) NSNumber *lxAmount;

@property (nonatomic, copy) NSString *payType;

@property (nonatomic, strong) NSNumber *yqAmount;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, assign) NSInteger cycle;              //周期

@property (nonatomic, copy) NSString *payDatetime;          //支付事件

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, assign) NSInteger curNo;

@property (nonatomic, copy) NSString *borrowCode;

@property (nonatomic, copy) NSString *payCode;

@property (nonatomic, copy) NSString *payGroup;

@property (nonatomic, copy) NSString *applyUser;

@property (nonatomic, strong) NSNumber *glAmount;

@property (nonatomic, copy) NSString *startDate;

@property (nonatomic, strong) NSNumber *fwAmount;

@property (nonatomic, strong) NSNumber *totalAmount;        //续期金额
@property (nonatomic, strong) NSNumber *xsAmount;

@property (nonatomic, strong) NSNumber *mainAmount;

@property (nonatomic, strong) NSNumber *amount;



@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *stageCode;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *stageCount;//总期数



@end
