//
//  SpecialMallVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/7/11.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "TLBaseVC.h"
typedef NS_ENUM(NSInteger, SpecialGoodType) {

    SpecialGoodTypeSpecialPrice = 0,    //今日特价
    SpecialGoodTypePopularOffer,        //人气推荐
    SpecialGoodTypeHotSale,             //超值热卖
};

@interface SpecialMallVC : TLBaseVC

@property (nonatomic, assign) SpecialGoodType goodType;

- (void)startLoadData;

@end
