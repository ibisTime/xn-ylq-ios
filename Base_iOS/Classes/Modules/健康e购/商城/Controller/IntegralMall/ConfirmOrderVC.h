//
//  ConfirmOrderVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/18.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "TLBaseVC.h"
#import "GoodModel.h"
#import "ZHCartGoodsModel.h"

typedef NS_ENUM(NSInteger,ZHIMBuyType){
    
    ZHIMBuyTypeSingle = 0 ,//单个商品
    ZHIMBuyTypeAll, //购物车商品
    
};

@interface ConfirmOrderVC : TLBaseVC

@property (nonatomic,assign) ZHIMBuyType type;

//普通商品
@property (nonatomic,strong) NSArray <GoodModel *>*goodsRoom;


//购物车专用
@property (nonatomic,copy) NSAttributedString *priceAttr;
@property (nonatomic,copy) NSAttributedString *priceAttrAddPostage;

@property (nonatomic, strong) NSArray <ZHCartGoodsModel *>*cartsRoom;

@property (nonatomic,copy) void(^placeAnOrderSuccess)();

@property (nonatomic, strong) NSNumber *postage;

@end
