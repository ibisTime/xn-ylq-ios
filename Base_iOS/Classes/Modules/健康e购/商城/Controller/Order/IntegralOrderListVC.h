//
//  IntegralOrderListVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/17.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,ZHOrderStatus){
    
    ZHOrderStatusAll = 0, //全部
    ZHOrderStatusWillPay = 1, //待支付支付
    ZHOrderStatusWillSend = 2, //待发货
    ZHOrderStatusDidPay = 3 //已经支付
    
};

@interface IntegralOrderListVC : BaseViewController

@property (nonatomic,assign) ZHOrderStatus status;
@property (nonatomic,copy) NSString *statusCode;

@end
