//
//  GoodModel.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/9.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "GoodModel.h"

@implementation GoodModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"productSpecsList" : [CDGoodsParameterModel class]};
    
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"desc"]) {
        return @"description";
    }
    
    return propertyName;
}

- (void)setPic:(NSString *)pic {
    
    
    _pic = [pic copy];
    
}



- (NSArray *)pics {
    
    if (!_pics) {
        
        NSArray *imgs = [self.pic componentsSeparatedByString:@"||"];
        NSMutableArray *newImgs = [NSMutableArray arrayWithCapacity:imgs.count];
        [imgs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [newImgs addObject:[obj  convertImageUrl]];
            
        }];
        
        _pics = newImgs;
        
    }
    
    return _pics;
    
}

- (NSArray<NSNumber *> *)imgHeights {
    
    if (!_imgHeights) {
        
        //未经转换的url
        NSArray *urls = [self.pic componentsSeparatedByString:@"||"];
        NSMutableArray *hs = [NSMutableArray arrayWithCapacity:urls.count];
        
        [urls enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGSize size = [obj imgSizeByImageName:obj];
            CGFloat scale = size.width*1.0/size.height;
            
            [hs addObject:@((kScreenWidth - 30)/scale)];
            
        }];
        _imgHeights = hs;
    }
    return _imgHeights;
}

- (CGFloat)detailHeight {
    
    CGSize size  =  [self.desc calculateStringSize:CGSizeMake(kScreenWidth - 30, 1000) font:FONT(13)];
    
    return size.height + 25;
}



- (NSString *)totalPrice {
    
    
    return [TLCurrencyHelper totalPriceWithQBB:self.currentParameterPriceQBB GWB:self.currentParameterPriceGWB RMB:self.currentParameterPriceRMB];;
    
}

- (NSString *)coverMoney:(NSNumber *)priceNum {
    
    NSInteger pr = [priceNum integerValue];
    CGFloat newPr = pr/1000.0;
    return [NSString stringWithFormat:@"%.1f",newPr];
    
}


//神奇
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"description"]) {
        self.desc = value;
    }
    
}


//

- (NSNumber *)RMB {
    
    if (self.productSpecsList.count > 0) {
        
        return self.productSpecsList[0].price1;
        
    } else {
        
        return @0;
    }
    
}

- (NSNumber *)GWB {
    
    if (self.productSpecsList.count > 0) {
        
        return self.productSpecsList[0].price2;
        
    } else {
        
        return @0;
    }
}


- (NSNumber *)QBB {
    
    if (self.productSpecsList.count > 0) {
        
        return self.productSpecsList[0].price3;
        
    } else  {
        
        return @0;
    }
}

@end

