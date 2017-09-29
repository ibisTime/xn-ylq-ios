//
//  GoodsParameterModel.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/9.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "GoodsParameterModel.h"
#import "TLCurrencyHelper.h"
@implementation GoodsParameterModel

+ (NSString *)randomCode {
    
    return [NSString stringWithFormat:@"%f%u",[[NSDate date] timeIntervalSince1970],arc4random()%1000
            ];
    
}

- (NSString *)getCountDesc {
    
    
    return [NSString stringWithFormat:@"库存%@件",self.quantity];
    
}

- (NSString *)getPrice {
    
    return [TLCurrencyHelper totalPriceWithQBB:self.price3 GWB:self.price2 RMB:self.price1];
}

- (NSString *)getDetailText {
    
    //    return [NSString stringWithFormat:@"%@ 人民币/%@  购物币/%@ 钱包币/%@\n重量：%@kg  库存：%@  发货地:%@",self.name,[self.price1 convertToRealMoney],[self.price2 convertToRealMoney],[self.price3 convertToRealMoney],self.weight,self.quantity,self.province];
    
    return [NSString stringWithFormat:@" %@ ",self.name];
    
}

- (NSDictionary *)toDictionry {
    
    NSDictionary *dict = @{
                           
                           @"code" : self.code,
                           @"name" : self.name,
                           @"price1" : self.price1,
                           @"price2" : self.price2,
                           @"price3" : self.price3,
                           @"quantity" : self.quantity,
                           @"province" : self.province,
                           @"weight" : self.weight,
                           
                           
                           };
    
    return dict;
    
}

@end
