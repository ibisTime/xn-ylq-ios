//
//  ZHCartGoodsModel.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/30.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHCartGoodsModel.h"

@implementation ZHCartGoodsModel

- (long )totalRMB {
    
    return [self.productSpecs.price1 doubleValue]*self.quantity;
    
}

@end

@implementation CartProduct

@end


@implementation CartProductspecs

@end


