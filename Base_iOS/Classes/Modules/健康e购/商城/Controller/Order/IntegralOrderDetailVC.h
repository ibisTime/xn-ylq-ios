//
//  IntegralOrderDetailVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/18.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "TLBaseVC.h"
#import "ZHOrderModel.h"

@interface IntegralOrderDetailVC : TLBaseVC

@property (nonatomic,strong) ZHOrderModel *order;

@property (nonatomic,copy) void(^paySuccess)();
@property (nonatomic,copy) void(^cancleSuccess)();
@property (nonatomic,copy) void(^confirmReceiveSuccess)();

@end
