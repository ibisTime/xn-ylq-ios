//
//  OrderModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
#import "RenewalModel.h"
@class UserInfo;

@interface OrderModel : BaseModel

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, assign) NSInteger yqDays;

@property (nonatomic, strong) NSNumber *amount;

@property (nonatomic, strong) NSNumber *lxAmount;

@property (nonatomic, strong) NSNumber *fwAmount;

@property (nonatomic, strong) NSNumber *xsAmount;

@property (nonatomic, strong) NSNumber *totalAmount;    //到期还款额

@property (nonatomic, strong) NSNumber *yhAmount;       //优惠金额

@property (nonatomic, strong) NSNumber *yqlxAmount;     //逾期利息

@property (nonatomic, assign) CGFloat rate1;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *approveNote;      //审核不通过说明
@property (nonatomic, copy) NSString *remark;           //状态说明

@property (nonatomic, strong) NSString *resc;           //订单状态

@property (nonatomic, strong) NSString *imageStr;          //状态对应的图片

@property (nonatomic, copy) NSString *applyUser;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, strong) NSNumber *glAmount;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, strong) UserInfo *user;

@property (nonatomic, assign) CGFloat rate2;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *signDatetime;     //签约日期

@property (nonatomic, copy) NSString *realHkDatetime;   //实际还款日期

@property (nonatomic, copy) NSString *hkDatetime;       //约定还款日期

@property (nonatomic, copy) NSString *fkDatetime;       //放款日期

@property (nonatomic, copy) NSString *jxDatetime;       //计息日

@property (nonatomic, copy) NSString *renewalStartDate; //起始日期

@property (nonatomic, copy) NSString *renewalEndDate;   //结束日期

@property (nonatomic, strong) NSNumber *renewalAmount;  //续期金额

@property (nonatomic, assign) NSInteger renewalCount;   //续期次数

@property (nonatomic, copy) NSString *isStage; //是否分期

@property (nonatomic, copy) NSString* stageCount;   //当前期数

@property (nonatomic, copy) NSNumber *realHkAmount; //总还款

@property (nonatomic, copy) NSNumber *stageBatch; //分期数


@property (nonatomic ,strong) NSMutableArray *stageList;
@property (nonatomic ,strong) RenewalModel *info;



@end

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *identityFlag;

@property (nonatomic, copy) NSString *kind;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *systemCode;




@end

