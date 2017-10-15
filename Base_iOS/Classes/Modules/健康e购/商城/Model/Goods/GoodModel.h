//
//  GoodModel.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/9.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseModel.h"
#import "CDGoodsParameterModel.h"

@protocol CurrencyProtocol <NSObject>

@optional

- (NSNumber *)RMB;
- (NSNumber *)GWB;
- (NSNumber *)QBB;

@optional

- (NSNumber *)payRMB;
- (NSNumber *)payGWB;
- (NSNumber *)payQBB;

@end

@interface GoodModel : BaseModel<CurrencyProtocol>

@property (nonatomic,copy) NSString *advPic; //封面图片
@property (nonatomic, strong) NSNumber *boughtCount;
@property (nonatomic,copy) NSString *slogan;
@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *companyCode;
@property (nonatomic,copy) NSString *costPrice;
@property (nonatomic,copy) NSString *location;

@property (nonatomic,copy) NSString *desc;
//@property (nonatomic,copy) NSString *description;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *pic;

@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,strong) NSNumber *quantity;
// 0 已提交 1.审批通过 2.审批不通过 3.已上架 4.已下架
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *type;

//由pic1 转化成的 数组,eg: http://wwwa.dfdsf.dcom
@property (nonatomic,copy) NSArray *pics;
@property (nonatomic, copy) NSArray <CDGoodsParameterModel*> *productSpecsList;

@property (nonatomic, strong) CDGoodsParameterModel *selectedParameter;

//price 1 人民币 price2 购物币，price 3 钱包币

///**
// 人民币
// */
//@property (nonatomic,strong) NSNumber *price1; //人民币
//
///**
// 购物
// */
//@property (nonatomic,strong) NSNumber *price2; //购物币
//
//
///**
// 钱宝币
// */
//@property (nonatomic,strong) NSNumber *price3; //钱包币


//购买选择数量后，设置的数量
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, strong) NSNumber *currentParameterPriceRMB;
@property (nonatomic, strong) NSNumber *currentParameterPriceQBB;
@property (nonatomic, strong) NSNumber *currentParameterPriceGWB;


/**
 合并后的价格
 */
@property (nonatomic,copy,readonly) NSString *totalPrice;



//图片高度存储,计算得到
@property (nonatomic,strong) NSArray <NSNumber *>* imgHeights;
- (CGFloat)detailHeight;


@end

