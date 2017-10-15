//
//  GoodsParameterModel.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/9.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsParameterModel : BaseModel

//已存在的为从服务器获取, 新增的为自己生成
@property (nonatomic, strong) NSString *code;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSNumber *price1;
@property (nonatomic, strong) NSNumber *price2;
@property (nonatomic, strong) NSNumber *price3;

@property (nonatomic, strong) NSNumber *quantity;

@property (nonatomic, strong) NSNumber *originalPrice;

@property (nonatomic, strong) NSString *province; //市
@property (nonatomic, strong) NSString *weight; //重量

- (NSDictionary *)toDictionry;

- (NSString *)getDetailText;
- (NSString *)getPrice;
+ (NSString *)randomCode;
- (NSString *)getCountDesc;

@end
