//
//  LoanOrderListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,LoanOrderStatus) {
    
    LoanOrderStatusWillAudit = 0,       //待审核
    LoanOrderStatusAuditFailure = 1,    //审核失败
    LoanOrderStatusWillLoan = 2,        //待放款
    LoanOrderStatusMoneyFailure = 3,    //打款失败
    LoanOrderStatusDidLoan = 4,         //待还款
    LoanOrderStatusDidRepayment = 5,    //已还款
    LoanOrderStatusDidOverdue = 6,      //已逾期
};

@interface LoanOrderListVC : BaseViewController

@property (nonatomic,assign) LoanOrderStatus status;

@property (nonatomic,copy) NSString *statusCode;

@end
