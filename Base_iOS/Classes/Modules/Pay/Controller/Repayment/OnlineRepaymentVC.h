//
//  OnlineRepaymentVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"

@interface OnlineRepaymentVC : BaseViewController

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic,copy) void(^paySucces)();

@end
