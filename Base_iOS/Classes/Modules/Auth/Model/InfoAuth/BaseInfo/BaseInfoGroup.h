//
//  BaseInfoGroup.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
#import "BaseInfoModel.h"

@interface BaseInfoGroup : BaseModel

@property (nonatomic,copy) NSArray <BaseInfoModel *>*items;

@property (nonatomic, copy) NSArray *groups;    //分组

@end
