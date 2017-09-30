//
//  TableViewManager.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/18.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseModel.h"
#import "TableViewModel.h"

@interface TableViewManager : BaseModel

@property (nonatomic, strong) NSArray <TableViewModel *>*items;

@end
