//
//  LoanOrderListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,LoanOrderStatus) {
    
    LoanOrderStatusWillLoan = 0,        //待放款
    LoanOrderStatusDidLoan = 1,         //生效中
    LoanOrderStatusDidOverdue = 2 ,      //已逾期
    LoanOrderStatusDidRepayment = 3,    //已还款
    
};

@interface LoanOrderListVC : BaseViewController

@property (nonatomic,assign) LoanOrderStatus status;

@property (nonatomic,copy) NSString *statusCode;

@end
