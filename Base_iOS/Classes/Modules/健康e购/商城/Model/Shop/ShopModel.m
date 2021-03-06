//
//  ShopModel.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "ShopModel.h"

#define ZH_SHOP_INFO_KEY @"ZH_SHOP_INFO_KEY"


NSString *const kShopOpenStatus = @"2";
NSString *const kShopInfoChange = @"zh_shop_info_change";

@interface ShopModel ()

@property (nonatomic,copy) NSDictionary *typeDict;

@end

@implementation ShopModel

- (CGFloat)sloganHeight {
    
    if (!self.slogan || self.slogan.length <= 0) {
        
        return 0;
    }
    
    
    return [self.slogan calculateStringSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:FONT(12)].height + 15 + 5;
    
}

//- (CGFloat)sloganHeight {
//    
//    if (!self.desc || self.desc.length <= 0) {
//        
//        return 0;
//    }
//    
//    
//    return [self.desc calculateStringSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:FONT(12)].height + 15 + 5;
//    
//}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"descriptionShop"]) {
        return @"description";
    }
    
    return propertyName;
}

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"storeTickets":[Coupon class]};
    
}

- (NSDictionary *)typeDict {
    
    if (!_typeDict) {
        _typeDict = @{
                      @"1" : @"美食",
                      @"2" : @"KTV",
                      @"3" : @"电影",
                      @"4" : @"酒店",
                      @"5" :@"休闲娱乐",
                      @"6" :@"汽车",
                      @"7" :@"周边游",
                      @"8" :@"足疗按摩",
                      @"9" : @"生活服务",
                      @"10" : @"旅游"
                      };
    }
    return _typeDict;
    
}

- (NSString *)discountDescription {
    
    //找到最优
    if (self.storeTickets.count > 0) {
        
        
        self.storeTickets = [self.storeTickets sortedArrayUsingComparator:^NSComparisonResult(Coupon * obj1, Coupon *  obj2) {
            
            NSInteger re = [obj1.key2 longLongValue]*1.0/[obj1.key1 longLongValue] -  [obj2.key2 longLongValue]*1.0/[obj2.key1 longLongValue];
            if (re > 0) {
                
                return NSOrderedAscending;
                
            } else {
                return NSOrderedDescending;
            }
            
        }];
        
        Coupon *coupon = self.storeTickets[0];
        return [NSString stringWithFormat:@"满 %@ 减 %@",[coupon.key1 convertToSimpleRealMoney],[coupon.key2 convertToSimpleRealMoney]];
        
        
    } else {
        
        return @"该店铺暂无优惠券";
        
    }
    
}

- (NSString *)distanceDescription {
    
    if (self.distance) {
        
        if ([self.distance floatValue] > 1000) {
            
            NSString *disStr = [NSString stringWithFormat:@"%.2f",[self.distance floatValue]/1000.0];
            return [NSString stringWithFormat:@" %@ KM",disStr];
            
        } else {
            
            return [NSString stringWithFormat:@" %@ M",self.distance];
            
        }
        
    } else {
        
        return @" 未知";
    }
    //    return @" 3.7KM";
    
    
}

//
//- (BOOL)getInfo {
//
//  NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:ZH_SHOP_INFO_KEY];
//
//    if (dict) {
//
//        [self changShopInfoWithDict:dict];
//        return YES;
//
//    } else {
//
//        return NO;
//    }
//}

- (void)changShopInfoWithDict:(NSDictionary *)dict {
    
    [self setValuesForKeysWithDictionary:dict];
    //存储信息
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:ZH_SHOP_INFO_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"description"]) {
        self.descriptionShop = value;
    }
    
}



- (NSString *)getCoverImgUrl {
    
    return [self.advPic convertImageUrl];
    
}




- (NSString *)getStatusName {
    
    NSDictionary *dict =  @{
                            @"0" : @"待审核",
                            @"1" : @"待上架",
                            @"2" : @"开店",
                            @"3" : @"关店",
                            @"91" : @"审核不通过",
                            
                            };
    return dict[self.status];
}

- (NSString *)getTypeName{
    
    
    return self.typeDict[self.type];
    
}




- (CGFloat)detailHeight {
    
    CGSize size  =  [self.descriptionShop calculateStringSize:CGSizeMake(kScreenWidth - 30, 1000) font:FONT(13)];
    
    return size.height + 5 + 20;
}

- (NSArray *)detailPics {
    
    if (!_detailPics) {
        
        _detailPics = [self.pic componentsSeparatedByString:@"||"];
        
    }
    return _detailPics;
}

- (NSArray<NSNumber *> *)imgHeights {
    
    if (!_imgHeights) {
        
        NSArray *urls = self.detailPics;
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


+ (void)getShopInfoWithToken:(NSString *)token userId:(NSString *)userId showInfoView:(UIView *)view success:(void(^)(NSDictionary *shopDict))success failure:(void(^)(NSError *error))failure {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"808215";
    http.isShowMsg = YES;
    if (view) {
        
        http.showView = view;
        
    }
    
    http.parameters[@"userId"] = userId;
    http.parameters[@"token"] = token;
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *array = responseObject[@"data"];
        if (array.count > 0) {
            
            if (success) {
                success(array[0]);
            }
            
        } else {
            
            if (success) {
                success(nil);
            }
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

@end
