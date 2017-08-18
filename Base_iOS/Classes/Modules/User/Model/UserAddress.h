//
//  UserAddress.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface UserAddress : BaseModel

@property (nonatomic,strong) NSString *code;

@property (nonatomic,strong) NSString *addressee; //收货人
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *district;

@property (nonatomic,strong) NSString *detailAddress;

@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *userId;

@property (nonatomic,copy) NSString *totalAddress;

//是否是 -- 临时选择
@property (nonatomic,assign) BOOL isSelected;

@end
