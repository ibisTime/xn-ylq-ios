//
//  BaseInfoModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/9.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface BaseInfoModel : BaseModel

@property (nonatomic,strong) NSString *imgName;
@property (nonatomic,strong) NSString *text;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic,strong) void(^action)();
@property (nonatomic, assign) BOOL isAuth;


@end
