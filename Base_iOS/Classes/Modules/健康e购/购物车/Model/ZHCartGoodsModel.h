//
//  ZHCartGoodsModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/30.
//  Copyright © 2016年  tianlei. All rights reserved.
//  购物车商品   模型

#import <Foundation/Foundation.h>
#import "GoodModel.h"

@class CartProduct,CartProductspecs;

@interface ZHCartGoodsModel : TLBaseModel

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) NSInteger quantity;

@property (nonatomic, strong) CartProduct *product;

@property (nonatomic, strong) CartProductspecs *productSpecs;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *productCode;

@property (nonatomic, copy) NSString *productSpecsCode;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic,strong,readonly) NSNumber *rmb; //人民币

//购买选择数量后，设置的数量
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, strong) NSNumber *currentParameterPriceRMB;
@property (nonatomic, strong) NSNumber *currentParameterPriceQBB;
@property (nonatomic, strong) NSNumber *currentParameterPriceGWB;

//计算属性，根据商品数量进行的计算
@property (nonatomic,assign) long totalRMB;

//附属判断，购物车选择我时
@property (nonatomic,assign) BOOL isSelected;

@end

@interface CartProduct : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *storeCode;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *advPic;

@end

@interface CartProductspecs : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) NSInteger quantity;

@property (nonatomic, assign) NSInteger originalPrice;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSNumber *price1;

@end

