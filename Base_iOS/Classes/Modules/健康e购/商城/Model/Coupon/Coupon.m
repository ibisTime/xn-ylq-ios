//
//  Coupon.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/9.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "Coupon.h"

@implementation Coupon

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"description"]) {
        if (value) {
            
            self.desc = value;
            
        }
    }
    
}

- (NSAttributedString *)discountInfoDescription01IsIng:(BOOL)isIng {
    
    NSString *prc1;
    NSString *prc2;
    
    prc1 = [self.key1 convertToSimpleRealMoney];
    prc2 = [self.key2 convertToSimpleRealMoney];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"满 %@ 减 %@",prc1,prc2]];
    if (isIng) {
        
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor themeColor] range:NSMakeRange(2, prc1.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor themeColor] range:NSMakeRange(2 + prc1.length + 3 , prc2.length)];
    }
    
    return attrStr;
    
    
    
}

- (NSString *)discountInfoDescription01 {
    
    return [NSString stringWithFormat:@"满 %@ 减 %@",[self.key1 convertToSimpleRealMoney],[self.key2 convertToSimpleRealMoney]];
    
    
}
- (NSString *)discountInfoDescription02 {
    
    return [NSString stringWithFormat:@"满 %@\n减 %@",[self.key1 convertToSimpleRealMoney],[self.key2 convertToSimpleRealMoney]];
    
}


@end
