//
//  ProductModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface ProductModel : BaseModel

@property (nonatomic, copy) NSString *status;           //该产品针对当前用户的状态
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *statusStr;        //产品状态

@property (nonatomic, copy) NSString *uiColor;          //UI颜色

@property (nonatomic, strong) NSNumber *amount;         //借款金额

@property (nonatomic, copy) NSString *slogan;           //广告语

@property (nonatomic, copy) NSString *uiLocation;       //UI位置 仅支持 0-普通列表

@property (nonatomic, copy) NSString *code;             //产品编号

@property (nonatomic, copy) NSString *level;            //产品等级

@property (nonatomic, copy) NSString *isLocked;         //是否锁定 0开放 1锁定
@property (nonatomic, copy) NSString *userProductStatus;//
@property (nonatomic, copy) NSString *borrowCode;       //借款编号

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *approveNote;        //申请状态

@property (nonatomic, assign) NSInteger uiOrder;

@property (nonatomic, assign) NSInteger duration;       //借款时长

@property (nonatomic, strong) NSNumber *fwRate;         //服务费率

@property (nonatomic, strong) NSNumber *fwAmount;       //服务费

@property (nonatomic, strong) NSNumber *yqRate1;        //7天内逾期利率

@property (nonatomic, strong) NSNumber *yqRate2;        //7天外逾期利率

@property (nonatomic, strong) NSNumber *lxRate;         //利率lxRate

@property (nonatomic, strong) NSNumber *lxAmount;       //利息

@property (nonatomic, strong) NSNumber *xsRate;         //快速信审费率

@property (nonatomic, strong) NSNumber *xsAmount;       //快速信审费

@property (nonatomic, strong) NSNumber *glRate;         //账户管理费率

@property (nonatomic, strong) NSNumber *glAmount;       //账户管理费

@end
