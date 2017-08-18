//
//  RepaymentVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"

@interface RepaymentVC : BaseViewController

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic,copy) void(^paySucces)();

@end
